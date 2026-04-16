/// GitHub API通信時の例外基底クラス
class GithubApiException implements Exception {
  final int? statusCode;
  final String message;

  const GithubApiException({this.statusCode, required this.message});

  @override
  String toString() => 'GithubApiException($statusCode): $message';
}

/// 401 Unauthorized — トークンが無効
class UnauthorizedException extends GithubApiException {
  const UnauthorizedException() : super(statusCode: 401, message: 'トークンが無効です');
}

/// 404 Not Found — リポジトリまたはIssueが見つからない
class NotFoundException extends GithubApiException {
  const NotFoundException()
    : super(statusCode: 404, message: 'リポジトリまたはIssueが見つかりません');
}

/// 422 Validation Error — バリデーションエラー
class ValidationException extends GithubApiException {
  const ValidationException({required super.message}) : super(statusCode: 422);
}

/// ネットワーク接続エラー
class NetworkException extends GithubApiException {
  const NetworkException() : super(statusCode: null, message: 'ネットワークに接続できません');
}
