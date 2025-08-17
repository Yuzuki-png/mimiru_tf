# Mimiru インフラ用の必須Terraformコマンド

## コアインフラ管理

### 初期化とセットアップ
```bash
# Terraformの初期化（クローン後やプロバイダー変更時に実行）
terraform init

# 設定の検証
terraform validate

# すべてのTerraformファイルを再帰的にフォーマット
terraform fmt -recursive
```

### 計画とデプロイ
```bash
# 変更計画の確認（apply前に必ず実行）
terraform plan

# インフラストラクチャの変更を適用
terraform apply

# 自動承認で適用（慎重に使用）
terraform apply -auto-approve

# すべてのインフラを削除
terraform destroy
```

### ステート管理
```bash
# ステート内のすべてのリソースを一覧表示
terraform state list

# 特定のリソースの詳細を表示
terraform state show <リソース名>

# 現在のステートを表示
terraform show
```

### アウトプット管理
```bash
# すべてのアウトプットを表示
terraform output

# 特定のアウトプットをJSON形式で表示
terraform output -json <アウトプット名>

# GitHub Secrets設定を取得
terraform output github_secrets
```

## デプロイ前の要件

### CloudFrontキー生成（初回apply前に必須）
```bash
# 秘密鍵生成
openssl genrsa -out cloudfront-private-key.pem 2048

# 公開鍵生成
openssl rsa -in cloudfront-private-key.pem -pubout -out cloudfront-public-key.pem
```

### 設定のセットアップ
```bash
# 設定例をコピー
cp terraform.tfvars.example terraform.tfvars

# 設定を編集（お好みのエディタを使用）
vim terraform.tfvars
# または
code terraform.tfvars
```

## システムコマンド（macOS/Darwin）
```bash
# ファイル操作
ls -la          # 詳細付きファイル一覧
find . -name    # 名前でファイルを検索
grep -r         # ファイル内を再帰的に検索

# Git操作
git status      # リポジトリ状態確認
git add .       # すべての変更をステージ
git commit -m   # 変更をコミット
git push        # リモートにプッシュ

# AWS CLI（必要に応じて）
aws configure   # AWS認証情報設定
aws sts get-caller-identity  # AWSアクセス確認
```

## デプロイワークフロー
1. CloudFrontキーを生成
2. terraform.tfvarsを設定
3. 実行: `terraform init`
4. 実行: `terraform plan`
5. 実行: `terraform apply`
6. `terraform output github_secrets`からGitHub Secretsを設定