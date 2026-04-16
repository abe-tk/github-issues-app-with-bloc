import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/issue_list/bloc/issue_list_bloc.dart';
import 'package:app/issue_list/bloc/issue_list_state.dart';
import 'package:app/issue_list/view/issue_list_view.dart';
import 'package:app/models/issue.dart';
import 'package:app/models/label.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockIssueListBloc mockBloc;

  setUp(() {
    mockBloc = MockIssueListBloc();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<IssueListBloc>.value(
        value: mockBloc,
        child: const Scaffold(body: IssueListView()),
      ),
    );
  }

  group('IssueListView', () {
    testWidgets('loading 状態で CircularProgressIndicator が表示される', (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const IssueListState(status: IssueListStatus.loading));

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('success 状態で Issue 一覧が表示される', (tester) async {
      when(() => mockBloc.state).thenReturn(
        IssueListState(
          status: IssueListStatus.success,
          issues: [
            Issue(
              number: 1,
              title: 'テストIssue',
              state: IssueState.open,
              labels: const [Label(name: 'bug', color: 'fc2929')],
              createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
            ),
          ],
          hasReachedMax: true,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('テストIssue'), findsOneWidget);
    });

    testWidgets('failure 状態でエラーメッセージと再試行ボタンが表示される', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const IssueListState(
          status: IssueListStatus.failure,
          errorMessage: 'ネットワークエラー',
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('ネットワークエラー'), findsOneWidget);
      expect(find.text('再試行'), findsOneWidget);
    });

    testWidgets('success 状態で issues が空の場合「Issueがありません」が表示される', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const IssueListState(
          status: IssueListStatus.success,
          hasReachedMax: true,
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Issueがありません'), findsOneWidget);
    });
  });
}
