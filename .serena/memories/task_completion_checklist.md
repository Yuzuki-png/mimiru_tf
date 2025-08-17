# タスク完了チェックリスト

## Apply前の検証
- [ ] `terraform validate`で構文チェック
- [ ] `terraform fmt -recursive`でファイルフォーマット
- [ ] `terraform plan`で変更内容確認
- [ ] 計画内で意図しないリソース削除がないか確認
- [ ] 変更によるコスト影響を確認

## 必要ファイルチェック
- [ ] `terraform.tfvars`が存在し適切に設定されている
- [ ] CloudFront秘密鍵ファイルが存在する（CloudFront使用時）
- [ ] すべての必須変数が設定されている

## セキュリティ検証
- [ ] .tfファイルにシークレットがハードコードされていない
- [ ] 機密変数が`sensitive = true`でマークされている
- [ ] IAMポリシーが最小権限原則に従っている
- [ ] セキュリティグループが必要なアクセスのみ許可している

## Apply後のアクション
- [ ] `terraform output`で期待される出力を確認
- [ ] `terraform output github_secrets`の値でGitHub Secretsを更新
- [ ] デプロイされたリソースへの接続をテスト
- [ ] アプリケーションがRDSデータベースに接続できることを確認
- [ ] ALBヘルスチェックが通っているか確認

## ドキュメント更新
- [ ] コマンドや手順が変更された場合はCLAUDE.mdを更新
- [ ] アーキテクチャが変更された場合はREADME.mdを更新
- [ ] 必要な手動設定手順を文書化

## クリーンアップコマンド
```bash
# 変更後は常に以下を実行：
terraform fmt -recursive
terraform validate
terraform plan
```

## 緊急ロールバック
Apply後に問題が発生した場合：
```bash
# 適用された内容を確認
terraform show

# 必要に応じて特定のリソースを削除
terraform destroy -target=<リソース名>

# または以前のステートにロールバック（バージョニング付きリモートステート使用時）
```

## コスト監視
- [ ] 大きな変更後はAWS Cost Explorerをチェック
- [ ] CloudWatch課金アラームを監視
- [ ] README.mdの月額コスト見積もりを確認