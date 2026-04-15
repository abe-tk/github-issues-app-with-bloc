---
name: testing
description: BLoCパターンにおけるテスト実装ガイド。blocTest、ユニットテスト、ウィジェットテスト、モック作成時に使用する。「テスト」「test」「blocTest」「モック」「mock」などのキーワードで発動。
autoApply: true
---

# テストスキル

bloclibrary.dev 公式ドキュメント準拠のテスト実装ガイド。

## なぜレイヤー分離がテストに不可欠か

```
テストしやすい                    テストしにくい
━━━━━━━━━━━━━━━                ━━━━━━━━━━━━━━━
[Bloc] ← MockRepository          [Widget] ← 実API
  ↓                                 直接HTTP呼び出し
純粋なロジックテスト               ネットワーク依存、不安定
```

- **Bloc**: Repositoryをモックすれば、ネットワーク不要で状態遷移をテストできる
- **Repository**: Data Providerをモックすれば、API不要でデータ変換をテストできる
- **Widget**: Blocをモックすれば、ロジック不要でUI表示をテストできる

レイヤーを分離するからこそ、各層を独立してテストできる。

## 必要パッケージ

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0
  mocktail: ^1.0.0
```

## テスト設計の原則

### 振る舞いを検証する（実装詳細ではなく）

テストは「何をするか（observable behavior）」を検証し、「どのように実装されているか」は検証しない。

**検証すべきもの:**
- メソッドの戻り値・変換後の値
- 外部システムへの副作用（API呼び出し等）
- 操作後の公開プロパティ・状態

**検証すべきでないもの:**
- 内部コンポーネント間の呼び出し順序・回数（結果に影響しないもの）
- プライベートメソッドの実行有無
- 中間状態の値（BLoCテストでは中間状態も検証対象だが、それは公開された状態遷移）

### AAA パターン（Arrange / Act / Assert）

1テストを3フェーズに分けて記述する。**Act は原則1行**。

```dart
test('正常な認証情報でセッションを返す', () async {
  // Arrange: テストデータと依存の準備
  when(() => mockApiClient.fetchIssues(state: 'open', page: 1))
      .thenAnswer((_) async => [issueJson]);

  // Act: 単一の操作を実行
  final issues = await repository.getIssues(state: 'open');

  // Assert: 結果を検証
  expect(issues, hasLength(1));
  expect(issues.first.title, equals('バグ修正'));
});
```

### Mock と Stub を区別する

判断基準は CQS（Command-Query Separation）原則。

| 種別 | 役割 | 使い方 |
|:---|:---|:---|
| **Stub** | テスト対象へのデータ供給（Query） | `when().thenReturn()` / `when().thenAnswer()` のみ |
| **Mock** | 外部への呼び出し検証（Command） | `when()` + `verify()` |

**重要: Stub に `verify()` を使わない。** データを返すだけの依存の呼び出し回数を検証すると、実装詳細に依存したテストになりリファクタリングに弱くなる。

```dart
// NG: Stub への verify（呼び出し回数は実装詳細）
verify(() => mockRepository.getIssues(state: 'open')).called(1);

