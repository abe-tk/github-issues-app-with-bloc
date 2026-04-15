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
  bloc_test: ^9.1.0
  mocktail: ^1.0.0
```

## blocTest() の基本構成

```dart
blocTest<IssueListBloc, IssueListState>(
  '説明文',
  build: () => IssueListBloc(repository: mockRepository),  // テスト対象を構築
  seed: () => IssueListState(status: IssueListStatus.initial),  // 初期状態（任意）
  act: (bloc) => bloc.add(IssueListFetched()),  // 操作
  wait: const Duration(milliseconds: 300),  // 非同期待ち（任意）
  expect: () => [  // 期待される状態の順序
    IssueListState(status: IssueListStatus.loading),
    IssueListState(status: IssueListStatus.success, issues: [mockIssue]),
  ],
  verify: (_) {  // 追加検証（任意）
    verify(() => mockRepository.getIssues(state: 'open')).called(1);
  },
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
| `verify` | — | expect検証後の追加検証 |
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
  late IssueListBloc bloc;

  setUp(() {
    mockRepository = MockIssueRepository();
    bloc = IssueListBloc(repository: mockRepository);
  });

  group('IssueListBloc', () {
    blocTest<IssueListBloc, IssueListState>(
      'IssueListFetched で issues を取得して success 状態になる',
      setUp: () {
        when(() => mockRepository.getIssues(state: 'open', page: 1))
            .thenAnswer((_) async => [mockIssue]);
      },
      build: () => IssueListBloc(repository: mockRepository),
      act: (bloc) => bloc.add(IssueListFetched()),
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
    test('getIssues で Pull Request を除外する', () async {
      when(() => mockApiClient.fetchIssues(state: 'open', page: 1))
          .thenAnswer((_) async => [
        {'number': 1, 'title': 'Issue', 'pull_request': null, ...},
        {'number': 2, 'title': 'PR', 'pull_request': {'url': '...'}, ...},
      ]);

      final issues = await repository.getIssues(state: 'open');
      expect(issues, hasLength(1));
      expect(issues.first.title, equals('Issue'));
    });
  });
}
```

## ウィジェットテストでの Bloc モック

```dart
import 'package:bloc_test/bloc_test.dart';

// MockBloc の定義
class MockIssueListBloc
    extends MockBloc<IssueListEvent, IssueListState>
    implements IssueListBloc {}

void main() {
  late MockIssueListBloc mockBloc;

  setUp(() {
    mockBloc = MockIssueListBloc();
  });

  testWidgets('Issue一覧が表示される', (tester) async {
    // 状態をスタブ化
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

## テストファイルの配置

`lib/` のディレクトリ構造をミラーリングする。

```
lib/                                test/
├── features/                       ├── features/
│   └── issue_list/                 │   └── issue_list/
│       ├── bloc/                   │       ├── bloc/
│       │   └── issue_list_bloc.dart│       │   └── issue_list_bloc_test.dart
│       └── view/                   │       └── view/
│           └── issue_list_page.dart│           └── issue_list_page_test.dart
├── repositories/                   ├── repositories/
│   └── issue_repository.dart       │   └── issue_repository_test.dart
└── models/                         └── models/
    └── issue.dart                      └── issue_test.dart
```

## テスト命名規則

- ファイル名: `{対象ファイル名}_test.dart`
- テスト説明: 日本語で「何をしたら何が起きるか」を記述

## ベストプラクティス

- 1テスト1シナリオ（blocTestごとに単一の動作を検証）
- `group()` で関連テストをまとめる
- 中間状態も含めて順序を検証する
- `verify` でRepositoryの呼び出し回数を確認する
- エッジケース（エラー、空リスト、null値）を網羅する
