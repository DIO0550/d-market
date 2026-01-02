---
name: custom-hook
description: Reactカスタムフックルール。命名規則（use*）、単一責任、戻り値の型定義、副作用管理、エラーハンドリング、依存関係管理などの規約を定義。カスタムフック実装時に参照。
---

# Reactカスタムフックルール

カスタムフック実装における規約を定義するスキル。

## 基本ルール

- **TDD**を実施すること（`tdd`スキル参照）
- **命名規則**: 必ず `use` で始める（例: `useUserData`, `useLocalStorage`）
- **単一責任の原則**: 1つのフックは1つの機能のみを担当
- **戻り値**: 配列またはオブジェクトで統一し、使いやすい形で提供
- **型定義**: 必須。戻り値の型を明示的に定義
- **副作用管理**: API呼び出し、localStorage操作等を適切に管理
- **エラーハンドリング**: エラー状態も戻り値に含める
- **依存関係**: `useEffect`や`useMemo`の依存配列を正しく設定
- **再利用性**: 汎用的なパラメータを受け取れるよう設計

## 推奨パターン

```typescript
type UseUserDataResult = {
  user: User | null;
  isLoading: boolean;
  error: Error | null;
  refetch: () => void;
};

export const useUserData = (userId: string): UseUserDataResult => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  const refetch = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    // fetch logic...
  }, [userId]);

  useEffect(() => {
    refetch();
  }, [refetch]);

  return { user, isLoading, error, refetch };
};
```

## 推奨事項

- **ローディング状態**とエラー状態を含めた状態管理
- **クリーンアップ処理**が必要な場合は適切に実装
- **テスト**可能な構造で設計し、純粋関数部分は分離

## テスト例

```typescript
import { renderHook, act } from "@testing-library/react";
import { useCounter } from "./useCounter";

test("初期値が0である", () => {
  const { result } = renderHook(() => useCounter());
  expect(result.current.count).toBe(0);
});

test("incrementで値が1増加する", () => {
  const { result } = renderHook(() => useCounter());
  act(() => {
    result.current.increment();
  });
  expect(result.current.count).toBe(1);
});
```

## 関連スキル

- TDD: `tdd`
- テスト: `testing`
- コーディング規約: `coding-standards`
