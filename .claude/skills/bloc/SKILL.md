---
name: bloc
description: BLoCパターンでの状態管理実装ガイド。BLoC/Cubitの作成、Event/State設計、BlocProvider構成時に使用する。「bloc」「cubit」「状態管理」「event」「state」などのキーワードで発動。
autoApply: true
---

# BLoC 状態管理スキル

bloclibrary.dev 公式ドキュメント準拠のBLoCパターン実装ガイド。

## Bloc と Cubit の使い分け

- **Cubit を使う場合**: メソッド呼び出し → 状態emit のシンプルなケース。迷ったらCubitから始める
- **Bloc を使う場合**: イベントの追跡が必要、debounce/throttle が必要、複数イベントが絡む複雑なロジック

Cubit は Bloc のサブセットなので、Cubit → Bloc への移行コストは低い。

## Event の設計ルール

- **sealed class** を使う（Dart 3以降）
- イベント名は**過去形**で記述する（何が「起きたか」を表現する）
- 命名形式: `BlocSubject` + `名詞(任意)` + `動詞(過去形)`
- 不変（immutable）にする
- freezed を使って等価判定・copyWith を自動生成する

```dart
// 良い例（freezed の union type を使用）
@freezed
sealed class IssueListEvent with _$IssueListEvent {
  const factory IssueListEvent.fetched() = IssueListFetched;
  const factory IssueListEvent.filterChanged({
    required IssueStateFilter filter,
  }) = IssueListFilterChanged;
}

// 悪い例
class FetchIssues {} // 命令形は使わない
class LoadData {}    // 曖昧すぎる
```

## State の設計ルール

### sealed class 方式（状態が排他的な場合）

```dart
@freezed
sealed class IssueDetailState with _$IssueDetailState {
  const factory IssueDetailState.initial() = IssueDetailInitial;
  const factory IssueDetailState.loading() = IssueDetailLoading;
  const factory IssueDetailState.loaded({required Issue issue}) = IssueDetailLoaded;
  const factory IssueDetailState.error({required String message}) = IssueDetailError;
}
```

### 単一クラス + status enum 方式（状態がデータを共有する場合）

```dart
enum IssueListStatus { initial, loading, success, failure }

@freezed
abstract class IssueListState with _$IssueListState {
  const factory IssueListState({
    @Default(IssueListStatus.initial) IssueListStatus status,
    @Default([]) List<Issue> issues,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _IssueListState;
}
```

- 状態の命名: `BlocSubject` + `State`（例: `IssueListState`）
- サブクラス: Initial / Loading / Success(Loaded) / Failure(Error) が定番
- freezed で不変性・等価判定・copyWith を自動生成

## BlocProvider / BlocBuilder / BlocListener / BlocConsumer

### BlocProvider
- Bloc/Cubit のインスタンスを生成しウィジェットツリーに提供する
- 自動で `close()` を呼ぶ
- `BlocProvider.value` は既存インスタンスを渡す場合（画面遷移時など）

### BlocBuilder
- 状態変化に応じて **UIを再構築** する
- `buildWhen` で再構築条件を絞れる
- 副作用（ナビゲーション、SnackBar）には使わない

### BlocListener
- 状態変化に応じて **副作用（1回限りのアクション）** を実行する
- ナビゲーション、SnackBar/Dialog表示、他のBlocへのイベント追加
- `listenWhen` で発火条件を絞れる

### BlocConsumer
- BlocBuilder + BlocListener が**両方必要**な場合のみ使う

### context.read / context.watch / context.select
- `context.read<T>()`: 1回だけBlocを取得（build外で使う）
- `context.watch<T>()`: 変化を監視してリビルド（build内で使う）
- `context.select<T, R>()`: 状態の一部だけを監視（最もパフォーマンスが良い）

## Event Transformer

`bloc_concurrency` パッケージを使用する。

- `sequential()`: イベントを順番に処理
- `droppable()`: 処理中なら新しいイベントを破棄（ボタン連打防止）
- `restartable()`: 処理中をキャンセルして新しいイベントを処理（検索に最適）

```dart
// debounce の実装
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

// Bloc内で使用
on<SearchQueryChanged>(
  _onSearchQueryChanged,
  transformer: debounce(const Duration(milliseconds: 300)),
);
```

## 命名規則

| 対象 | 命名 | ファイル名 |
|------|------|-----------|
| Bloc | `CounterBloc` | `counter_bloc.dart` |
| Cubit | `CounterCubit` | `counter_cubit.dart` |
| Event基底 | `CounterEvent` | `counter_event.dart` |
| Event具象 | `CounterIncrementPressed` | — |
| State基底 | `CounterState` | `counter_state.dart` |
| State具象 | `CounterInitial` | — |
| ハンドラ | `_onCounterIncrementPressed` | — |

## Page / View 分離パターン

```dart
// counter_page.dart — BlocProviderを配置するエントリポイント
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(repository: context.read<CounterRepository>()),
      child: const CounterView(),
    );
  }
}

// counter_view.dart — BlocBuilderでUIを構築
class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        // UI構築
      },
    );
  }
}
```

## イベントハンドラ内の非同期処理

イベントハンドラ内の非同期処理は**必ずawaitする**。awaitしないとハンドラが先に完了し、emitが呼ばれた時点でassertエラーになる。

```dart
// BAD — awaitしていない
on<DataRequested>((event, emit) {
  repository.getData().then((data) => emit(DataLoaded(data)));
});

// GOOD — awaitしている
on<DataRequested>((event, emit) async {
  final data = await repository.getData();
  emit(DataLoaded(data));
});
```

`emit.forEach` / `emit.onEach` も同様にawaitが必須。

## やってはいけないこと

- Bloc内で他のBlocを直接参照しない（Repository経由でデータを共有する）
- BlocにBuildContextを渡さない
- BlocBuilder内で副作用を実行しない（BlocListenerを使う）
- イベントハンドラ内の非同期処理をawaitせずに放置しない
