# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

MimiruオーディオストリーミングプラットフォームをAWSにデプロイするためのTerraform Infrastructure as Codeプロジェクトです。ECS Fargateコンテナ、RDS PostgreSQL、S3/CloudFrontによるオーディオファイル配信、GitHub Actions CI/CD統合を含みます。

## よく使うコマンド

### インフラ管理
```bash
# Terraformの初期化（クローン後やプロバイダー変更時に実行）
terraform init

# 変更計画の確認（apply前に必ず実行）
terraform plan

# インフラの変更を適用
terraform apply

# すべてのインフラを削除
terraform destroy

# 現在の状態を表示
terraform state list

# 特定のリソースの詳細を表示
terraform state show <リソース名>

# すべてのTerraformファイルをフォーマット
terraform fmt -recursive

# 設定の検証
terraform validate
```

### アウトプット管理
```bash
# すべてのアウトプットを表示
terraform output

# 特定のアウトプットをJSON形式で表示
terraform output -json <アウトプット名>

# GitHub Secretsの設定を取得
terraform output github_secrets
```

## アーキテクチャ概要

このインフラは以下の本番環境対応AWS環境を構築します：

1. **ネットワーク層** (vpc.tf):
   - 2つのAZにまたがるパブリック/プライベートサブネットを持つVPC
   - プライベートサブネットのインターネットアクセス用NAT Gateway
   - 最小権限アクセスのセキュリティグループ

2. **コンピュート層** (ecs.tf):
   - コンテナ化されたAPIを実行するECS Fargateクラスター
   - オートスケーリング機能
   - Container Insights有効

3. **データ層** (rds.tf, s3.tf):
   - Multi-AZ構成のRDS PostgreSQL 15.4
   - バージョニング付きオーディオファイルストレージ用S3バケット
   - 30日保持の自動バックアップ

4. **コンテンツ配信** (cloudfront.tf):
   - オーディオファイル用CloudFrontディストリビューション
   - セキュアなS3アクセス用Origin Access Identity
   - 保護されたコンテンツ用署名付きURL機能

5. **CI/CD統合** (github_oidc.tf):
   - GitHub ActionsとのOIDC信頼関係
   - 自動デプロイ用IAMロール
   - ECRプッシュとECS更新の権限

## 重要な設定ファイル

- **terraform.tfvars**: メイン設定（terraform.tfvars.exampleから作成）
- **main.tf**: プロバイダー設定と共通変数
- **outputs.tf**: アプリケーションデプロイに必要な値

## 重要なセットアップ手順

1. **CloudFrontキー生成**（初回apply前に必須）：
   ```bash
   openssl genrsa -out cloudfront-private-key.pem 2048
   openssl rsa -in cloudfront-private-key.pem -pubout -out cloudfront-public-key.pem
   ```

2. **設定要件**：
   - ユニークなS3バケット名（グローバルで一意）
   - 強力なRDSパスワード
   - API認証用JWTシークレット
   - アプリケーション用AWSクレデンシャル

3. **apply後の要件**：
   - terraform output値でGitHub Secretsを設定
   - RDSエンドポイントでアプリケーション設定を更新
   - アプリケーションでCloudFrontディストリビューションIDを設定

## セキュリティ考慮事項

- RDSはプライベートサブネットからのみアクセス可能
- S3バケットはすべてのパブリックアクセスをブロック
- シークレットはAWS Secrets Managerに保存
- すべてのデータは保存時に暗号化
- すべての接続でTLS/SSL強制

## コスト最適化のヒント

- 適用前に`terraform plan`で変更をプレビュー
- NAT Gatewayのデータ転送を監視（最大のコスト要因）
- 開発環境では小さいRDSインスタンスの使用を検討
- 古いオーディオファイル用のS3ライフサイクルポリシーを有効化
- CloudWatchログ保持設定を確認

## デプロイ手順

### 初回セットアップ

1. **インフラ構築**:
   ```bash
   # CloudFrontキーペア生成
   openssl genrsa -out cloudfront-private-key.pem 2048
   openssl rsa -in cloudfront-private-key.pem -pubout -out cloudfront-public-key.pem
   
   # 設定ファイル作成・編集
   cp terraform.tfvars.example terraform.tfvars
   # terraform.tfvarsの値を設定
   
   # Terraform実行
   terraform init
   terraform plan
   terraform apply
   ```

2. **GitHub Secrets設定**:
   ```bash
   # 必要な値を出力
   terraform output github_secrets
   ```
   以下をGitHub Secretsに設定:
   - `AWS_ACCOUNT_ID`
   - `TARGET_GROUP_ARN`
   - `PRIVATE_SUBNET_1`
   - `PRIVATE_SUBNET_2`
   - `ECS_SECURITY_GROUP`

### 自動デプロイ（GitHub Actions）

**バックエンドリポジトリ（radio_site_backend）** でワークフローファイルを作成:

```yaml
# .github/workflows/deploy-prod.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/mimiru-gha-deploy-role
          aws-region: ap-northeast-1
      
      - name: Login to ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      
      - name: Build and push image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: mimiru-api
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
      
      - name: Deploy to ECS
        run: |
          # ecspressoまたはaws cliでデプロイ
          aws ecs update-service --cluster mimiru-cluster --service mimiru-api-service --force-new-deployment
```

### 手動デプロイ

```bash
# ECRログイン
aws ecr get-login-password --region ap-northeast-1 | \
  docker login --username AWS --password-stdin \
  [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com

# イメージビルド・プッシュ
docker build -t mimiru-api .
docker tag mimiru-api:latest \
  [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/mimiru-api:latest
docker push [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/mimiru-api:latest

# ECSサービス更新
aws ecs update-service \
  --cluster mimiru-cluster \
  --service mimiru-api-service \
  --force-new-deployment
```

### デプロイ確認

```bash
# ECSサービス状態確認
aws ecs describe-services \
  --cluster mimiru-cluster \
  --services mimiru-api-service

# ALBターゲットグループ確認
aws elbv2 describe-target-health \
  --target-group-arn [TARGET_GROUP_ARN]

# CloudWatchログ確認
aws logs tail /ecs/mimiru-api --follow
```

## トラブルシューティング

### インフラ関連
- **ステートロック問題**: リモートステート使用時はS3バックエンドを確認
- **権限エラー**: AWSクレデンシャルとIAM権限を確認
- **リソース競合**: 同名の既存リソースを確認
- **サブネット容量**: サブネット内の十分なIPアドレスを確保

### デプロイ関連
- **OIDCエラー**: GitHub ActionsのOIDC設定とIAMロールの信頼関係を確認
- **ECRプッシュ失敗**: IAMポリシーでECR権限を確認
- **ECSタスク起動失敗**: タスク定義のリソース制限とセキュリティグループを確認
- **ヘルスチェック失敗**: ALBのヘルスチェック設定とアプリケーションのヘルス向けエンドポイントを確認