// OK: 外部副作用（書き込み系）への verify
verify(() => mockApiClient.createIssue(any())).called(1);
```

blocTest の `verify` パラメータは、**書き込み系の外部副作用**（Issue作成、コメント投稿等）の検証にのみ使う。

### 何をモックするか

| 分類 | 定義 | 例 | テスト方針 |
|:---|:---|:---|:---|
| プロセス内依存 | 同一プロセスの協調オブジェクト | Repository | 本物 or Fake 優先 |
| 管理外プロセス外依存 | 外部システム | GitHub REST API | Mock / Stub |

BLoCテストでは:
- **Repository**: Mocktailで Stub（データ供給のみ、verify しない）
- **Data Provider**: Mocktailで Mock/Stub（外部APIとの通信層）

## クラス別テスト方針

### Model（Entity）

| 項目 | 方針 |
|:---|:---|
| テスト対象 | 自前のビジネスロジック（isPullRequest等）、カスタム `@JsonKey` のみ |
| モック | 不要（外部依存を持たない） |
| テストスタイル | 出力ベース: 入力を与えて戻り値を検証する |
| 注意 | freezed/json_serializable が自動生成する fromJson・等価判定・copyWith はテスト不要（コードジェネレータのテストになる） |

### Data Provider（GitHubApiClient）

| 項目 | 方針 |
|:---|:---|
| テスト対象 | HTTPリクエストの正確性（URL, ヘッダー, クエリパラメータ） |
| モック | HTTPクライアントをモック |
| 検証内容 | リクエストの構築が正しいこと、レスポンスのパースが正しいこと |

### Repository

| 項目 | 方針 |
|:---|:---|
| テスト対象 | Data Provider呼び出し、データ変換（PR除外等）、エラーハンドリング |
| モック | Data Provider を Mocktail でモック |
| 検証内容 | 正常系でモデルを返すこと、異常系で適切な例外をスローすること |

### BLoC

| 項目 | 方針 |
|:---|:---|
| テスト対象 | Event → State の状態遷移 |
| モック | Repository を Mocktail で Stub（verify しない。書き込み系のみ verify） |
| 検証内容 | 初期状態、ローディング状態、成功/エラー状態の遷移が正しいこと |
| テストスタイル | blocTest() で状態の順序を検証 |

## blocTest() の基本構成

```dart
blocTest<IssueListBloc, IssueListState>(
  '説明文',
  build: () => IssueListBloc(repository: mockRepository),
  seed: () => IssueListState(status: IssueListStatus.initial),
  act: (bloc) => bloc.add(IssueListFetched()),
  wait: const Duration(milliseconds: 300),
  expect: () => [
    IssueListState(status: IssueListStatus.loading),
    IssueListState(status: IssueListStatus.success, issues: [mockIssue]),
  ],
  // verify は書き込み系の副作用のみ
);
```

### 主要パラメータ

| パラメータ | 必須 | 用途 |
|-----------|------|------|
| `description` | ○ | テストケースの説明 |
| `build` | ○ | テスト対象のBloc/Cubitを構築 |
| `act` | — | Blocへの操作（Event追加など） |
| `expect` | — | 期待される状態のリスト（順序検証） |
| `seed` | — | act実行前の初期状態 |
| `verify` | — | **書き込み系の副作用のみ**検証 |
| `wait` | — | debounce等の非同期待ち |
| `errors` | — | 期待される例外 |

## Bloc ユニットテスト

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIssueRepository extends Mock implements IssueRepository {}

void main() {
  late MockIssueRepository mockRepository;

  setUp(() {
    mockRepository = MockIssueRepository();
  });

  group('IssueListBloc', () {
    group('IssueListFetched', () {
      blocTest<IssueListBloc, IssueListState>(
        'issues を取得して success 状態になる',
        setUp: () {
          // Arrange: Stub としてデータを供給（verify しない）
          when(() => mockRepository.getIssues(state: 'open', page: 1))
              .thenAnswer((_) async => [mockIssue]);
        },
        build: () => IssueListBloc(repository: mockRepository),
        // Act: Event を追加
        act: (bloc) => bloc.add(IssueListFetched()),
        // Assert: 状態遷移を検証
        expect: () => [
          IssueListState(status: IssueListStatus.loading),
          IssueListState(
            status: IssueListStatus.success,
            issues: [mockIssue],
          ),
        ],
      );

      blocTest<IssueListBloc, IssueListState>(
        'API エラー時に failure 状態になる',
        setUp: () {
          when(() => mockRepository.getIssues(state: 'open', page: 1))
              .thenThrow(Exception('Network error'));
        },
        build: () => IssueListBloc(repository: mockRepository),
        act: (bloc) => bloc.add(IssueListFetched()),
        expect: () => [
          IssueListState(status: IssueListStatus.loading),
          IssueListState(
            status: IssueListStatus.failure,
            errorMessage: 'Network error',
          ),
        ],
      );
    });
  });
}
```

## Repository テスト

