import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/models/issue.dart';

/// Issue詳細のメタ情報（title, state, labels, createdAt）を表示するヘッダー
class IssueDetailHeader extends StatelessWidget {
  final Issue issue;

  const IssueDetailHeader({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タイトル
          Text(
            issue.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          // ステータスバッジ + 作成日時
          Row(
            children: [
              _buildStateBadge(context),
              const SizedBox(width: 8),
              Text(
                '#${issue.number} · ${DateFormat('yyyy/MM/dd').format(issue.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          // ラベル
          if (issue.labels.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: issue.labels.map((label) {
                  final color = Color(
                    int.parse('FF${label.color}', radix: 16),
                  );
                  return Chip(
                    label: Text(
                      label.name,
                      style: TextStyle(
                        fontSize: 11,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    backgroundColor: color,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStateBadge(BuildContext context) {
    final isOpen = issue.state == IssueState.open;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green : Colors.purple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOpen ? Icons.error_outline : Icons.check_circle_outline,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            isOpen ? 'Open' : 'Closed',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
