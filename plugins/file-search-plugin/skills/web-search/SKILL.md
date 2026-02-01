---
name: web-search
description: Web検索スキル。技術ドキュメント、API仕様、エラー解決策などをWeb検索エージェントが効率的に検索・収集し、構造化された結果を提供。
---

# Web Search Skill

## 概要

Web検索を専門エージェントに委譲し、信頼性の高い構造化された検索結果を提供するスキル。

## 自動適用

このスキルは **PreToolUseフック** により、WebSearch/WebFetchツール使用時に自動的にトリガーされます。

## 実行方法

### Task tool での呼び出し

```
Task tool:
  subagent_type: "general-purpose"
  description: "Web検索"
  prompt: |
    Web検索エージェントとして検索を実行してください。

    検索対象: {検索したい内容}

    plugins/file-search-plugin/agents/web-search-agent.md の指示に従い、
    結果を構造化して報告してください。
```

### 検索リクエストの例

- 「React 19 の新しいhooksについて調べて」
- 「このエラーメッセージの解決策を検索」
- 「Rustのasync runtimeの比較」
- 「Next.js App Router のキャッシュ戦略」
- 「OAuth 2.0 PKCE フローの実装方法」

## 参照エージェント

詳細な検索手順は `agents/web-search-agent.md` を参照。

## 期待される結果

- 検索クエリと対象技術のサマリー
- ソースURL付きの主要な発見
- 信頼度・鮮度が明記された参考リンク
- 必要に応じたコード例
- 注意事項（バージョン依存、情報の古さ等）

## メリット

1. **段階的検索**: 概要把握から詳細取得まで最適な手順で実行
2. **信頼性評価**: ソースの信頼度を明示
3. **構造化出力**: 整理されたレポート形式
4. **鮮度管理**: 情報の日付を確認し古い情報に注意を付記
