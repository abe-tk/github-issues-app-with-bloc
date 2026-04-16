import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_create/bloc/issue_create_cubit.dart';
import 'package:app/issue_create/bloc/issue_create_state.dart';
import 'package:app/models/issue.dart';

import '../../helpers/mocks.dart';

/// テスト用の作成結果Issue
final _createdIssue = Issue(
  number: 42,
  title: 'テストIssue',
  body: 'テスト本文',
  state: IssueState.open,
  labels: const [],
  createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
);

void main() {
  late MockIssueRepository mockIssueRepository;

  setUp(() {
    mockIssueRepository = MockIssueRepository();
  });

  IssueCreateCubit buildCubit() => IssueCreateCubit(
    issueRepository: mockIssueRepository,
  );

  group('IssueCreateCubit', () {
    group('submit', () {
      blocTest<IssueCreateCubit, IssueCreateState>(
        '作成成功で submitting → success に遷移する',
        setUp: () {
          when(
            () => mockIssueRepository.createIssue(
              title: 'テストIssue',
              body: 'テスト本文',
            ),
          ).thenAnswer((_) async => _createdIssue);
        },
        build: buildCubit,
        act: (cubit) => cubit.submit(title: 'テストIssue', body: 'テスト本文'),
        expect: () => [
          const IssueCreateState(status: IssueCreateStatus.submitting),
          const IssueCreateState(status: IssueCreateStatus.success),
        ],
        verify: (_) {
          verify(
            () => mockIssueRepository.createIssue(
              title: 'テストIssue',
              body: 'テスト本文',
            ),
          ).called(1);
        },
      );

      blocTest<IssueCreateCubit, IssueCreateState>(
        'body が null でも作成成功する',
        setUp: () {
          when(
            () => mockIssueRepository.createIssue(title: 'タイトルのみ'),
          ).thenAnswer(
            (_) async => _createdIssue.copyWith(
              title: 'タイトルのみ',
              body: null,
            ),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.submit(title: 'タイトルのみ'),
        expect: () => [
          const IssueCreateState(status: IssueCreateStatus.submitting),
          const IssueCreateState(status: IssueCreateStatus.success),
        ],
        verify: (_) {
          verify(
            () => mockIssueRepository.createIssue(title: 'タイトルのみ'),
          ).called(1);
        },
      );

      blocTest<IssueCreateCubit, IssueCreateState>(
        'API エラー時に submitting → failure に遷移する',
        setUp: () {
          when(
            () => mockIssueRepository.createIssue(
              title: 'テストIssue',
              body: null,
            ),
          ).thenThrow(Exception('Validation error'));
        },
        build: buildCubit,
        act: (cubit) => cubit.submit(title: 'テストIssue'),
        expect: () => [
          const IssueCreateState(status: IssueCreateStatus.submitting),
          isA<IssueCreateState>()
              .having((s) => s.status, 'status', IssueCreateStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );

      blocTest<IssueCreateCubit, IssueCreateState>(
        'submitting 中は二重送信を防止する',
        build: buildCubit,
        seed: () => const IssueCreateState(
          status: IssueCreateStatus.submitting,
        ),
        act: (cubit) => cubit.submit(title: 'テストIssue'),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockIssueRepository.createIssue(
              title: any(named: 'title'),
              body: any(named: 'body'),
            ),
          );
        },
      );
    });
  });
}
