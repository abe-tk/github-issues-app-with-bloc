# GitHub Issues アプリ with BLoC

GitHub REST API を利用して Issues を管理する Flutter モバイル/Web アプリ

## 機能・画面構成

| 画面 | 機能 |
|------|------|
| Issue一覧 | Issues を一覧表示（state/ラベルフィルタ、無限スクロール、PR除外） |
| Issue詳細 | Issue の内容をMarkdown表示、コメント一覧、Open/Close切り替え |
| Issue作成 | タイトル・本文を入力して新規作成 |
| Issue編集 | 既存 Issue のタイトル・本文を更新 |
| コメント投稿 | Issue詳細画面からコメントを投稿 |

## セットアップ

### 必要な環境

- [FVM](https://fvm.app/)（Flutter のバージョンは `.fvmrc`）

### ビルド手順

1. リポジトリをクローン

2. 依存関係をインストール

```bash
fvm use
fvm flutter pub get
```

3. コード生成（freezed）

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

4. GitHub PAT の設定

GitHub PAT は [Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens) から発行する。

必要なスコープ: 
  * Repository access: このリポジトリのみ
  * Permissions: Issues（Read and write）

認証情報はビルド時に `--dart-define-from-file` で渡す。

```json
// dart_defines.json
{
  "GITHUB_TOKEN": "your_personal_access_token",
  "GITHUB_OWNER": "your_github_username",
  "GITHUB_REPO": "your_repository_name"
}
```

5. ビルド

```bash
fvm flutter run --dart-define-from-file=dart_defines.json
```

## Claude Code による開発

このプロジェクトは [Claude Code](https://docs.anthropic.com/en/docs/claude-code) を前提とした開発フローを採用している。

### 設定ファイル

| ファイル | 用途 |
|---------|------|
| `CLAUDE.md` | プロジェクト固有の指示（技術スタック、ビルド手順） |
| `.claude/rules/flutter.md` | Flutter/Dart コーディングルール |
| `.claude/skills/` | BLoC設計・テスト等の実装ガイド（必要時にロード） |

### 主要なスキル

| コマンド | 用途 |
|---------|------|
| `/opsx:propose` | 新機能の仕様を提案 |
| `/opsx:apply` | 仕様に基づいて実装 |
| `/plan-and-review` | 実装計画の作成 + AIレビュー |
| `/impl-and-review` | 計画に基づく実装 + 3観点AIレビュー |
| `/bloc` | BLoC/Cubit の設計ガイド |
| `/testing` | テスト実装ガイド |

## 仕様

[OpenSpec](https://github.com/openspec-dev/openspec) を使用して仕様を管理している。

仕様ドキュメントは `openspec/` ディレクトリに格納されており、以下の構成になっている。

```
openspec/
├── config.yaml                          # OpenSpec 設定
├── changes/
│   └── archive/
│       └── 2026-04-17-github-issues-manager/  # 完了済みchange
│           ├── proposal.md                    # 動機・スコープ
│           ├── design.md                      # 技術設計
│           ├── tasks.md                       # 実装タスク一覧（全31タスク完了）
│           └── specs/                         # 機能仕様
│               ├── issue-list/spec.md
│               ├── issue-detail/spec.md
│               ├── issue-create/spec.md
│               ├── issue-update/spec.md
│               ├── issue-comments/spec.md
│               └── github-api/spec.md
└── specs/
```
