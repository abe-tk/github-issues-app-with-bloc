import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_detail/bloc/issue_detail_cubit.dart';
import 'package:app/issue_detail/bloc/issue_detail_state.dart';
import 'package:app/models/comment.dart';
import 'package:app/models/issue.dart';

import '../../helpers/mocks.dart';

/// テスト用Issueデータ
final _mockIssue = Issue(
  number: 1,
  title: 'テストIssue',
  body: '# テスト本文\nMarkdownの内容',
  state: IssueState.open,
  labels: const [],
  createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
);

/// テスト用コメントデータ
final _mockComment = Comment(
  id: 1,
  body: 'テストコメント',
  user: 'testuser',
  createdAt: DateTime.parse('2024-01-16T10:00:00Z'),
);

void main() {
  late MockIssueRepository mockIssueRepository;
  late MockCommentRepository mockCommentRepository;

  setUp(() {
    mockIssueRepository = MockIssueRepository();
    mockCommentRepository = MockCommentRepository();
  });

  IssueDetailCubit buildCubit() => IssueDetailCubit(
    issueNumber: 1,
    issueRepository: mockIssueRepository,
    commentRepository: mockCommentRepository,
  );

  group('IssueDetailCubit', () {
    group('fetchDetail', () {
      blocTest<IssueDetailCubit, IssueDetailState>(
        'Issue とコメントを取得して success 状態になる',
        setUp: () {
          when(
            () => mockIssueRepository.getIssue(1),
          ).thenAnswer((_) async => _mockIssue);
          when(
            () => mockCommentRepository.getComments(1),
          ).thenAnswer((_) async => [_mockComment]);
        },
        build: buildCubit,
        act: (cubit) => cubit.fetchDetail(),
        expect: () => [
          const IssueDetailState(status: IssueDetailStatus.loading),
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: _mockIssue,
            comments: [_mockComment],
          ),
        ],
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        'コメントが空の場合も success 状態になる',
        setUp: () {
          when(
            () => mockIssueRepository.getIssue(1),
          ).thenAnswer((_) async => _mockIssue);
          when(
            () => mockCommentRepository.getComments(1),
          ).thenAnswer((_) async => []);
        },
        build: buildCubit,
        act: (cubit) => cubit.fetchDetail(),
        expect: () => [
          const IssueDetailState(status: IssueDetailStatus.loading),
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: _mockIssue,
            comments: const [],
          ),
        ],
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        'Issue取得失敗で failure 状態になる',
        setUp: () {
          when(
            () => mockIssueRepository.getIssue(1),
          ).thenThrow(Exception('Not found'));
          when(
            () => mockCommentRepository.getComments(1),
          ).thenAnswer((_) async => []);
        },
        build: buildCubit,
        act: (cubit) => cubit.fetchDetail(),
        expect: () => [
          const IssueDetailState(status: IssueDetailStatus.loading),
          isA<IssueDetailState>()
              .having((s) => s.status, 'status', IssueDetailStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        'コメント取得失敗でも failure 状態になる',
        setUp: () {
          when(
            () => mockIssueRepository.getIssue(1),
          ).thenAnswer((_) async => _mockIssue);
          when(
            () => mockCommentRepository.getComments(1),
          ).thenThrow(Exception('Network error'));
        },
        build: buildCubit,
        act: (cubit) => cubit.fetchDetail(),
        expect: () => [
          const IssueDetailState(status: IssueDetailStatus.loading),
          isA<IssueDetailState>()
              .having((s) => s.status, 'status', IssueDetailStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });
  });
}
