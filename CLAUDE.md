# GitHub Issues App with BLoC

## プロジェクト概要

GitHub REST API v3を利用してIssueを管理するFlutterアプリ。BLoCパターンによる状態管理の検証実装を兼ねる。

## 技術スタック

- Flutter (Dart SDK ^3.11.1)
- 状態管理: flutter_bloc（BLoCパターン）
- HTTPクライアント: http パッケージ
- バージョン管理: FVM（`.fvmrc`参照）

## ビルド・実行

```bash
fvm flutter run --dart-define-from-file=dart_defines.json
```

認証情報（GITHUB_TOKEN, GITHUB_OWNER, GITHUB_REPO）は`--dart-define-from-file`でコンパイル定数として注入する。`dart_defines.json`は`.gitignore`対象。

## 仕様管理

OpenSpecで仕様を管理。ドキュメントは`openspec/`ディレクトリに格納。

- 仕様の確認: `openspec status --change github-issues-manager`
- 実装開始: `/opsx:apply`

## コーディング規約

- コード内のコメントは日本語
- ドキュメントは日本語
