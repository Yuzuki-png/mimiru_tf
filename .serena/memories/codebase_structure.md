# Mimiru Terraform コードベース構造

## ルートディレクトリファイル

### コアTerraformファイル
- **main.tf** - プロバイダー設定、変数、データソース、ローカル値
- **outputs.tf** - GitHub Secretsを含むすべての出力値
- **terraform.tfvars.example** - 設定例ファイル

### インフラコンポーネント
- **vpc.tf** - VPC、サブネット（パブリック/プライベート）、NATゲートウェイ、IGW
- **security_groups.tf** - ALB、ECS、RDS用セキュリティグループルール
- **alb.tf** - Application Load Balancerとターゲットグループ
- **ecs.tf** - ECS Fargateクラスター、サービス、タスク定義
- **ecr.tf** - DockerイメージのElastic Container Registry
- **rds.tf** - PostgreSQLデータベース（Multi-AZ、暗号化）
- **s3.tf** - バージョニング付きオーディオストレージバケット
- **cloudfront.tf** - OAI付きCDNディストリビューション
- **secrets.tf** - 機密データ用AWS Secrets Manager
- **github_oidc.tf** - GitHub Actions OIDC信頼とIAMロール

### ドキュメント
- **CLAUDE.md** - プロジェクト指示とコマンド（このファイル）
- **README.md** - プロジェクト概要とセットアップ手順（日本語）
- **DEPLOY.md** - デプロイ手順とワークフロー

## 主要設定エリア

### 変数（main.tf）
- AWSリージョン設定
- プロジェクト命名
- GitHubリポジトリ設定
- データベースとJWTシークレット
- S3バケット命名

### ローカル値（main.tf）
- AWSアカウントID
- アベイラビリティゾーン（最初の2つ）
- 共通タグ（Project、Environment、ManagedBy）

### セキュリティ設定
- データベースとECSタスク用プライベートサブネット
- ALBとNATゲートウェイ用パブリックサブネット
- 最小限の必要アクセスを持つセキュリティグループ
- 最小権限のIAMロール

### 出力（outputs.tf）
- インフラリソースIDとARN
- GitHub Secrets設定
- データベースエンドポイント（機密）
- ALBとCloudFrontの詳細

## コンポーネント間の依存関係
1. **VPC** → 他のすべてのリソースはネットワークセットアップに依存
2. **セキュリティグループ** → ALB、ECS、RDSで必要
3. **ALB** → ECSサービスで必要
4. **ECR** → ECSタスク定義で必要
5. **RDS** → 独立、セキュリティグループ経由で接続
6. **S3** → 独立、CloudFrontに接続
7. **GitHub OIDC** → CI/CD用の独立IAMセットアップ