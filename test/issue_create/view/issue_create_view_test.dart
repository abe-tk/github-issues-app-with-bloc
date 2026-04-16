import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_create/bloc/issue_create_cubit.dart';
import 'package:app/issue_create/bloc/issue_create_state.dart';
import 'package:app/issue_create/view/issue_create_view.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockIssueCreateCubit mockCubit;

  setUp(() {
    mockCubit = MockIssueCreateCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<IssueCreateCubit>.value(
        value: mockCubit,
        child: const IssueCreateView(),
      ),
    );
  }

  group('IssueCreateView', () {
    testWidgets('initial 状態でフォームと作成ボタンが表示される', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueCreateState(status: IssueCreateStatus.initial),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Issue作成'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('作成'), findsOneWidget);
    });

    testWidgets('submitting 状態で作成ボタンが無効化されローディングが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueCreateState(status: IssueCreateStatus.submitting),
      );

      await tester.pumpWidget(buildSubject());

      // 作成ボタンが無効化
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);

      // ローディング表示
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('submitting 状態でテキストフィールドが無効化される', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueCreateState(status: IssueCreateStatus.submitting),
      );

      await tester.pumpWidget(buildSubject());

      final textFields = tester.widgetList<TextFormField>(
        find.byType(TextFormField),
      );
      for (final field in textFields) {
        expect(field.enabled, isFalse);
      }
    });

    testWidgets('タイトル空で作成ボタンを押すとバリデーションエラーが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueCreateState(status: IssueCreateStatus.initial),
      );

      await tester.pumpWidget(buildSubject());

      // タイトルを空のまま作成ボタンをタップ
      await tester.tap(find.text('作成'));
      await tester.pumpAndSettle();

      expect(find.text('タイトルを入力してください'), findsOneWidget);
    });

    testWidgets('success 状態で画面が閉じる', (tester) async {
      final streamController = StreamController<IssueCreateState>();
      when(() => mockCubit.state).thenReturn(
        const IssueCreateState(status: IssueCreateStatus.initial),
      );
      whenListen(mockCubit, streamController.stream);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<IssueCreateCubit>.value(
                    value: mockCubit,
                    child: const IssueCreateView(),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );

      // 作成画面を開く
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(IssueCreateView), findsOneWidget);

      // success を発火して pop を検知
      streamController.add(
        const IssueCreateState(status: IssueCreateStatus.success),
      );
      await tester.pumpAndSettle();

      expect(find.byType(IssueCreateView), findsNothing);

      await streamController.close();
    });

    testWidgets('タイトルを入力して作成ボタンを押すと submit が呼ばれる',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueCreateState(status: IssueCreateStatus.initial),
      );
      when(
        () => mockCubit.submit(
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());

      await tester.enterText(find.byType(TextFormField).first, 'テストIssue');
      await tester.tap(find.text('作成'));
      await tester.pump();

      verify(() => mockCubit.submit(title: 'テストIssue', body: null)).called(1);
    });

    testWidgets('failure 状態で SnackBar にエラーメッセージが表示される',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const IssueCreateState(status: IssueCreateStatus.initial),
      );
      whenListen(
        mockCubit,
        Stream<IssueCreateState>.fromIterable([
          const IssueCreateState(
            status: IssueCreateStatus.failure,
            errorMessage: 'ネットワークエラー',
          ),
        ]),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('ネットワークエラー'), findsOneWidget);
    });
  });
}
