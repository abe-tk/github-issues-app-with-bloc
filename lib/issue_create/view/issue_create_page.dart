import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_create/bloc/issue_create_cubit.dart';
import 'package:app/issue_create/view/issue_create_view.dart';
import 'package:app/repositories/issue_repository.dart';

/// Issue作成のPage（BlocProvider を配置するエントリポイント）
class IssueCreatePage extends StatelessWidget {
  const IssueCreatePage({super.key});

  /// Issue作成画面への MaterialPageRoute を生成する。
  /// 作成成功時は true を返し、キャンセル時は null を返す。
  static Route<bool?> route() {
    return MaterialPageRoute(
      builder: (_) => const IssueCreatePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IssueCreateCubit(
        issueRepository: context.read<IssueRepository>(),
      ),
      child: const IssueCreateView(),
    );
  }
}
