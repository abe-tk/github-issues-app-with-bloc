import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_detail/bloc/issue_detail_cubit.dart';
import 'package:app/issue_detail/bloc/issue_detail_state.dart';
import 'package:app/issue_detail/view/issue_detail_view.dart';
import 'package:app/issue_detail/widgets/comment_form.dart';
import 'package:app/models/comment.dart';
import 'package:app/models/issue.dart';
import 'package:app/models/label.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockIssueDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockIssueDetailCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<IssueDetailCubit>.value(
        value: mockCubit,
        child: const IssueDetailView(),
      ),
    );
  }

  group('IssueDetailView', () {
    testWidgets('initial 状態で CircularProgressIndicator が表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(status: IssueDetailStatus.initial),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loading 状態で CircularProgressIndicator が表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(status: IssueDetailStatus.loading),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('success 状態で Issue 詳細が表示される', (tester) async {
      when(() => mockCubit.state).thenReturn(
        IssueDetailState(
          status: IssueDetailStatus.success,
          issue: Issue(
            number: 1,
            title: 'テストIssue',
            body: 'テスト本文',
            state: IssueState.open,
            labels: const [Label(name: 'bug', color: 'fc2929')],
            createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
          ),
          comments: [
            Comment(
              id: 1,
              body: 'テストコメント',
              user: 'testuser',
              createdAt: DateTime.parse('2024-01-16T10:00:00Z'),
            ),
          ],
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('テストIssue'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('bug'), findsOneWidget);
      expect(find.text('コメント (1)'), findsOneWidget);
      expect(find.text('testuser'), findsOneWidget);
      // コメント投稿フォームが表示されている
      expect(find.byType(CommentForm), findsOneWidget);
    });

    testWidgets('failure 状態でエラーメッセージと再試行ボタンが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(
          status: IssueDetailStatus.failure,
          errorMessage: 'ネットワークエラー',
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('ネットワークエラー'), findsOneWidget);
      expect(find.text('再試行'), findsOneWidget);
    });

    testWidgets('success 状態でコメントがない場合「コメントはありません」が表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        IssueDetailState(
          status: IssueDetailStatus.success,
          issue: Issue(
            number: 1,
            title: 'テストIssue',
            body: 'テスト本文',
            state: IssueState.open,
            labels: const [],
            createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
          ),
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('コメントはありません'), findsOneWidget);
    });

    testWidgets('failure 状態で errorMessage が null のときフォールバックテキストが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(status: IssueDetailStatus.failure),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('エラーが発生しました'), findsOneWidget);
      expect(find.text('再試行'), findsOneWidget);
    });

    testWidgets('success 状態でのみ編集ボタンが有効になる', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(status: IssueDetailStatus.loading),
      );

      await tester.pumpWidget(buildSubject());

      // loading 状態では編集ボタンは無効
      final editButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(editButton.onPressed, isNull);
    });
  });
}
