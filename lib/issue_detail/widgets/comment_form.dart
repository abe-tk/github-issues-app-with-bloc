import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_detail/bloc/issue_detail_cubit.dart';
import 'package:app/issue_detail/bloc/issue_detail_state.dart';

/// コメント投稿フォーム
class CommentForm extends StatefulWidget {
  const CommentForm({super.key});

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IssueDetailCubit, IssueDetailState>(
      listenWhen: (previous, current) =>
          previous.commentPostingStatus != current.commentPostingStatus,
      listener: (context, state) {
        if (state.commentPostingStatus == CommentPostingStatus.success) {
          _controller.clear();
        } else if (state.commentPostingStatus == CommentPostingStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.commentErrorMessage ?? 'コメントの投稿に失敗しました',
              ),
            ),
          );
        }
      },
      child: BlocSelector<IssueDetailCubit, IssueDetailState,
          CommentPostingStatus>(
        selector: (state) => state.commentPostingStatus,
        builder: (context, postingStatus) {
          final isPosting = postingStatus == CommentPostingStatus.posting;
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SafeArea(
              top: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      readOnly: isPosting,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'コメントを入力...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  isPosting
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          onPressed: _hasText ? _submit : null,
                          icon: const Icon(Icons.send),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    final body = _controller.text.trim();
    if (body.isEmpty) return;
    context.read<IssueDetailCubit>().addComment(body);
  }
}
