# GitHub Issues App with BLoC

## プロジェクト概要

GitHub REST API v3を利用してIssueを管理するFlutterアプリ。BLoCパターンによる状態管理の検証実装を兼ねる。

## 技術スタック

- Flutter (Dart SDK ^3.11.1)
- 状態管理: flutter_bloc（BLoCパターン）
- データモデル: freezed + json_serializable（不変性・等価判定・copyWith・fromJsonの自動生成）
- HTTPクライアント: http パッケージ
- バージョン管理: FVM（`.fvmrc`参照）
- コード生成: build_runner + freezed + json_serializable
- JSONフィールド名変換: build.yaml で snake_case 自動変換（@JsonKey 不要）

## ビルド・実行

```bash
fvm flutter run --dart-define-from-file=dart_defines.json
```

### コード生成

freezed のコード生成が必要な場合:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

認証情報（GITHUB_TOKEN, GITHUB_OWNER, GITHUB_REPO）は`--dart-define-from-file`でコンパイル定数として注入する。`dart_defines.json`は`.gitignore`対象。

## 仕様管理

OpenSpecで仕様を管理。ドキュメントは`openspec/`ディレクトリに格納。

- 初期実装（github-issues-manager）は全機能完了・アーカイブ済み
- アーカイブ: `openspec/changes/archive/2026-04-17-github-issues-manager/`
- 新しい変更を提案: `/opsx:propose`

## コーディング規約

- コード内のコメントは日本語
- ドキュメントは日本語
