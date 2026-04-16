import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_detail/view/issue_detail_page.dart';
import 'package:app/issue_list/bloc/issue_list_bloc.dart';
import 'package:app/issue_list/bloc/issue_list_event.dart';
import 'package:app/issue_list/bloc/issue_list_state.dart';
import 'package:app/issue_list/widgets/issue_filter_bar.dart';
import 'package:app/issue_list/widgets/issue_list_tile.dart';

/// Issue一覧のView（BlocBuilder で UI を構築）
class IssueListView extends StatefulWidget {
  const IssueListView({super.key});

  @override
  State<IssueListView> createState() => _IssueListViewState();
}

class _IssueListViewState extends State<IssueListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<IssueListBloc>().add(const IssueListNextPageRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssueListBloc, IssueListState>(
      builder: (context, state) {
        return Column(
          children: [
            // フィルタバー
            IssueFilterBar(
              currentStateFilter: state.stateFilter,
              currentLabelFilter: state.labelFilter,
              availableLabels: state.availableLabels,
              onStateFilterChanged: (filter) {
                context.read<IssueListBloc>().add(
                  IssueListStateFilterChanged(filter: filter),
                );
              },
              onLabelFilterChanged: (label) {
                context.read<IssueListBloc>().add(
                  IssueListLabelFilterChanged(label: label),
                );
              },
            ),
            // コンテンツ
            Expanded(child: _buildContent(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, IssueListState state) {
    switch (state.status) {
      case IssueListStatus.initial:
      case IssueListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case IssueListStatus.failure:
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
                  context.read<IssueListBloc>().add(const IssueListFetched());
                },
                child: const Text('再試行'),
              ),
            ],
          ),
        );
      case IssueListStatus.success:
        if (state.issues.isEmpty) {
          return const Center(child: Text('Issueがありません'));
        }
        return ListView.separated(
          controller: _scrollController,
          itemCount: state.hasReachedMax
              ? state.issues.length
              : state.issues.length + 1,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            if (index >= state.issues.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final issue = state.issues[index];
            return IssueListTile(
              issue: issue,
              onTap: () {
                Navigator.of(context).push(
                  IssueDetailPage.route(issueNumber: issue.number),
                );
              },
            );
          },
        );
    }
  }
}
