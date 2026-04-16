import 'package:flutter/material.dart';

import 'package:app/issue_list/view/issue_list_page.dart';

/// アプリのルートウィジェット。
/// Repository は main.dart の MultiRepositoryProvider で提供される。
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Issues',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const IssueListPage(),
    );
  }
}
