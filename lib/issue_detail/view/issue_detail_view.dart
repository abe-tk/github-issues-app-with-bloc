import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:app/issue_detail/bloc/issue_detail_cubit.dart';
import 'package:app/issue_detail/bloc/issue_detail_state.dart';
import 'package:app/issue_detail/widgets/comment_list.dart';
import 'package:app/issue_detail/widgets/issue_detail_header.dart';
import 'package:app/issue_update/view/issue_update_page.dart';
import 'package:app/models/issue.dart';

/// Issue詳細のView（Scaffold + AppBar + BlocBuilder でUI構築）
class IssueDetailView extends StatelessWidget {
  const IssueDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IssueDetailCubit, IssueDetailState>(
      listenWhen: (previous, current) =>
          current.toggleErrorMessage != null &&
          current.toggleErrorMessage != previous.toggleErrorMessage,
      listener: (context, state) {
        if (state.toggleErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.toggleErrorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.issue != null ? '#${state.issue!.number}' : 'Issue詳細',
            ),
            actions: [
              IconButton(
                onPressed: state.status == IssueDetailStatus.success
                    ? () {
                        Navigator.of(context).push(
                          IssueUpdatePage.route(issue: state.issue!),
                        );
                      }
                    : null,
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, IssueDetailState state) {
    switch (state.status) {
      case IssueDetailStatus.initial:
      case IssueDetailStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case IssueDetailStatus.failure:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.errorMessage ?? 'エラーが発生しました',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<IssueDetailCubit>().fetchDetail();
                },
                child: const Text('再試行'),
              ),
            ],
          ),
        );
      case IssueDetailStatus.success:
        final issue = state.issue;
        if (issue == null) return const SizedBox.shrink();
        return CustomScrollView(
          slivers: [
            // Issueメタ情報ヘッダー
            SliverToBoxAdapter(
              child: IssueDetailHeader(issue: issue),
            ),
            // Markdown本文
            if (issue.body != null && issue.body!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MarkdownBody(
                    data: issue.body!,
                    shrinkWrap: true,
                    selectable: true,
                  ),
                ),
              ),
            // Open/Close トグルボタン
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildToggleButton(context, issue, state),
                ),
              ),
            ),
            // 区切り線 + コメントヘッダー
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'コメント (${state.comments.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // コメント一覧
            CommentList(comments: state.comments),
            // 下部余白
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        );
    }
  }

  Widget _buildToggleButton(
    BuildContext context,
    Issue issue,
    IssueDetailState state,
  ) {
    final isOpen = issue.state == IssueState.open;

    return ElevatedButton.icon(
      onPressed: state.isTogglingState
          ? null
          : () => context.read<IssueDetailCubit>().toggleState(),
      style: ElevatedButton.styleFrom(
        backgroundColor: isOpen ? Colors.red.shade50 : Colors.green.shade50,
        foregroundColor: isOpen ? Colors.red.shade700 : Colors.green.shade700,
      ),
      icon: state.isTogglingState
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(isOpen ? Icons.close : Icons.refresh),
      label: Text(isOpen ? 'Close Issue' : 'Reopen Issue'),
    );
  }
}
