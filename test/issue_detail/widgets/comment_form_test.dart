import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_detail/bloc/issue_detail_cubit.dart';
import 'package:app/issue_detail/bloc/issue_detail_state.dart';
import 'package:app/issue_detail/widgets/comment_form.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockIssueDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockIssueDetailCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<IssueDetailCubit>.value(
          value: mockCubit,
          child: const CommentForm(),
        ),
      ),
    );
  }

  group('CommentForm', () {
    testWidgets('初期状態でテキストが空のとき送信ボタンが無効', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(status: IssueDetailStatus.success),
      );

      await tester.pumpWidget(buildSubject());

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('テキスト入力後に送信ボタンが有効になる', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(status: IssueDetailStatus.success),
      );

      await tester.pumpWidget(buildSubject());

      await tester.enterText(find.byType(TextField), 'テストコメント');
      await tester.pump();

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNotNull);
    });

    testWidgets('posting 状態で CircularProgressIndicator が表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(
          status: IssueDetailStatus.success,
          commentPostingStatus: CommentPostingStatus.posting,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // 送信ボタン（IconButton）は非表示
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('posting 状態でテキストフィールドが readOnly になる',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(
          status: IssueDetailStatus.success,
          commentPostingStatus: CommentPostingStatus.posting,
        ),
      );

      await tester.pumpWidget(buildSubject());

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    testWidgets('success 状態への遷移でテキストフィールドがクリアされる',
        (tester) async {
      final controller = StreamController<IssueDetailState>();

      whenListen(
        mockCubit,
        controller.stream,
        initialState: const IssueDetailState(
          status: IssueDetailStatus.success,
          commentPostingStatus: CommentPostingStatus.initial,
        ),
      );

      await tester.pumpWidget(buildSubject());

      // テキストを入力
      await tester.enterText(find.byType(TextField), 'テストコメント');
      await tester.pump();

      // success 状態に遷移
      controller.add(
        const IssueDetailState(
          status: IssueDetailStatus.success,
          commentPostingStatus: CommentPostingStatus.success,
        ),
      );
      await tester.pump();

      // テキストフィールドがクリアされている
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, isEmpty);

      await controller.close();
    });

    testWidgets('failure 状態への遷移で SnackBar が表示される', (tester) async {
      // posting → failure への遷移をシミュレート
      whenListen(
        mockCubit,
        Stream.value(
          const IssueDetailState(
            status: IssueDetailStatus.success,
            commentPostingStatus: CommentPostingStatus.failure,
            commentErrorMessage: '投稿に失敗しました',
          ),
        ),
        initialState: const IssueDetailState(
          status: IssueDetailStatus.success,
          commentPostingStatus: CommentPostingStatus.posting,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('投稿に失敗しました'), findsOneWidget);
    });

    testWidgets('送信ボタンタップで addComment が呼ばれる', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueDetailState(status: IssueDetailStatus.success),
      );
      when(() => mockCubit.addComment(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());

      await tester.enterText(find.byType(TextField), 'テストコメント');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      verify(() => mockCubit.addComment('テストコメント')).called(1);
    });
  });
}
