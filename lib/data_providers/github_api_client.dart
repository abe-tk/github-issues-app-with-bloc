import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:app/data_providers/github_api_exception.dart';

/// GitHub REST API v3 との通信を担当するクライアント。
/// 全リクエストに PAT 認証ヘッダーを付与する。
class GithubApiClient {
  final http.Client _httpClient;
  final String _baseUrl;
  final String _token;

  GithubApiClient({
    required http.Client httpClient,
    required String owner,
    required String repo,
    required String token,
  }) : _httpClient = httpClient,
       _baseUrl = 'https://api.github.com/repos/$owner/$repo',
       _token = token;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_token',
    'Accept': 'application/vnd.github.v3+json',
    'Content-Type': 'application/json',
  };

  /// Issue一覧を取得する
  Future<List<Map<String, dynamic>>> fetchIssues({
    String state = 'open',
    String? label,
    int page = 1,
    int perPage = 30,
  }) async {
    final queryParams = <String, dynamic>{
      'state': state,
      'page': page.toString(),
      'per_page': perPage.toString(),
      'labels': label,
    }..removeWhere((_, v) => v == null);
    final uri = Uri.parse(
      '$_baseUrl/issues',
    ).replace(queryParameters: queryParams);
    final response = await _get(uri);
    return (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  /// Issue詳細を取得する
  Future<Map<String, dynamic>> fetchIssue(int number) async {
    final uri = Uri.parse('$_baseUrl/issues/$number');
    final response = await _get(uri);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Issueを作成する
  Future<Map<String, dynamic>> createIssue({
    required String title,
    String? body,
  }) async {
    final uri = Uri.parse('$_baseUrl/issues');
    final params = <String, dynamic>{'title': title, 'body': body}
      ..removeWhere((_, v) => v == null);
    final response = await _post(uri, params);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Issueを更新する
  Future<Map<String, dynamic>> updateIssue(
    int number, {
    String? title,
    String? body,
    String? state,
  }) async {
    final uri = Uri.parse('$_baseUrl/issues/$number');
    final params = <String, dynamic>{
      'title': title,
      'body': body,
      'state': state,
    }..removeWhere((_, v) => v == null);
    final response = await _patch(uri, params);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// コメント一覧を取得する
  Future<List<Map<String, dynamic>>> fetchComments(
    int issueNumber, {
    int page = 1,
    int perPage = 30,
  }) async {
    final uri = Uri.parse('$_baseUrl/issues/$issueNumber/comments').replace(
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    final response = await _get(uri);
    return (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  /// コメントを投稿する
  Future<Map<String, dynamic>> createComment(
    int issueNumber, {
    required String body,
  }) async {
    final uri = Uri.parse('$_baseUrl/issues/$issueNumber/comments');
    final response = await _post(uri, {'body': body});
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// ラベル一覧を取得する
  Future<List<Map<String, dynamic>>> fetchLabels() async {
    final uri = Uri.parse('$_baseUrl/labels');
    final response = await _get(uri);
    return (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  /// GETリクエストを実行する
  Future<http.Response> _get(Uri uri) async {
    try {
      final response = await _httpClient.get(uri, headers: _headers);
      _handleErrors(response);
      return response;
    } on SocketException {
      throw const NetworkException();
    }
  }

  /// POSTリクエストを実行する
  Future<http.Response> _post(Uri uri, Map<String, dynamic> body) async {
    try {
      final response = await _httpClient.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      _handleErrors(response);
      return response;
    } on SocketException {
      throw const NetworkException();
    }
  }

  /// PATCHリクエストを実行する
  Future<http.Response> _patch(Uri uri, Map<String, dynamic> body) async {
    try {
      final response = await _httpClient.patch(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      _handleErrors(response);
      return response;
    } on SocketException {
      throw const NetworkException();
    }
  }

  /// HTTPレスポンスのステータスコードに応じた例外をスローする
  void _handleErrors(http.Response response) {
    switch (response.statusCode) {
      case >= 200 && < 300:
        return;
      case 401:
        throw const UnauthorizedException();
      case 404:
        throw const NotFoundException();
      case 422:
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw ValidationException(
          message: body['message'] as String? ?? 'バリデーションエラー',
        );
      default:
        throw GithubApiException(
          statusCode: response.statusCode,
          message: 'APIエラー: ${response.statusCode}',
        );
    }
  }
}
