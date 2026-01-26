#!/bin/bash
# Codex Code Review Script
# Usage: review.sh <mode> [args...] [custom_instructions]

set -euo pipefail

MODE="${1:-staged}"
shift || true

# 出力ディレクトリ
OUTPUT_DIR=".codex-reviews"

DEFAULT_PROMPT="You are reviewing code changes. Focus on:
- Correctness: bugs, logic errors, edge cases
- Security: vulnerabilities, injection risks, data exposure
- Performance: inefficiencies, memory leaks, N+1 queries
- Maintainability: readability, naming, complexity

Report findings with severity (critical/warning/info), file path, line range, and actionable fix."

# ファイル名用にパスをサニタイズ（/や.を-に置換）
sanitize_path() {
    echo "$1" | sed 's/[\/\.]/-/g' | sed 's/^-//' | sed 's/-$//'
}

# 出力ファイルパスを生成
generate_output_path() {
    local mode="$1"
    local context="${2:-}"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    
    mkdir -p "$OUTPUT_DIR"
    
    if [[ -n "$context" ]]; then
        local safe_context=$(sanitize_path "$context")
        echo "${OUTPUT_DIR}/${mode}_${safe_context}_${timestamp}.md"
    else
        echo "${OUTPUT_DIR}/${mode}_${timestamp}.md"
    fi
}

review_with_codex() {
    local instruction="$1"
    local context="$2"
    local output_file="$3"
    local custom="${4:-}"

    local prompt="$DEFAULT_PROMPT

Context: $context"

    if [[ -n "$custom" ]]; then
        prompt="$prompt

Additional focus: $custom"
    fi

    # ヘッダーをファイルに書き込み
    {
        echo "# Codex Review"
        echo ""
        echo "- **Date**: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "- **Mode**: $MODE"
        echo "- **Context**: $context"
        [[ -n "$custom" ]] && echo "- **Focus**: $custom"
        echo ""
        echo "---"
        echo ""
    } > "$output_file"

    # プロンプトにレビュー指示を設定
    local full_prompt="$prompt

$instruction"

    # Codex実行、teeでファイルとコンソール両方に出力
    # Docker環境ではサンドボックスが動作しないため、バイパスフラグを使用
    codex exec --dangerously-bypass-approvals-and-sandbox "$full_prompt" | tee -a "$output_file"
    
    echo ""
    echo "---"
    echo "📄 Review saved to: $output_file"
}

case "$MODE" in
    staged)
        custom="${1:-}"
        diff_content=$(git diff --staged)
        if [[ -z "$diff_content" ]]; then
            echo "No staged changes to review."
            exit 0
        fi
        output_file=$(generate_output_path "staged")
        review_with_codex "git diff --staged を実行して、ステージされた変更をレビューしてください。" "Staged changes" "$output_file" "$custom"
        ;;

    uncommitted)
        custom="${1:-}"
        diff_content=$(git diff HEAD)
        if [[ -z "$diff_content" ]]; then
            echo "No uncommitted changes to review."
            exit 0
        fi
        output_file=$(generate_output_path "uncommitted")
        review_with_codex "git diff HEAD を実行して、コミットされていない全ての変更をレビューしてください。" "All uncommitted changes" "$output_file" "$custom"
        ;;

    file)
        file_path="${1:-}"
        custom="${2:-}"
        if [[ -z "$file_path" ]]; then
            echo "Usage: review.sh file <file_path> [custom_instructions]"
            exit 1
        fi
        if [[ ! -f "$file_path" ]]; then
            echo "File not found: $file_path"
            exit 1
        fi
        # 絶対パスに変換
        abs_path=$(realpath "$file_path")
        output_file=$(generate_output_path "file" "$file_path")
        review_with_codex "ファイル $abs_path を読み込んでレビューしてください。" "File: $file_path" "$output_file" "$custom"
        ;;

    files)
        custom=""
        files=()
        for arg in "$@"; do
            if [[ -f "$arg" ]]; then
                files+=("$arg")
            else
                custom="$arg"
                break
            fi
        done
        if [[ ${#files[@]} -eq 0 ]]; then
            echo "Usage: review.sh files <file1> <file2> ... [custom_instructions]"
            exit 1
        fi
        # 絶対パスのリストを作成
        abs_files=()
        for f in "${files[@]}"; do
            abs_files+=("$(realpath "$f")")
        done
        output_file=$(generate_output_path "files" "multiple-${#files[@]}")
        review_with_codex "以下のファイルを読み込んでレビューしてください: ${abs_files[*]}" "Files: ${files[*]}" "$output_file" "$custom"
        ;;

    branch)
        base_branch="${1:-main}"
        target_branch="${2:-HEAD}"
        custom="${3:-}"
        diff_content=$(git diff "$base_branch"..."$target_branch")
        if [[ -z "$diff_content" ]]; then
            echo "No differences between $base_branch and $target_branch"
            exit 0
        fi
        output_file=$(generate_output_path "branch" "${base_branch}-${target_branch}")
        review_with_codex "git diff $base_branch...$target_branch を実行して、ブランチ間の差分をレビューしてください。" "Branch: $base_branch...$target_branch" "$output_file" "$custom"
        ;;

    commit)
        commit_hash="${1:-HEAD}"
        custom="${2:-}"
        output_file=$(generate_output_path "commit" "$commit_hash")
        review_with_codex "git show $commit_hash を実行して、コミットの内容をレビューしてください。" "Commit: $commit_hash" "$output_file" "$custom"
        ;;

    pr)
        base_branch="${1:-origin/main}"
        custom="${2:-}"
        diff_content=$(git diff "$base_branch"...HEAD)
        if [[ -z "$diff_content" ]]; then
            echo "No differences from $base_branch"
            exit 0
        fi
        output_file=$(generate_output_path "pr" "$base_branch")
        review_with_codex "git diff $base_branch...HEAD を実行して、PRの差分をレビューしてください。" "PR against $base_branch" "$output_file" "$custom"
        ;;
        
    help|--help|-h)
        cat <<EOF
Codex Code Review Script

Usage: review.sh <mode> [args...] [custom_instructions]

Modes:
  staged                    Review staged changes (default)
  uncommitted               Review all uncommitted changes  
  file <path>               Review a specific file
  files <path1> <path2>...  Review multiple files
  branch <base> <target>    Review diff between branches
  commit <hash>             Review a specific commit
  pr <base_branch>          Review PR diff against base branch
  help                      Show this help

Examples:
  review.sh staged
  review.sh staged "Focus on security"
  review.sh file src/api.ts
  review.sh branch main feature/auth
  review.sh pr origin/main "Check for breaking changes"
EOF
        ;;
        
    *)
        echo "Unknown mode: $MODE"
        echo "Run 'review.sh help' for usage."
        exit 1
        ;;
esac
