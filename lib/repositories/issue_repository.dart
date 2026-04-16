import 'package:app/data_providers/github_api_client.dart';
import 'package:app/models/issue.dart';

/// Issueデータへのアクセスを提供するRepository。
/// GitHub APIの /issues エンドポイントはPull Requestも返すため、
/// PR を除外するフィルタリングを行う。
class IssueRepository {
  final GithubApiClient _apiClient;

  const IssueRepository({required GithubApiClient apiClient})
    : _apiClient = apiClient;

  /// Issue一覧を取得する。Pull Requestは除外される。
  Future<List<Issue>> getIssues({
    String state = 'open',
    String? label,
    int page = 1,
  }) async {
    final data = await _apiClient.fetchIssues(
      state: state,
      label: label,
      page: page,
    );
    return data
        .map((json) => Issue.fromJson(json))
        .where((issue) => !issue.isPullRequest)
        .toList();
  }

  /// Issue詳細を取得する
  Future<Issue> getIssue(int number) async {
    final data = await _apiClient.fetchIssue(number);
    return Issue.fromJson(data);
  }

  /// Issueを作成する
  Future<Issue> createIssue({required String title, String? body}) async {
    final data = await _apiClient.createIssue(title: title, body: body);
    return Issue.fromJson(data);
  }

  /// Issueを更新する
  Future<Issue> updateIssue(
    int number, {
    String? title,
    String? body,
    String? state,
  }) async {
    final data = await _apiClient.updateIssue(
      number,
      title: title,
      body: body,
      state: state,
    );
    return Issue.fromJson(data);
  }
}
