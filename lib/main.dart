import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:app/app/app.dart';
import 'package:app/config/app_config.dart';
import 'package:app/data_providers/github_api_client.dart';
import 'package:app/repositories/comment_repository.dart';
import 'package:app/repositories/issue_repository.dart';
import 'package:app/repositories/label_repository.dart';

void main() {
  if (!AppConfig.isConfigured) {
    runApp(const _ConfigErrorApp());
    return;
  }

  final httpClient = http.Client();
  final apiClient = GithubApiClient(
    httpClient: httpClient,
    owner: AppConfig.githubOwner,
    repo: AppConfig.githubRepo,
    token: AppConfig.githubToken,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => IssueRepository(apiClient: apiClient),
        ),
        RepositoryProvider(
          create: (_) => CommentRepository(apiClient: apiClient),
        ),
        RepositoryProvider(
          create: (_) => LabelRepository(apiClient: apiClient),
        ),
      ],
      child: const App(),
    ),
  );
}

/// 設定未完了時のエラー画面
class _ConfigErrorApp extends StatelessWidget {
  const _ConfigErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'dart_defines.json が設定されていません。\n'
            'README.md を参照してください。',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
