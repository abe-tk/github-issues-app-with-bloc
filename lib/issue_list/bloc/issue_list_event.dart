import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/issue_list/bloc/issue_list_state.dart';

part 'issue_list_event.freezed.dart';

/// Issue一覧画面のEvent
@freezed
sealed class IssueListEvent with _$IssueListEvent {
  /// 初回取得・再試行
  const factory IssueListEvent.fetched() = IssueListFetched;

  /// 次ページ読み込み
  const factory IssueListEvent.nextPageRequested() = IssueListNextPageRequested;

  /// stateフィルタ変更
  const factory IssueListEvent.stateFilterChanged({
    required IssueStateFilter filter,
  }) = IssueListStateFilterChanged;

  /// ラベルフィルタ変更
  const factory IssueListEvent.labelFilterChanged({String? label}) =
      IssueListLabelFilterChanged;
}
