# Terraformコードスタイルと規約

## ファイル構成
- **main.tf**: プロバイダー設定、変数、ローカル値、データソース
- **vpc.tf**: VPC、サブネット、NATゲートウェイ、インターネットゲートウェイ
- **security_groups.tf**: セキュリティグループ定義
- **ecs.tf**: ECSクラスター、サービス、タスク定義
- **alb.tf**: Application Load Balancer設定
- **rds.tf**: RDSデータベース設定
- **s3.tf**: S3バケットとポリシー
- **cloudfront.tf**: CloudFrontディストリビューション
- **ecr.tf**: Elastic Container Registry
- **secrets.tf**: AWS Secrets Manager
- **github_oidc.tf**: GitHub Actions OIDC統合
- **outputs.tf**: すべての出力値

## 命名規則
- **変数**: snake_case（例：`aws_region`、`project_name`）
- **リソース**: 説明的な名前でsnake_case（例：`aws_vpc.main`）
- **ローカル値**: snake_case（例：`account_id`、`azs`）
- **タグ**: PascalCaseキー（例：`Project`、`Environment`、`ManagedBy`）

## コード構造パターン
- 計算値と共通タグには`locals`ブロックを使用
- 関連リソースは同じファイルにグループ化
- 外部参照にはデータソースを使用
- 機密変数には`sensitive = true`を指定
- すべての変数と出力に説明を含める

## Terraformフォーマット
- 一貫したフォーマットのため`terraform fmt -recursive`を使用
- 2スペースインデント
- ブロック内で等号を揃える
- 論理セクション間は改行で区切る

## 変数定義
```hcl
variable "example_var" {
  description = "変数の明確な説明"
  type        = string
  default     = "default_value"  # 該当する場合
  sensitive   = true             # シークレットを含む場合
}
```

## リソースタグ付け
すべてのリソースは`locals.tags`からの共通タグを含める：
```hcl
tags = merge(local.tags, {
  Name = "specific-resource-name"
})
```

## セキュリティベストプラクティス
- パスワード/シークレット変数には`sensitive = true`を使用
- シークレットはTerraformステートではなくAWS Secrets Managerに保存
- 最小権限のIAMポリシーを使用
- すべてのストレージリソースで保存時暗号化を有効化
- データベースと内部サービスにはプライベートサブネットを使用