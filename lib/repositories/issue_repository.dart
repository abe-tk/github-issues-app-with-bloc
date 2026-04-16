import 'dart:async';

import 'package:app/data_providers/github_api_client.dart';
import 'package:app/models/issue.dart';

/// Issueデータへのアクセスを提供するRepository。
/// GitHub APIの /issues エンドポイントはPull Requestも返すため、
/// PR を除外するフィルタリングを行う。
/// 書き込み操作（作成・更新）時は changes Stream で変更を通知する。
class IssueRepository {
  final GithubApiClient _apiClient;
  final _changesController = StreamController<void>.broadcast();

  /// Issueデータの変更を通知する Stream。
  /// 作成・更新が成功した際にイベントが発火される。
  Stream<void> get changes => _changesController.stream;

  IssueRepository({required GithubApiClient apiClient})
    : _apiClient = apiClient;

  /// Repository を破棄する
  void dispose() {
    _changesController.close();
  }

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

  /// Issueを作成する。成功時に changes Stream へ通知する。
  Future<Issue> createIssue({required String title, String? body}) async {
    final data = await _apiClient.createIssue(title: title, body: body);
    final issue = Issue.fromJson(data);
    _changesController.add(null);
    return issue;
  }

  /// Issueを更新する。成功時に changes Stream へ通知する。
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
    final issue = Issue.fromJson(data);
    _changesController.add(null);
    return issue;
  }
}
