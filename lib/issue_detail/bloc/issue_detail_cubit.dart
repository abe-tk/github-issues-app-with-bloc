import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_detail/bloc/issue_detail_state.dart';
import 'package:app/models/issue.dart';
import 'package:app/repositories/comment_repository.dart';
import 'package:app/repositories/issue_repository.dart';

/// Issue詳細画面のCubit
class IssueDetailCubit extends Cubit<IssueDetailState> {
  final int _issueNumber;
  final IssueRepository _issueRepository;
  final CommentRepository _commentRepository;
  late final StreamSubscription<void> _issueChangesSubscription;

  IssueDetailCubit({
    required int issueNumber,
    required IssueRepository issueRepository,
    required CommentRepository commentRepository,
  }) : _issueNumber = issueNumber,
       _issueRepository = issueRepository,
       _commentRepository = commentRepository,
       super(const IssueDetailState()) {
    // Issueデータの変更を購読して自動再取得する
    _issueChangesSubscription = _issueRepository.changes.listen((_) {
      fetchDetail();
    });
  }

  @override
  Future<void> close() {
    _issueChangesSubscription.cancel();
    return super.close();
  }

  /// IssueのOpen/Close状態を切り替える
  Future<void> toggleState() async {
    if (state.isTogglingState || state.issue == null) return;

    emit(
      state.copyWith(isTogglingState: true, toggleErrorMessage: null),
    );

    try {
      final currentState = state.issue!.state;
      final newState = currentState == IssueState.open ? 'closed' : 'open';
      final updatedIssue = await _issueRepository.updateIssue(
        _issueNumber,
        state: newState,
      );

      emit(
        state.copyWith(issue: updatedIssue, isTogglingState: false),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isTogglingState: false,
          toggleErrorMessage: e.toString(),
        ),
      );
    }
  }

  /// Issue詳細とコメントを並行取得する
  Future<void> fetchDetail() async {
    emit(state.copyWith(status: IssueDetailStatus.loading));

    try {
      final (issue, comments) = await (
        _issueRepository.getIssue(_issueNumber),
        _commentRepository.getComments(_issueNumber),
      ).wait;

      emit(
        state.copyWith(
          status: IssueDetailStatus.success,
          issue: issue,
          comments: comments,
          errorMessage: null,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: IssueDetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    } on ParallelWaitError catch (e) {
      // (getIssue, getComments).wait の一方が失敗した場合
      emit(
        state.copyWith(
          status: IssueDetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
