# Mimiru Terraform インフラプロジェクト概要

## プロジェクトの目的
MimiruオーディオストリーミングプラットフォームをAWSにデプロイするためのTerraform Infrastructure as Codeプロジェクトです。ECS Fargateコンテナ、RDS PostgreSQL、S3/CloudFrontによるオーディオファイル配信、GitHub Actions CI/CD統合を含む本番環境対応のインフラを提供します。

## 技術スタック
- **インフラ**: Terraform (~> 1.0)
- **クラウドプロバイダー**: AWS (provider ~> 5.0)
- **リージョン**: ap-northeast-1 (東京)
- **コンテナプラットフォーム**: ECS Fargate
- **データベース**: RDS PostgreSQL 15.4 (Multi-AZ)
- **ストレージ**: S3 with CloudFront CDN
- **ロードバランサー**: Application Load Balancer (ALB)
- **コンテナレジストリ**: Amazon ECR
- **シークレット管理**: AWS Secrets Manager
- **CI/CD**: GitHub Actions with OIDC

## アーキテクチャコンポーネント
1. **ネットワーク層** (vpc.tf): 2つのAZにまたがるパブリック/プライベートサブネットを持つVPC、NAT Gateway
2. **コンピュート層** (ecs.tf): オートスケーリング機能付きECS Fargateクラスター
3. **データ層** (rds.tf, s3.tf): RDS PostgreSQL + S3バージョニング付きストレージ
4. **コンテンツ配信** (cloudfront.tf): OAI付きCloudFrontディストリビューション
5. **CI/CD統合** (github_oidc.tf): GitHub Actions OIDC信頼関係

## 主要機能
- 高可用性のためのMulti-AZデプロイ
- Container Insights有効
- 30日間の自動バックアップ
- 保護されたコンテンツ用署名付きURL
- セキュリティグループによる最小権限アクセス
- 保存時のデータ暗号化
- すべての接続でTLS/SSL強制