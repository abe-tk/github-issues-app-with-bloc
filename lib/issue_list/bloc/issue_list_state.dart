import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/models/models.dart';

part 'issue_list_state.freezed.dart';

/// Issue一覧の読み込みステータス
enum IssueListStatus { initial, loading, success, failure }

/// Issue一覧画面のフィルタ種別
enum IssueStateFilter {
  open,
  closed,
  all;

  /// GitHub API に渡す文字列を返す
  String toApiValue() => name;
}

/// Issue一覧画面の状態
@freezed
abstract class IssueListState with _$IssueListState {
  const factory IssueListState({
    @Default(IssueListStatus.initial) IssueListStatus status,
    @Default([]) List<Issue> issues,
    @Default(false) bool hasReachedMax,
    @Default(IssueStateFilter.open) IssueStateFilter stateFilter,
    String? labelFilter,
    String? errorMessage,
    @Default([]) List<Label> availableLabels,
  }) = _IssueListState;
}
