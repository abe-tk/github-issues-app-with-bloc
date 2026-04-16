import 'package:flutter/material.dart';

import 'package:app/issue_list/bloc/issue_list_state.dart';
import 'package:app/models/label.dart';

/// Issue一覧のフィルタバー（stateドロップダウン + ラベル選択チップ）
class IssueFilterBar extends StatelessWidget {
  final IssueStateFilter currentStateFilter;
  final String? currentLabelFilter;
  final List<Label> availableLabels;
  final ValueChanged<IssueStateFilter> onStateFilterChanged;
  final ValueChanged<String?> onLabelFilterChanged;

  const IssueFilterBar({
    super.key,
    required this.currentStateFilter,
    this.currentLabelFilter,
    required this.availableLabels,
    required this.onStateFilterChanged,
    required this.onLabelFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // stateフィルタ
          SegmentedButton<IssueStateFilter>(
            segments: const [
              ButtonSegment(value: IssueStateFilter.open, label: Text('Open')),
              ButtonSegment(
                value: IssueStateFilter.closed,
                label: Text('Closed'),
              ),
              ButtonSegment(value: IssueStateFilter.all, label: Text('All')),
            ],
            selected: {currentStateFilter},
            onSelectionChanged: (selected) {
              onStateFilterChanged(selected.first);
            },
          ),
          // ラベルフィルタ
          if (availableLabels.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // 「すべて」チップ（フィルタ解除）
                    FilterChip(
                      label: const Text('すべて'),
                      selected: currentLabelFilter == null,
                      onSelected: (_) => onLabelFilterChanged(null),
                    ),
                    const SizedBox(width: 4),
                    ...availableLabels.map((label) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: FilterChip(
                          label: Text(label.name),
                          selected: currentLabelFilter == label.name,
                          onSelected: (_) => onLabelFilterChanged(
                            currentLabelFilter == label.name
                                ? null
                                : label.name,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
