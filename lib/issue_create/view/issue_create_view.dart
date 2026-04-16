import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_create/bloc/issue_create_cubit.dart';
import 'package:app/issue_create/bloc/issue_create_state.dart';

/// Issue作成のView（Scaffold + BlocConsumer + Form）
class IssueCreateView extends StatefulWidget {
  const IssueCreateView({super.key});

  @override
  State<IssueCreateView> createState() => _IssueCreateViewState();
}

class _IssueCreateViewState extends State<IssueCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IssueCreateCubit, IssueCreateState>(
      listener: (context, state) {
        if (state.status == IssueCreateStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == IssueCreateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'エラーが発生しました'),
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == IssueCreateStatus.submitting;

        return Scaffold(
          appBar: AppBar(title: const Text('Issue作成')),
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
                      hintText: 'Issueのタイトルを入力',
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
                        hintText: 'Issueの本文を入力（Markdown対応）',
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
                  // 作成ボタン
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
                          : const Text('作成'),
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
      context.read<IssueCreateCubit>().submit(
        title: title,
        body: body.isEmpty ? null : body,
      );
    }
  }
}
