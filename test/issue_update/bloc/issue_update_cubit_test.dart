import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_update/bloc/issue_update_cubit.dart';
import 'package:app/issue_update/bloc/issue_update_state.dart';
import 'package:app/models/issue.dart';

import '../../helpers/mocks.dart';

/// テスト用の更新結果Issue
final _updatedIssue = Issue(
  number: 1,
  title: '更新後タイトル',
  body: '更新後本文',
  state: IssueState.open,
  labels: const [],
  createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
);

void main() {
  late MockIssueRepository mockIssueRepository;

  setUp(() {
    mockIssueRepository = MockIssueRepository();
  });

  IssueUpdateCubit buildCubit() => IssueUpdateCubit(
    issueNumber: 1,
    issueRepository: mockIssueRepository,
  );

  group('IssueUpdateCubit', () {
    group('submit', () {
      blocTest<IssueUpdateCubit, IssueUpdateState>(
        '更新成功で submitting → success に遷移する',
        setUp: () {
          when(
            () => mockIssueRepository.updateIssue(
              1,
              title: '更新後タイトル',
              body: '更新後本文',
            ),
          ).thenAnswer((_) async => _updatedIssue);
        },
        build: buildCubit,
        act: (cubit) =>
            cubit.submit(title: '更新後タイトル', body: '更新後本文'),
        expect: () => [
          const IssueUpdateState(status: IssueUpdateStatus.submitting),
          const IssueUpdateState(status: IssueUpdateStatus.success),
        ],
        verify: (_) {
          verify(
            () => mockIssueRepository.updateIssue(
              1,
              title: '更新後タイトル',
              body: '更新後本文',
            ),
          ).called(1);
        },
      );

      blocTest<IssueUpdateCubit, IssueUpdateState>(
        'API エラー時に submitting → failure に遷移する',
        setUp: () {
          when(
            () => mockIssueRepository.updateIssue(
              1,
              title: 'テスト',
              body: null,
            ),
          ).thenThrow(Exception('Server error'));
        },
        build: buildCubit,
        act: (cubit) => cubit.submit(title: 'テスト'),
        expect: () => [
          const IssueUpdateState(status: IssueUpdateStatus.submitting),
          isA<IssueUpdateState>()
              .having((s) => s.status, 'status', IssueUpdateStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );

      blocTest<IssueUpdateCubit, IssueUpdateState>(
        'submitting 中は二重送信を防止する',
        build: buildCubit,
        seed: () => const IssueUpdateState(
          status: IssueUpdateStatus.submitting,
        ),
        act: (cubit) => cubit.submit(title: 'テスト'),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockIssueRepository.updateIssue(
              any(),
              title: any(named: 'title'),
              body: any(named: 'body'),
            ),
          );
        },
      );
    });
  });
}
