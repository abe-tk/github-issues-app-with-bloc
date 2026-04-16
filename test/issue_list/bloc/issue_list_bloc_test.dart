import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_list/bloc/issue_list_bloc.dart';
import 'package:app/issue_list/bloc/issue_list_event.dart';
import 'package:app/issue_list/bloc/issue_list_state.dart';
import 'package:app/models/issue.dart';
import 'package:app/models/label.dart';

import '../../helpers/mocks.dart';

/// テスト用Issueデータ
final _mockIssue = Issue(
  number: 1,
  title: 'テストIssue',
  state: IssueState.open,
  labels: const [],
  createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
);

/// テスト用Labelデータ
const _mockLabel = Label(name: 'bug', color: 'fc2929');

void main() {
  late MockIssueRepository mockIssueRepository;
  late MockLabelRepository mockLabelRepository;

  setUp(() {
    mockIssueRepository = MockIssueRepository();
    mockLabelRepository = MockLabelRepository();
  });

  IssueListBloc buildBloc() => IssueListBloc(
    issueRepository: mockIssueRepository,
    labelRepository: mockLabelRepository,
  );

  group('IssueListBloc', () {
    group('IssueListFetched', () {
      blocTest<IssueListBloc, IssueListState>(
        'Issues と Labels を取得して success 状態になる',
        setUp: () {
          when(
            () => mockIssueRepository.getIssues(state: 'open', label: null),
          ).thenAnswer((_) async => [_mockIssue]);
          when(
            () => mockLabelRepository.getLabels(),
          ).thenAnswer((_) async => [_mockLabel]);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const IssueListFetched()),
        expect: () => [
          const IssueListState(status: IssueListStatus.loading),
          IssueListState(
            status: IssueListStatus.success,
            issues: [_mockIssue],
            hasReachedMax: true,
            availableLabels: const [_mockLabel],
          ),
        ],
      );

      blocTest<IssueListBloc, IssueListState>(
        'APIエラー時に failure 状態になる',
        setUp: () {
          when(
            () => mockIssueRepository.getIssues(state: 'open', label: null),
          ).thenThrow(Exception('Network error'));
          when(
            () => mockLabelRepository.getLabels(),
          ).thenAnswer((_) async => []);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const IssueListFetched()),
        expect: () => [
          const IssueListState(status: IssueListStatus.loading),
          isA<IssueListState>()
              .having((s) => s.status, 'status', IssueListStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );

      blocTest<IssueListBloc, IssueListState>(
        '空リストの場合は hasReachedMax=true で success',
        setUp: () {
          when(
            () => mockIssueRepository.getIssues(state: 'open', label: null),
          ).thenAnswer((_) async => []);
          when(
            () => mockLabelRepository.getLabels(),
          ).thenAnswer((_) async => []);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const IssueListFetched()),
        expect: () => [
          const IssueListState(status: IssueListStatus.loading),
          const IssueListState(
            status: IssueListStatus.success,
            hasReachedMax: true,
          ),
        ],
      );

      blocTest<IssueListBloc, IssueListState>(
        'Labels取得失敗でもIssue取得成功なら success（availableLabels空）',
        setUp: () {
          when(
            () => mockIssueRepository.getIssues(state: 'open', label: null),
          ).thenAnswer((_) async => [_mockIssue]);
          when(
            () => mockLabelRepository.getLabels(),
          ).thenThrow(Exception('Labels failed'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const IssueListFetched()),
        expect: () => [
          const IssueListState(status: IssueListStatus.loading),
          IssueListState(
            status: IssueListStatus.success,
            issues: [_mockIssue],
            hasReachedMax: true,
          ),
        ],
      );
    });

    group('IssueListNextPageRequested', () {
      blocTest<IssueListBloc, IssueListState>(
        '既存issuesに次ページを追加する',
        setUp: () {
          when(
            () => mockIssueRepository.getIssues(
              state: 'open',
              label: null,
              page: 2,
            ),
          ).thenAnswer(
            (_) async => [_mockIssue.copyWith(number: 2, title: '次ページIssue')],
          );
        },
        build: buildBloc,
        seed: () => IssueListState(
          status: IssueListStatus.success,
          issues: List.generate(30, (i) => _mockIssue.copyWith(number: i)),
        ),
        act: (bloc) => bloc.add(const IssueListNextPageRequested()),
        expect: () => [
          isA<IssueListState>()
              .having((s) => s.issues.length, 'issues.length', 31)
              .having((s) => s.hasReachedMax, 'hasReachedMax', true),
        ],
      );

      blocTest<IssueListBloc, IssueListState>(
        'hasReachedMax=true なら何もしない',
        build: buildBloc,
        seed: () => IssueListState(
          status: IssueListStatus.success,
          issues: [_mockIssue],
          hasReachedMax: true,
        ),
        act: (bloc) => bloc.add(const IssueListNextPageRequested()),
        expect: () => [],
      );
    });

    group('IssueListStateFilterChanged', () {
      blocTest<IssueListBloc, IssueListState>(
        'フィルタ変更で issues がリセットされてから再取得される',
        setUp: () {
          when(
            () => mockIssueRepository.getIssues(state: 'closed', label: null),
          ).thenAnswer(
            (_) async => [_mockIssue.copyWith(state: IssueState.closed)],
          );
        },
        build: buildBloc,
        seed: () => IssueListState(
          status: IssueListStatus.success,
          issues: [_mockIssue],
        ),
        act: (bloc) => bloc.add(
          const IssueListStateFilterChanged(filter: IssueStateFilter.closed),
        ),
        expect: () => [
          // リセット状態（issues空 + loading）
          const IssueListState(
            status: IssueListStatus.loading,
            stateFilter: IssueStateFilter.closed,
          ),
          // 再取得完了
          IssueListState(
            status: IssueListStatus.success,
            stateFilter: IssueStateFilter.closed,
            issues: [_mockIssue.copyWith(state: IssueState.closed)],
            hasReachedMax: true,
          ),
        ],
      );
    });

    group('IssueListLabelFilterChanged', () {
      blocTest<IssueListBloc, IssueListState>(
        'ラベル変更で issues がリセットされてから再取得される',
        setUp: () {
          when(
            () => mockIssueRepository.getIssues(state: 'open', label: 'bug'),
          ).thenAnswer((_) async => [_mockIssue]);
        },
        build: buildBloc,
        seed: () => IssueListState(
          status: IssueListStatus.success,
          issues: [_mockIssue, _mockIssue.copyWith(number: 2)],
        ),
        act: (bloc) =>
            bloc.add(const IssueListLabelFilterChanged(label: 'bug')),
        expect: () => [
          // リセット状態（issues空 + loading）
          const IssueListState(
            status: IssueListStatus.loading,
            labelFilter: 'bug',
          ),
          // 再取得完了
          IssueListState(
            status: IssueListStatus.success,
            labelFilter: 'bug',
            issues: [_mockIssue],
            hasReachedMax: true,
          ),
        ],
      );
    });
  });
}
