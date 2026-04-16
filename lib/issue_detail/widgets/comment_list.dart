import 'package:flutter/material.dart';

import 'package:app/issue_detail/widgets/comment_tile.dart';
import 'package:app/models/comment.dart';

/// コメント一覧を SliverList で表示するウィジェット
class CommentList extends StatelessWidget {
  final List<Comment> comments;

  const CommentList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'コメントはありません',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) => CommentTile(comment: comments[index]),
    );
  }
}
