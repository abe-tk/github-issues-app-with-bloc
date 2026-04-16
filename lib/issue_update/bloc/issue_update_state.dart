import 'package:freezed_annotation/freezed_annotation.dart';

part 'issue_update_state.freezed.dart';

/// Issue更新の処理ステータス
enum IssueUpdateStatus { initial, submitting, success, failure }

/// Issue編集画面の状態
/// title/body は UI 側の TextEditingController で保持する
@freezed
abstract class IssueUpdateState with _$IssueUpdateState {
  const factory IssueUpdateState({
    @Default(IssueUpdateStatus.initial) IssueUpdateStatus status,
    String? errorMessage,
  }) = _IssueUpdateState;
}
