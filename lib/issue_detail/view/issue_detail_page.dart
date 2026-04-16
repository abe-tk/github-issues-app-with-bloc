import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_detail/bloc/issue_detail_cubit.dart';
import 'package:app/issue_detail/view/issue_detail_view.dart';
import 'package:app/repositories/comment_repository.dart';
import 'package:app/repositories/issue_repository.dart';

/// Issue詳細のPage（BlocProvider を配置するエントリポイント）
class IssueDetailPage extends StatelessWidget {
  final int issueNumber;

  const IssueDetailPage({super.key, required this.issueNumber});

  /// Issue詳細画面への MaterialPageRoute を生成する
  static Route<void> route({required int issueNumber}) {
    return MaterialPageRoute(
      builder: (_) => IssueDetailPage(issueNumber: issueNumber),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IssueDetailCubit(
        issueNumber: issueNumber,
        issueRepository: context.read<IssueRepository>(),
        commentRepository: context.read<CommentRepository>(),
      )..fetchDetail(),
      child: const IssueDetailView(),
    );
  }
}
