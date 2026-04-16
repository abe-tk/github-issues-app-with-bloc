import 'package:app/data_providers/github_api_client.dart';
import 'package:app/models/comment.dart';

/// コメントデータへのアクセスを提供するRepository
class CommentRepository {
  final GithubApiClient _apiClient;

  const CommentRepository({required GithubApiClient apiClient})
    : _apiClient = apiClient;

  /// Issueのコメント一覧を取得する
  Future<List<Comment>> getComments(int issueNumber, {int page = 1}) async {
    final data = await _apiClient.fetchComments(issueNumber, page: page);
    return data.map((json) => Comment.fromJson(json)).toList();
  }

  /// Issueにコメントを投稿する
  Future<Comment> createComment(int issueNumber, {required String body}) async {
    final data = await _apiClient.createComment(issueNumber, body: body);
    return Comment.fromJson(data);
  }
}
