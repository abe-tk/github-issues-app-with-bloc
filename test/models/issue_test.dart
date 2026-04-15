import 'package:flutter_test/flutter_test.dart';

import 'package:app/models/issue.dart';

void main() {
  group('Issue', () {
    group('isPullRequest', () {
      test('pull_requestがnullならfalseを返す', () {
        final issue = Issue(
          number: 1,
          title: 'Issue',
          state: IssueState.open,
          labels: const [],
          createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
        );

        expect(issue.isPullRequest, isFalse);
      });

      test('pull_requestが非nullならtrueを返す', () {
        final issue = Issue(
          number: 10,
          title: 'PRタイトル',
          state: IssueState.open,
          labels: const [],
          createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
          pullRequest: {
            'url': 'https://api.github.com/repos/owner/repo/pulls/10',
          },
        );

        expect(issue.isPullRequest, isTrue);
      });
    });
  });
}
