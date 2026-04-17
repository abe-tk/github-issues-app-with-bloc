# Flutter / Dart コーディングルール

Flutter 公式 AI ルール（https://docs.flutter.dev/ai/ai-rules）をベースに、
このプロジェクトの技術スタックに合わせてカスタマイズしたもの。

BLoC/Cubit 設計、レイヤードアーキテクチャ、テスト方針の詳細はスキル
（`bloc`、`layered-architecture`、`testing`）を参照。

## コードスタイル

- SOLID 原則を適用する
- 簡潔で宣言的な Dart コードを書く
- 継承より合成を優先する
- 不変性を優先する（freezed でイミュータブルなモデル・State を定義）
- 関数は短く、単一責務に保つ（20行以内を目安）

## 命名規約

- `PascalCase`: クラス、enum
- `camelCase`: 変数、関数、enum 値
- `snake_case`: ファイル名
- 略語を避け、意味のある名前を付ける

## Dart ベストプラクティス

- Effective Dart（https://dart.dev/effective-dart）に従う
- null safety を活用する。`!` は値が non-null であることが保証されている場合のみ使用
- `async`/`await` を適切に使い、エラーハンドリングを忘れない
- パターンマッチングで分岐を簡潔にする
- 網羅的な `switch` 式を使う
- 単純な一行関数にはアロー構文を使う

## Flutter ベストプラクティス

- Widget は不変（特に `StatelessWidget`）
- 大きな `build()` メソッドは小さなプライベート Widget クラスに分割する
- ヘルパーメソッドではなくプライベート Widget クラスを使う
- 長いリストには `ListView.builder` や `SliverList` を使う
- `const` コンストラクタを可能な限り使いリビルドを削減する
- `build()` 内で重い処理（ネットワーク呼び出し等）を行わない

## 状態管理

このプロジェクトでは `flutter_bloc` を使用する。

- 複雑なイベント処理が必要な場合: Bloc（Event/State）
- シンプルな状態管理の場合: Cubit
- State は freezed でイミュータブルに定義する
- `BlocProvider` は Page ウィジェットに配置し、View で消費する（Page/View 分離）
- 詳細は `bloc` スキルを参照

## データモデルとシリアライズ

- `freezed` + `json_serializable` でモデルを定義する
- `build.yaml` で `snake_case` 自動変換を設定済み（`@JsonKey` は不要）
- コード生成: `fvm dart run build_runner build --delete-conflicting-outputs`

## プロジェクト構成

- feature-first ディレクトリ構成（`lib/issue_list/`、`lib/issue_detail/` 等）
- 各 feature 内は `bloc/`、`view/`、`widgets/` で整理
- 共有リソースは `lib/models/`、`lib/repositories/`、`lib/data_providers/` に配置
- 詳細は `layered-architecture` スキルを参照

## ナビゲーション

- `Navigator` ベースのシンプルなルーティング（`MaterialPageRoute`）
- `go_router` は使用していない

## テスト

- `blocTest()` で BLoC/Cubit の状態遷移を検証
- `mocktail` でモックを作成
- Mock クラスは `test/helpers/mocks.dart` に集約
- ウィジェットテストでは `MockCubit` + `BlocProvider.value` で BLoC を注入
- 詳細は `testing` スキルを参照

## エラーハンドリング

- `try-catch` で例外を処理する
- エラーを握りつぶさない
- State にエラーメッセージを持たせ、UI で表示する

## アクセシビリティ

- テキストのコントラスト比 4.5:1 以上を確保する
- システムフォントサイズ変更に対応する UI を作る
- `Semantics` ウィジェットで適切なラベルを付ける
