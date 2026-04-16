import 'package:app/data_providers/github_api_client.dart';
import 'package:app/models/label.dart';

/// ラベルデータへのアクセスを提供するRepository
class LabelRepository {
  final GithubApiClient _apiClient;

  const LabelRepository({required GithubApiClient apiClient})
    : _apiClient = apiClient;

  /// リポジトリのラベル一覧を取得する
  Future<List<Label>> getLabels() async {
    final data = await _apiClient.fetchLabels();
    return data.map((json) => Label.fromJson(json)).toList();
  }
}
