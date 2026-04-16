import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/data_providers/github_api_exception.dart';
import 'package:app/repositories/issue_repository.dart';

import '../helpers/mocks.dart';

/// テスト用のIssue JSONデータを生成する
Map<String, dynamic> _issueJson({
  required int number,
  required String title,
  String state = 'open',
  Map<String, dynamic>? pullRequest,
}) => {
  'number': number,
  'title': title,
  'body': null,
  'state': state,
  'labels': <dynamic>[],
  'created_at': '2024-01-15T10:30:00Z',
  'pull_request': pullRequest,
};

void main() {
  late MockGithubApiClient mockApiClient;
  late IssueRepository repository;

  setUp(() {
    mockApiClient = MockGithubApiClient();
    repository = IssueRepository(apiClient: mockApiClient);
  });

  group('IssueRepository', () {
    group('getIssues', () {
      test('Pull Requestを除外してIssueのみ返す', () async {
        // Arrange
        when(
          () => mockApiClient.fetchIssues(state: 'open', label: null, page: 1),
        ).thenAnswer(
          (_) async => [
            _issueJson(number: 1, title: 'Issue'),
            _issueJson(
              number: 2,
              title: 'PR',
              pullRequest: {'url': 'https://api.github.com/pulls/2'},
            ),
            _issueJson(number: 3, title: 'Issue2'),
          ],
        );

        // Act
        final issues = await repository.getIssues();

        // Assert
        expect(issues, hasLength(2));
        expect(issues[0].title, equals('Issue'));
        expect(issues[1].title, equals('Issue2'));
      });

      test('Issueが0件の場合は空リストを返す', () async {
        // Arrange
        when(
          () => mockApiClient.fetchIssues(state: 'open', label: null, page: 1),
        ).thenAnswer((_) async => []);

        // Act
        final issues = await repository.getIssues();

        // Assert
        expect(issues, isEmpty);
      });

      test('ラベルフィルタを指定してIssue一覧を取得する', () async {
        // Arrange
        when(
          () => mockApiClient.fetchIssues(
            state: 'open',
            label: 'bug',
            page: 1,
          ),
        ).thenAnswer(
          (_) async => [_issueJson(number: 1, title: 'Bug Issue')],
        );

        // Act
        final issues = await repository.getIssues(label: 'bug');

        // Assert
        expect(issues, hasLength(1));
        expect(issues.first.title, equals('Bug Issue'));
      });

      test('APIエラーがそのまま伝播する', () async {
        // Arrange
        when(
          () => mockApiClient.fetchIssues(state: 'open', label: null, page: 1),
        ).thenThrow(const UnauthorizedException());

        // Act & Assert
        expect(
          () async => repository.getIssues(),
          throwsA(isA<UnauthorizedException>()),
        );
      });
    });

    group('getIssue', () {
      test('Issue詳細をIssueモデルとして返す', () async {
        // Arrange
        when(
          () => mockApiClient.fetchIssue(42),
        ).thenAnswer((_) async => _issueJson(number: 42, title: 'バグ修正'));

        // Act
        final issue = await repository.getIssue(42);

        // Assert
        expect(issue.number, equals(42));
        expect(issue.title, equals('バグ修正'));
      });
    });

    group('createIssue', () {
      test('Issueを作成してIssueモデルを返す', () async {
        // Arrange
        when(
          () => mockApiClient.createIssue(title: '新規Issue', body: '本文'),
        ).thenAnswer((_) async => _issueJson(number: 10, title: '新規Issue'));

        // Act
        final issue = await repository.createIssue(
          title: '新規Issue',
          body: '本文',
        );

        // Assert
        expect(issue.title, equals('新規Issue'));
        verify(
          () => mockApiClient.createIssue(title: '新規Issue', body: '本文'),
        ).called(1);
      });
    });

    group('updateIssue', () {
      test('Issueを更新してIssueモデルを返す', () async {
        // Arrange
        when(
          () => mockApiClient.updateIssue(
            42,
            title: '更新後',
            body: null,
            state: null,
          ),
        ).thenAnswer((_) async => _issueJson(number: 42, title: '更新後'));

        // Act
        final issue = await repository.updateIssue(42, title: '更新後');

        // Assert
        expect(issue.title, equals('更新後'));
        verify(
          () => mockApiClient.updateIssue(42, title: '更新後', body: null, state: null),
        ).called(1);
      });
    });
  });
}
