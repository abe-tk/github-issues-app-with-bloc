import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/models/models.dart';

part 'issue_detail_state.freezed.dart';

/// Issue詳細の読み込みステータス
enum IssueDetailStatus { initial, loading, success, failure }

/// Issue詳細画面の状態
@freezed
abstract class IssueDetailState with _$IssueDetailState {
  const factory IssueDetailState({
    @Default(IssueDetailStatus.initial) IssueDetailStatus status,
    Issue? issue,
    @Default([]) List<Comment> comments,
    String? errorMessage,
  }) = _IssueDetailState;
}
