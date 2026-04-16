import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_create/view/issue_create_page.dart';
import 'package:app/issue_list/bloc/issue_list_bloc.dart';
import 'package:app/issue_list/bloc/issue_list_event.dart';
import 'package:app/issue_list/view/issue_list_view.dart';
import 'package:app/repositories/issue_repository.dart';
import 'package:app/repositories/label_repository.dart';

/// Issue一覧のPage（BlocProvider を配置するエントリポイント）
class IssueListPage extends StatelessWidget {
  const IssueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IssueListBloc(
        issueRepository: context.read<IssueRepository>(),
        labelRepository: context.read<LabelRepository>(),
      )..add(const IssueListFetched()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Issues')),
        body: const IssueListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(IssueCreatePage.route());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
