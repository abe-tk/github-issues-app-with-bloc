import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_update/bloc/issue_update_cubit.dart';
import 'package:app/issue_update/bloc/issue_update_state.dart';
import 'package:app/issue_update/view/issue_update_view.dart';
import 'package:app/models/issue.dart';

import '../../helpers/mocks.dart';

/// テスト用Issue
final _testIssue = Issue(
  number: 1,
  title: 'テストIssue',
  body: 'テスト本文',
  state: IssueState.open,
  labels: const [],
  createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
);

void main() {
  late MockIssueUpdateCubit mockCubit;

  setUp(() {
    mockCubit = MockIssueUpdateCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<IssueUpdateCubit>.value(
        value: mockCubit,
        child: IssueUpdateView(issue: _testIssue),
      ),
    );
  }

  group('IssueUpdateView', () {
    testWidgets('initial 状態でフォームに初期値が設定され保存ボタンが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueUpdateState(status: IssueUpdateStatus.initial),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Issue編集'), findsOneWidget);
      expect(find.text('テストIssue'), findsOneWidget);
      expect(find.text('テスト本文'), findsOneWidget);
      expect(find.text('保存'), findsOneWidget);
    });

    testWidgets('submitting 状態で保存ボタンが無効化されローディングが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueUpdateState(status: IssueUpdateStatus.submitting),
      );

      await tester.pumpWidget(buildSubject());

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('タイトル空で保存ボタンを押すとバリデーションエラーが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueUpdateState(status: IssueUpdateStatus.initial),
      );

      await tester.pumpWidget(buildSubject());

      // タイトルをクリアして保存
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();

      expect(find.text('タイトルを入力してください'), findsOneWidget);
    });

    testWidgets('success 状態で画面が閉じる', (tester) async {
      final streamController = StreamController<IssueUpdateState>();
      when(() => mockCubit.state).thenReturn(
        const IssueUpdateState(status: IssueUpdateStatus.initial),
      );
      whenListen(mockCubit, streamController.stream);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<IssueUpdateCubit>.value(
                    value: mockCubit,
                    child: IssueUpdateView(issue: _testIssue),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(IssueUpdateView), findsOneWidget);

      streamController.add(
        const IssueUpdateState(status: IssueUpdateStatus.success),
      );
      await tester.pumpAndSettle();

      expect(find.byType(IssueUpdateView), findsNothing);

      await streamController.close();
    });

    testWidgets('failure 状態で SnackBar にエラーメッセージが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueUpdateState(status: IssueUpdateStatus.initial),
      );
      whenListen(
        mockCubit,
        Stream<IssueUpdateState>.fromIterable([
          const IssueUpdateState(
            status: IssueUpdateStatus.failure,
            errorMessage: 'サーバーエラー',
          ),
        ]),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('サーバーエラー'), findsOneWidget);
    });

    testWidgets(
        'failure 状態で errorMessage が null のときフォールバックテキストが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueUpdateState(status: IssueUpdateStatus.initial),
      );
      whenListen(
        mockCubit,
        Stream<IssueUpdateState>.fromIterable([
          const IssueUpdateState(status: IssueUpdateStatus.failure),
        ]),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('エラーが発生しました'), findsOneWidget);
    });
  });
}
