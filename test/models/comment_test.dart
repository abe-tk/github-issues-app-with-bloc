import 'package:flutter_test/flutter_test.dart';

import 'package:app/models/comment.dart';

void main() {
  group('Comment', () {
    group('fromJson', () {
      test('user.loginがフラット化されて格納される', () {
        final json = {
          'id': 1,
          'body': 'コメント本文',
          'user': {
            'login': 'octocat',
            'id': 12345,
            'avatar_url': 'https://example.com/avatar.png',
          },
          'created_at': '2024-01-15T10:30:00Z',
        };

        final comment = Comment.fromJson(json);

        expect(comment.user, equals('octocat'));
      });
    });
  });
}
