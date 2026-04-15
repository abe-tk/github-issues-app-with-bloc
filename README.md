# GitHub Issues アプリ with BLoC

GitHub REST API を利用して Issues を管理する Flutter モバイル/Web アプリ

## 機能・画面構成

| 画面 | 機能 |
|------|------|
| Issue一覧 | Issues を一覧表示 |
| Issue詳細 | Issue の内容を表示 |
| Issue作成 | タイトル・本文を入力して新規作成 |
| Issue編集 | 既存 Issue を更新 |

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

3. GitHub PAT の設定

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

4. ビルド

```bash
fvm flutter run --dart-define-from-file=dart_defines.json
```
