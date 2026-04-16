import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/repositories/comment_repository.dart';

import '../helpers/mocks.dart';

void main() {
  late MockGithubApiClient mockApiClient;
  late CommentRepository repository;

  setUp(() {
    mockApiClient = MockGithubApiClient();
    repository = CommentRepository(apiClient: mockApiClient);
  });

  group('CommentRepository', () {
    group('getComments', () {
      test('コメント一覧をCommentモデルのリストとして返す', () async {
        // Arrange
        when(() => mockApiClient.fetchComments(1, page: 1)).thenAnswer(
          (_) async => [
            {
              'id': 100,
              'body': 'コメント1',
              'user': {'login': 'octocat'},
              'created_at': '2024-01-15T10:30:00Z',
            },
            {
              'id': 101,
              'body': 'コメント2',
              'user': {'login': 'testuser'},
              'created_at': '2024-01-16T10:30:00Z',
            },
          ],
        );

        // Act
        final comments = await repository.getComments(1);

        // Assert
        expect(comments, hasLength(2));
        expect(comments[0].body, equals('コメント1'));
        expect(comments[0].user, equals('octocat'));
        expect(comments[1].body, equals('コメント2'));
      });

      test('ページ指定でコメント一覧を取得する', () async {
        // Arrange
        when(() => mockApiClient.fetchComments(1, page: 2)).thenAnswer(
          (_) async => [
            {
              'id': 200,
              'body': 'ページ2のコメント',
              'user': {'login': 'octocat'},
              'created_at': '2024-02-01T10:00:00Z',
            },
          ],
        );

        // Act
        final comments = await repository.getComments(1, page: 2);

        // Assert
        expect(comments, hasLength(1));
        expect(comments.first.body, equals('ページ2のコメント'));
      });
    });

    group('createComment', () {
      test('コメントを投稿してCommentモデルを返す', () async {
        // Arrange
        when(() => mockApiClient.createComment(1, body: 'テストコメント')).thenAnswer(
          (_) async => {
            'id': 200,
            'body': 'テストコメント',
            'user': {'login': 'octocat'},
            'created_at': '2024-01-20T10:00:00Z',
          },
        );

        // Act
        final comment = await repository.createComment(1, body: 'テストコメント');

        // Assert
        expect(comment.body, equals('テストコメント'));
        verify(() => mockApiClient.createComment(1, body: 'テストコメント')).called(1);
      });
    });
  });
}
