import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_update/bloc/issue_update_cubit.dart';
import 'package:app/issue_update/bloc/issue_update_state.dart';
import 'package:app/models/issue.dart';

/// Issue編集のView（StatefulWidget: Scaffold + BlocConsumer + Form）
class IssueUpdateView extends StatefulWidget {
  final Issue issue;

  const IssueUpdateView({super.key, required this.issue});

  @override
  State<IssueUpdateView> createState() => _IssueUpdateViewState();
}

class _IssueUpdateViewState extends State<IssueUpdateView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.issue.title);
    _bodyController = TextEditingController(text: widget.issue.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IssueUpdateCubit, IssueUpdateState>(
      listener: (context, state) {
        if (state.status == IssueUpdateStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == IssueUpdateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'エラーが発生しました'),
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == IssueUpdateStatus.submitting;

        return Scaffold(
          appBar: AppBar(title: const Text('Issue編集')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // タイトル入力
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'タイトル',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'タイトルを入力してください';
                      }
                      return null;
                    },
                    enabled: !isSubmitting,
                  ),
                  const SizedBox(height: 16),
                  // 本文入力
                  Expanded(
                    child: TextFormField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        labelText: '本文（任意）',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      enabled: !isSubmitting,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 保存ボタン
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _onSubmit,
                      child: isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('保存'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final body = _bodyController.text.trim();
      context.read<IssueUpdateCubit>().submit(
        title: title,
        body: body.isEmpty ? null : body,
      );
    }
  }
}
