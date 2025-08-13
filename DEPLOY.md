# Mimiru デプロイガイド

## 概要

このドキュメントでは、MimiruオーディオストリーミングプラットフォームのAWSインフラ構築からアプリケーションデプロイまでの詳細な手順を説明します。

## 前提条件

- AWS CLI設定済み（適切なIAM権限を持つ）
- Terraform >= 1.0インストール済み
- Docker インストール済み
- GitHub リポジトリへのアクセス権限

## 1. インフラ構築

### 1.1 初期設定

```bash
# リポジトリをクローン
git clone [terraform-repository-url]
cd mimiru-terraform

# AWS CLI設定確認
aws sts get-caller-identity
```

### 1.2 CloudFrontキーペア生成

```bash
# 秘密鍵を生成
openssl genrsa -out cloudfront-private-key.pem 2048

# 公開鍵を生成
openssl rsa -in cloudfront-private-key.pem -pubout -out cloudfront-public-key.pem

# 公開鍵をAWS CloudFrontに登録（手動）
# AWS Console > CloudFront > Public keys で公開鍵を登録
# 生成されたキーIDをメモ
```

### 1.3 設定ファイル準備

```bash
# 設定テンプレートをコピー
cp terraform.tfvars.example terraform.tfvars

# 設定ファイルを編集
vim terraform.tfvars
```

**terraform.tfvars の設定例**:
```hcl
aws_region = "ap-northeast-1"
project_name = "mimiru"

# GitHub設定
github_org = "your-org"
github_repo = "radio_site_backend"

# データベース設定
db_password = "SecurePassword123!"

# JWT認証
jwt_secret = "your-jwt-secret-key-at-least-32-characters"

# S3設定（グローバルで一意の名前）
s3_bucket_name = "mimiru-audio-storage-20240101"

# アプリケーション用AWS認証情報
aws_access_key_id = "AKIAIOSFODNN7EXAMPLE"
aws_secret_access_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# CloudFront秘密鍵
cloudfront_private_key = <<EOF
-----BEGIN RSA PRIVATE KEY-----
[cloudfront-private-key.pemの内容をコピー]
-----END RSA PRIVATE KEY-----
EOF
```

### 1.4 Terraform実行

```bash
# 初期化
terraform init

# プランの確認（実行内容を確認）
terraform plan

# 実行（約15-20分かかります）
terraform apply

# 完了後、重要な出力値を確認
terraform output
```

## 2. GitHub Actions設定

### 2.1 GitHub Secrets設定

```bash
# Terraform出力から必要な値を取得
terraform output github_secrets
```

以下の値をGitHubリポジトリのSecrets（Settings > Secrets and variables > Actions）に設定:

- **AWS_ACCOUNT_ID**: AWSアカウントID
- **TARGET_GROUP_ARN**: ALBターゲットグループのARN
- **PRIVATE_SUBNET_1**: プライベートサブネット1のID
- **PRIVATE_SUBNET_2**: プライベートサブネット2のID
- **ECS_SECURITY_GROUP**: ECSセキュリティグループのID

### 2.2 バックエンドリポジトリの準備(もうできてるからスキップ)

## 3. デプロイ実行

### 3.1 自動デプロイ

```bash
git add .
git commit -m "Deploy to production"
git push origin main
```

### 3.2 手動デプロイ

```bash
# AWS認証情報設定
export AWS_ACCOUNT_ID=[your-account-id]
export AWS_REGION=ap-northeast-1

# ECRにログイン
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin \
  $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# イメージをビルド
docker build -t mimiru-api .

# ECRにプッシュ
IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/mimiru-api:$(git rev-parse HEAD)
docker tag mimiru-api:latest $IMAGE_URI
docker push $IMAGE_URI

# ECSサービスを更新
aws ecs update-service \
  --cluster mimiru-cluster \
  --service mimiru-api-service \
  --force-new-deployment

# デプロイ完了を待機
aws ecs wait services-stable \
  --cluster mimiru-cluster \
  --services mimiru-api-service
```

## 4. デプロイ後の確認

### 4.1 サービス状態確認

```bash
# ECSサービス状態
aws ecs describe-services \
  --cluster mimiru-cluster \
  --services mimiru-api-service

# ALBターゲットの健全性
aws elbv2 describe-target-health \
  --target-group-arn [TARGET_GROUP_ARN]

# アプリケーションログ
aws logs tail /ecs/mimiru-api --follow
```

### 4.2 動作確認

```bash
# ALBのDNS名を取得
ALB_DNS=$(terraform output alb_dns_name)

# ヘルスチェック
curl -f http://$ALB_DNS/health

# API動作確認
curl -X GET http://$ALB_DNS/api/status
```

## 5. トラブルシューティング

### 5.1 一般的な問題と解決方法

#### GitHub Actions エラー

**OIDCエラー**: 
```bash
# IAMロールの信頼関係を確認
aws iam get-role --role-name mimiru-gha-deploy-role
```

**ECRプッシュエラー**:
```bash
# ECRリポジトリの存在確認
aws ecr describe-repositories --repository-names mimiru-api

# IAMポリシーの確認
aws iam list-attached-role-policies --role-name mimiru-gha-deploy-role
```

#### ECSデプロイエラー

**タスク起動失敗**:
```bash
# タスク定義の確認
aws ecs describe-task-definition --task-definition mimiru-api-task

# 失敗したタスクのログ確認
aws ecs describe-tasks --cluster mimiru-cluster --tasks [task-arn]
```

**ヘルスチェック失敗**:
```bash
# ターゲットグループ設定確認
aws elbv2 describe-target-groups --target-group-arns [TARGET_GROUP_ARN]

# セキュリティグループ確認
aws ec2 describe-security-groups --group-ids [SECURITY_GROUP_ID]
```

### 5.2 ロールバック手順

```bash
# 前のタスク定義リビジョンに戻す
aws ecs update-service \
  --cluster mimiru-cluster \
  --service mimiru-api-service \
  --task-definition mimiru-api-task:[previous-revision]

# 完了を待機
aws ecs wait services-stable \
  --cluster mimiru-cluster \
  --services mimiru-api-service
```

## 6. メンテナンス

### 6.1 定期的な作業

- **ECRイメージのクリーンアップ**: 古いイメージの削除（ライフサイクルポリシーで自動化済み）
- **RDSバックアップ確認**: 自動バックアップが正常に動作しているか確認
- **CloudWatchログの監視**: エラーログや異常なアクセスパターンの確認
- **セキュリティパッチ**: 定期的なOSやライブラリのアップデート

### 6.2 スケーリング

```bash
# ECSサービスのタスク数を変更
aws ecs update-service \
  --cluster mimiru-cluster \
  --service mimiru-api-service \
  --desired-count 3

# RDSインスタンスのスケールアップ
# terraform.tfvarsのinstance_classを変更してterraform apply
```

## 7. コスト最適化

- **開発環境では小さめのインスタンスを使用**
- **不要な環境は定期的にterraform destroyで削除**
- **CloudWatchログの保持期間を適切に設定**
- **S3ライフサイクルポリシーで古いファイルを自動削除**

---

**注意**: このガイドの設定値やARNは実際の環境に合わせて調整してください。