import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_create/bloc/issue_create_state.dart';
import 'package:app/repositories/issue_repository.dart';

/// Issue作成画面のCubit
class IssueCreateCubit extends Cubit<IssueCreateState> {
  final IssueRepository _issueRepository;

  IssueCreateCubit({required IssueRepository issueRepository})
    : _issueRepository = issueRepository,
      super(const IssueCreateState());

  /// Issueを作成する。submitting 中は二重送信を防止する。
  Future<void> submit({required String title, String? body}) async {
    if (state.status == IssueCreateStatus.submitting) return;

    emit(state.copyWith(status: IssueCreateStatus.submitting));

    try {
      await _issueRepository.createIssue(
        title: title,
        body: body,
      );

      emit(state.copyWith(status: IssueCreateStatus.success));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: IssueCreateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
