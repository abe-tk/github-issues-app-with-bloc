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
    // IssueDetailCubit のコンストラクタで changes を購読するため Stub が必要
    when(() => mockIssueRepository.changes).thenAnswer(
      (_) => const Stream<void>.empty(),
    );
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

    group('addComment', () {
      blocTest<IssueDetailCubit, IssueDetailState>(
        'コメント投稿成功時に success 状態になりコメント一覧が更新される',
        setUp: () {
          when(
            () => mockCommentRepository.createComment(1, body: 'テスト'),
          ).thenAnswer((_) async => _mockComment);
          when(
            () => mockCommentRepository.getComments(1),
          ).thenAnswer((_) async => [_mockComment]);
        },
        build: buildCubit,
        seed: () => IssueDetailState(
          status: IssueDetailStatus.success,
          issue: _mockIssue,
        ),
        act: (cubit) => cubit.addComment('テスト'),
        expect: () => [
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: _mockIssue,
            commentPostingStatus: CommentPostingStatus.posting,
          ),
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: _mockIssue,
            commentPostingStatus: CommentPostingStatus.success,
            comments: [_mockComment],
          ),
        ],
        verify: (_) {
          verify(
            () => mockCommentRepository.createComment(1, body: 'テスト'),
          ).called(1);
        },
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        'コメント投稿失敗時に failure 状態になる',
        setUp: () {
          when(
            () => mockCommentRepository.createComment(1, body: 'テスト'),
          ).thenThrow(Exception('Network error'));
        },
        build: buildCubit,
        seed: () => IssueDetailState(
          status: IssueDetailStatus.success,
          issue: _mockIssue,
        ),
        act: (cubit) => cubit.addComment('テスト'),
        expect: () => [
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: _mockIssue,
            commentPostingStatus: CommentPostingStatus.posting,
          ),
          isA<IssueDetailState>()
              .having(
                (s) => s.commentPostingStatus,
                'commentPostingStatus',
                CommentPostingStatus.failure,
              )
              .having(
                (s) => s.commentErrorMessage,
                'commentErrorMessage',
                isNotNull,
              ),
        ],
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        'posting 中は二重送信を防止する',
        build: buildCubit,
        seed: () => const IssueDetailState(
          commentPostingStatus: CommentPostingStatus.posting,
        ),
        act: (cubit) => cubit.addComment('テスト'),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockCommentRepository.createComment(
              any(),
              body: any(named: 'body'),
            ),
          );
        },
      );
    });

    group('toggleState', () {
      final closedIssue = _mockIssue.copyWith(state: IssueState.closed);

      blocTest<IssueDetailCubit, IssueDetailState>(
        'open → closed に切り替え成功する',
        setUp: () {
          when(
            () => mockIssueRepository.updateIssue(1, state: 'closed'),
          ).thenAnswer((_) async => closedIssue);
        },
        build: buildCubit,
        seed: () => IssueDetailState(
          status: IssueDetailStatus.success,
          issue: _mockIssue,
        ),
        act: (cubit) => cubit.toggleState(),
        expect: () => [
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: _mockIssue,
            isTogglingState: true,
          ),
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: closedIssue,
          ),
        ],
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        'closed → open に切り替え成功する',
        setUp: () {
          when(
            () => mockIssueRepository.updateIssue(1, state: 'open'),
          ).thenAnswer((_) async => _mockIssue);
        },
        build: buildCubit,
        seed: () => IssueDetailState(
          status: IssueDetailStatus.success,
          issue: closedIssue,
        ),
        act: (cubit) => cubit.toggleState(),
        expect: () => [
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: closedIssue,
            isTogglingState: true,
          ),
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: _mockIssue,
          ),
        ],
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        '切り替え失敗時は issue を変更せず toggleErrorMessage を設定する',
        setUp: () {
          when(
            () => mockIssueRepository.updateIssue(1, state: 'closed'),
          ).thenThrow(Exception('Server error'));
        },
        build: buildCubit,
        seed: () => IssueDetailState(
          status: IssueDetailStatus.success,
          issue: _mockIssue,
        ),
        act: (cubit) => cubit.toggleState(),
        expect: () => [
          IssueDetailState(
            status: IssueDetailStatus.success,
            issue: _mockIssue,
            isTogglingState: true,
          ),
          isA<IssueDetailState>()
              .having((s) => s.issue, 'issue', _mockIssue)
              .having((s) => s.isTogglingState, 'isTogglingState', false)
              .having(
                (s) => s.toggleErrorMessage,
                'toggleErrorMessage',
                isNotNull,
              ),
        ],
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        'issue が null のとき何もしない',
        build: buildCubit,
        act: (cubit) => cubit.toggleState(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockIssueRepository.updateIssue(
              any(),
              state: any(named: 'state'),
            ),
          );
        },
      );

      blocTest<IssueDetailCubit, IssueDetailState>(
        'isTogglingState 中は二重実行を防止する',
        build: buildCubit,
        seed: () => IssueDetailState(
          status: IssueDetailStatus.success,
          issue: _mockIssue,
          isTogglingState: true,
        ),
        act: (cubit) => cubit.toggleState(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockIssueRepository.updateIssue(
              any(),
              state: any(named: 'state'),
            ),
          );
        },
      );
    });
  });
}
