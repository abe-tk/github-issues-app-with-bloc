import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/models/issue.dart';

/// Issue一覧の1行を表示するウィジェット
class IssueListTile extends StatelessWidget {
  final Issue issue;
  final VoidCallback? onTap;

  const IssueListTile({super.key, required this.issue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        issue.state == IssueState.open
            ? Icons.error_outline
            : Icons.check_circle_outline,
        color: issue.state == IssueState.open ? Colors.green : Colors.purple,
      ),
      title: Text(issue.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#${issue.number} · ${DateFormat('yyyy/MM/dd').format(issue.createdAt)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (issue.labels.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 4,
                children: issue.labels.map((label) {
                  final color = Color(int.parse('FF${label.color}', radix: 16));
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
      onTap: onTap,
    );
  }
}
