# Mimiru Infrastructure

MimiruオーディオストリーミングプラットフォームのTerraform Infrastructure as Codeプロジェクトです。

## 📁 ディレクトリ構成

```
mimiru-terraform/
├── env/           # 環境別設定
│   ├── production/        # 本番環境
├── modules/              # 再利用可能なTerraformモジュール
│   ├── vpc/             # VPCとネットワーク
│   ├── ecs/             # ECS Fargate
│   ├── rds/             # PostgreSQLデータベース
│   ├── alb/             # Application Load Balancer
│   ├── s3/              # オーディオストレージ
│   ├── cloudfront/      # CDN配信
│   └── github-oidc/     # GitHub Actions統合
├── configs/             # 設定ファイル
│   └── terraform.tfvars.example
└── docs/               # ドキュメント
    ├── README.md
    ├── DEPLOY.md
    └── CLAUDE.md
```

## 🚀 クイックスタート

### 1. 前提条件

```bash
# Terraform インストール
brew install terraform

# AWS CLI 設定
aws configure
```

### 2. 設定ファイル作成

```bash
# 設定例をコピー
cp configs/terraform.tfvars.example environments/production/terraform.tfvars

# 設定値を編集
vim environments/production/terraform.tfvars
```

### 3. CloudFront キーペア生成

```bash
# 秘密鍵生成
openssl genrsa -out cloudfront-private-key.pem 2048

# 公開鍵生成
openssl rsa -in cloudfront-private-key.pem -pubout -out cloudfront-public-key.pem
```

### 4. デプロイ実行

```bash
# 本番環境ディレクトリに移動
cd env/production

# 初期化
terraform init

# プラン確認
terraform plan

# 適用
terraform apply
```

### 5. GitHub Secrets設定

```bash
# 必要な値を出力
terraform output github_secrets
```

## 📋 主要コマンド

```bash
# フォーマット
terraform fmt -recursive

# 検証
terraform validate

# 状態確認
terraform state list

# アウトプット確認
terraform output

# インフラ削除
terraform destroy
```

## 🏗️ アーキテクチャ

- **VPC**: Multi-AZ構成（2つのAZ）
- **ECS**: Fargateクラスター + オートスケーリング
- **RDS**: PostgreSQL 15.4（Multi-AZ、暗号化）
- **ALB**: HTTPSリダイレクト + ヘルスチェック
- **S3**: バージョニング付きオーディオストレージ
- **CloudFront**: グローバルCDN配信
- **ECR**: Dockerイメージレジストリ
- **GitHub Actions**: OIDC認証でCI/CD統合

## 💰 月額コスト概算

- **VPC (NAT Gateway)**: ¥7,500/月
- **RDS (db.t4g.small, Multi-AZ)**: ¥5,000/月
- **ALB**: ¥2,400/月
- **ECS Fargate**: ¥4,000/月
- **CloudWatch**: ¥1,700/月
- **合計**: 約¥20,600/月

## 🔒 セキュリティ

- RDSはプライベートサブネットに配置
- S3バケットのパブリックアクセス禁止
- CloudFront OAIでS3への直接アクセス制限
- IAMロールは最小権限
- 全データ保存時暗号化

## 📚 詳細ドキュメント

- [デプロイガイド](docs/DEPLOY.md)
- [Claude向け指示書](docs/CLAUDE.md)

## 🆘 トラブルシューティング

### よくある問題

1. **バケット名重複エラー**
   - `s3_bucket_name`にユニークなサフィックスを追加

2. **権限エラー**
   - AWS認証情報とIAM権限を確認

3. **リソース制限**
   - AWSサービス制限を確認

### サポート

問題が発生した場合は、以下を確認してください：
- Terraformバージョンの互換性
- AWSクレデンシャルの有効性
- リソース制限の確認