```dart
class MockGitHubApiClient extends Mock implements GitHubApiClient {}

void main() {
  late MockGitHubApiClient mockApiClient;
  late IssueRepository repository;

  setUp(() {
    mockApiClient = MockGitHubApiClient();
    repository = IssueRepository(apiClient: mockApiClient);
  });

  group('IssueRepository', () {
    group('getIssues', () {
      test('Pull Request を除外して Issue のみ返す', () async {
        // Arrange
        when(() => mockApiClient.fetchIssues(state: 'open', page: 1))
            .thenAnswer((_) async => [
          {'number': 1, 'title': 'Issue', 'pull_request': null, ...},
          {'number': 2, 'title': 'PR', 'pull_request': {'url': '...'}, ...},
        ]);

        // Act
        final issues = await repository.getIssues(state: 'open');

        // Assert
        expect(issues, hasLength(1));
        expect(issues.first.title, equals('Issue'));
      });
    });
  });
}
```

## ウィジェットテストでの Bloc モック

```dart
import 'package:bloc_test/bloc_test.dart';

class MockIssueListBloc
    extends MockBloc<IssueListEvent, IssueListState>
    implements IssueListBloc {}

void main() {
  late MockIssueListBloc mockBloc;

  setUp(() {
    mockBloc = MockIssueListBloc();
  });

  group('IssueListView', () {
    testWidgets('Issue一覧が表示される', (tester) async {
      when(() => mockBloc.state).thenReturn(
        IssueListState(
          status: IssueListStatus.success,
          issues: [mockIssue],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<IssueListBloc>.value(
            value: mockBloc,
            child: const IssueListView(),
          ),
        ),
      );

      expect(find.text('Issue Title'), findsOneWidget);
    });

    testWidgets('ローディング中はインジケーターが表示される', (tester) async {
      when(() => mockBloc.state).thenReturn(
        IssueListState(status: IssueListStatus.loading),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<IssueListBloc>.value(
            value: mockBloc,
            child: const IssueListView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### whenListen でストリームをスタブ化

```dart
whenListen(
  mockBloc,
  Stream.fromIterable([
    IssueListState(status: IssueListStatus.loading),
    IssueListState(status: IssueListStatus.success, issues: [mockIssue]),
  ]),
  initialState: IssueListState(status: IssueListStatus.initial),
);
```

## テストデータ管理

```
test/
├── helpers/
│   └── mocks.dart               # Mock クラス定義を集約
├── models/
│   ├── label_test.dart
│   ├── comment_test.dart
│   └── issue_test.dart
├── repositories/
│   └── issue_repository_test.dart
├── issue_list/
│   └── bloc/
│       └── issue_list_bloc_test.dart
└── ...
```

Mock クラスが増えてきたら `test/helpers/mocks.dart` に集約する。

```dart
// test/helpers/mocks.dart
import 'package:mocktail/mocktail.dart';

class MockGitHubApiClient extends Mock implements GitHubApiClient {}
class MockIssueRepository extends Mock implements IssueRepository {}
class MockCommentRepository extends Mock implements CommentRepository {}
```

## テストファイルの配置

`lib/` のディレクトリ構造をミラーリングする。

```
lib/                                test/
├── issue_list/                     ├── issue_list/
│   ├── bloc/                       │   └── bloc/
│   │   └── issue_list_bloc.dart    │       └── issue_list_bloc_test.dart
│   └── view/                       │
│       └── issue_list_page.dart    │
├── repositories/                   ├── repositories/
│   └── issue_repository.dart       │   └── issue_repository_test.dart
└── models/                         └── models/
    └── issue.dart                      └── issue_test.dart
```

## テスト命名規則

- ファイル名: `{対象ファイル名}_test.dart`
- group: 2段ネスト（クラス名 → メソッド/機能名）
- テスト名: 日本語で「何をしたら何が起きるか」を記述

```dart
group('IssueRepository', () {          // クラス名
  group('getIssues', () {               // メソッド名
    test('Pull Requestを除外してIssueのみ返す', () { ... });  // 振る舞い
    test('APIエラー時に例外をスローする', () { ... });
  });
});
```

## ベストプラクティス

- 1テスト1シナリオ（blocTestごとに単一の動作を検証）
- AAAパターン（Arrange/Act/Assert）でテストを構成する
- Actは原則1行
- `group()` を2段ネストして整理する（クラス → メソッド）
- 中間状態も含めて順序を検証する（blocTest の expect）
- **Stub に verify を使わない**（書き込み系の副作用のみ verify）
- エッジケース（エラー、空リスト、null値）を網羅する
- Mock クラスが増えたら `test/helpers/mocks.dart` に集約する
