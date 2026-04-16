import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/issue_detail/bloc/issue_detail_state.dart';
import 'package:app/repositories/comment_repository.dart';
import 'package:app/repositories/issue_repository.dart';

/// Issue詳細画面のCubit
class IssueDetailCubit extends Cubit<IssueDetailState> {
  final int _issueNumber;
  final IssueRepository _issueRepository;
  final CommentRepository _commentRepository;

  IssueDetailCubit({
    required int issueNumber,
    required IssueRepository issueRepository,
    required CommentRepository commentRepository,
  }) : _issueNumber = issueNumber,
       _issueRepository = issueRepository,
       _commentRepository = commentRepository,
       super(const IssueDetailState());

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
    }
  }
}
