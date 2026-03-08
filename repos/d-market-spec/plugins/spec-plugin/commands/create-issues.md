# Create Issues

## Description

実装計画からGitHub Issuesを作成します。エピックIssueと子Issueを自動生成し、Sub-issuesとして親子関係を設定します。

## Prompt Template

`plan-to-issues`スキルを使用して、GitHub Issuesを作成してください。

以下のタスクを実行してください：

1. **実装計画の確認**

   - `.specs/` ディレクトリから対象の実装計画を特定
   - 計画の内容をユーザーに確認

2. **エピックIssue作成**

   ```bash
   gh issue create \
     --title "[Epic] 機能名: 実装計画と進行管理" \
     --label "type:epic" \
     --label "priority:P2"
   ```

3. **子Issue作成**

   - Feature Issue: コンポーネント実装
   - Migration Issue: 移行フェーズ
   - Test Issue: テスト整備
   - Docs Issue: ドキュメント更新

4. **Sub-issues紐付け**

   - GraphQL APIで`addSubIssue`を実行
   - 親子関係を設定

5. **ラベル・マイルストーン設定**

   - 種別ラベル: `type:epic/feature/migration/test/docs/chore`
   - 優先度: `priority:P1/P2/P3`
   - 規模: `size:S/M/L`

## Notes

- ラベルが存在しない場合は `/create-labels` を先に実行
- エピックのTasklistは子Issue作成後に更新
- 各Issueのテンプレートは `assets/templates/` を参照
