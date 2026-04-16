import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_update/bloc/issue_update_cubit.dart';
import 'package:app/issue_update/view/issue_update_view.dart';
import 'package:app/models/issue.dart';
import 'package:app/repositories/issue_repository.dart';

/// Issue編集のPage（BlocProvider を配置するエントリポイント）
class IssueUpdatePage extends StatelessWidget {
  final Issue issue;

  const IssueUpdatePage({super.key, required this.issue});

  /// Issue編集画面への MaterialPageRoute を生成する。
  /// 編集対象の Issue を丸ごと渡す（title/body の初期値に使用するため）。
  static Route<void> route({required Issue issue}) {
    return MaterialPageRoute(
      builder: (_) => IssueUpdatePage(issue: issue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IssueUpdateCubit(
        issueNumber: issue.number,
        issueRepository: context.read<IssueRepository>(),
      ),
      child: IssueUpdateView(issue: issue),
    );
  }
}
