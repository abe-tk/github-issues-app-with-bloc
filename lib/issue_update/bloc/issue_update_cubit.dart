import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_update/bloc/issue_update_state.dart';
import 'package:app/repositories/issue_repository.dart';

/// Issue編集画面のCubit
class IssueUpdateCubit extends Cubit<IssueUpdateState> {
  final int _issueNumber;
  final IssueRepository _issueRepository;

  IssueUpdateCubit({
    required int issueNumber,
    required IssueRepository issueRepository,
  }) : _issueNumber = issueNumber,
       _issueRepository = issueRepository,
       super(const IssueUpdateState());

  /// Issueを更新する。submitting 中は二重送信を防止する。
  Future<void> submit({required String title, String? body}) async {
    if (state.status == IssueUpdateStatus.submitting) return;

    emit(state.copyWith(status: IssueUpdateStatus.submitting));

    try {
      await _issueRepository.updateIssue(
        _issueNumber,
        title: title,
        body: body,
      );

      emit(state.copyWith(status: IssueUpdateStatus.success));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: IssueUpdateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
