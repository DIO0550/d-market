# Commit Command

## Description

コミットルールに従って、現在の変更内容を適切にコミットします。

## Prompt Template

`commit`スキルを使用して、コミットを実行してください。

以下のタスクを実行してください：

1. **変更内容の確認**

   ```bash
   git status
   git diff
   ```

2. **コミットルールの確認**

   - タイプ: 絵文字 + タグ形式（例: `✨ [New Feature]:`）
   - 分割: 1コミット = 1つの最小単位
   - 禁止: `git add .` は使用しない

3. **変更をステージング**

   ```bash
   # ファイル単位で追加
   git add <file1> <file2>
   ```

4. **コミットメッセージ作成**

   形式:
   ```
   <type>: <subject>

   [本文（任意）]

   [Closes #123 / Refs #123]
   ```

   タイプ一覧:
   - 🎉 [Initial Commit]: 最初のコミット
   - ✨ [New Feature]: 新機能
   - 🐛 [Bug fix]: バグ修正
   - ♻️ [Refactoring]: リファクタリング
   - 🎨 [Accessibility]: UI/UX
   - 🐎 [Performance]: パフォーマンス
   - 🚨 [Tests]: テスト
   - 🗑️ [Remove]: 削除
   - 📖 [Doc]: ドキュメント

5. **コミット実行**

   ```bash
   git commit -m "<message>"
   ```

## Notes

- 複数の目的の変更は分割してコミット
- 曖昧なメッセージ（「修正」「対応」など）は禁止
- 関連Issueがあれば `Closes #123` または `Refs #123` を記載
- 詳細は `references/examples.md` を参照
