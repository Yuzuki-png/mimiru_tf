# Mimiru Infrastructure

Terraformを使ってMimiruのAWSインフラを構築します。

## 構築されるリソース

- **VPC**: プライベート・パブリックサブネット、NAT Gateway
- **ECS**: Fargate クラスター
- **RDS**: PostgreSQL データベース（Multi-AZ）
- **ALB**: Application Load Balancer
- **ECR**: Docker イメージレジストリ
- **S3**: 音声ファイルストレージ
- **CloudFront**: CDN配信
- **Secrets Manager**: 機密情報管理
- **IAM**: GitHub Actions用のOIDCロール

## 使用方法

### 1. 前提条件

```bash
# Terraform インストール
brew install terraform

# AWS CLI 設定
aws configure
```

### 2. CloudFront キーペア生成

```bash
# 秘密鍵生成
openssl genrsa -out cloudfront-private-key.pem 2048

# 公開鍵生成
openssl rsa -in cloudfront-private-key.pem -pubout -out cloudfront-public-key.pem
```

### 3. 設定ファイル作成

```bash
# 設定ファイルをコピー
cp terraform.tfvars.example terraform.tfvars

# 値を編集
vim terraform.tfvars
```

### 4. Terraform実行

```bash
# 初期化
terraform init

# プラン確認
terraform plan

# 適用
terraform apply
```

### 5. GitHub Secrets設定

Terraform実行後、以下の値をGitHub Secretsに設定：

```bash
# 出力値を確認
terraform output github_secrets
```

## 📝 設定が必要な値

### terraform.tfvars
- `github_org`: GitHubの組織名
- `db_password`: RDSのパスワード
- `jwt_secret`: JWT秘密鍵
- `s3_bucket_name`: S3バケット名（グローバルでユニーク）
- `aws_access_key_id`: アプリケーション用のAWSアクセスキー
- `aws_secret_access_key`: アプリケーション用のAWSシークレットキー
- `cloudfront_private_key`: CloudFront署名用秘密鍵

### GitHub Secrets
- `AWS_ACCOUNT_ID`
- `TARGET_GROUP_ARN`
- `PRIVATE_SUBNET_1`
- `PRIVATE_SUBNET_2`
- `ECS_SECURITY_GROUP`

## カスタマイズ

### RDSインスタンスサイズ変更
```hcl
# rds.tf
instance_class = "db.t4g.medium"  # または db.t4g.large
```

### ECSリソース変更
```hcl
# GitHub Actions deploy-prod.yml で調整
# CPU/Memory は ecspresso が自動設定
```

## 🗑️ 削除

```bash
terraform destroy
```

## 月額コスト概算

- VPC (NAT Gateway): $68/月
- RDS (db.t4g.small, Multi-AZ): $45/月
- ALB: $22/月
- ECS Fargate: $36/月 (2タスク)
- CloudWatch Logs: $15/月
- **合計**: 約$186/月

## セキュリティ

- RDSはプライベートサブネットに配置
- S3バケットはパブリックアクセス禁止
- CloudFront OAIでS3への直接アクセス制限
- IAMロールは最小権限の原則
- Secrets Managerで機密情報管理