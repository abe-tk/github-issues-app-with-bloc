/// アプリケーションのコンパイル定数を管理するクラス。
/// dart-define-from-file で注入された値を取得する。
class AppConfig {
  const AppConfig._();

  /// GitHub Personal Access Token
  static const String githubToken = String.fromEnvironment('GITHUB_TOKEN');

  /// GitHub リポジトリのオーナー名
  static const String githubOwner = String.fromEnvironment('GITHUB_OWNER');

  /// GitHub リポジトリ名
  static const String githubRepo = String.fromEnvironment('GITHUB_REPO');

  /// 必須の設定が全て揃っているかを検証する
  static bool get isConfigured =>
      githubToken.isNotEmpty && githubOwner.isNotEmpty && githubRepo.isNotEmpty;
}
