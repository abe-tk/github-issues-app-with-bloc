import 'package:freezed_annotation/freezed_annotation.dart';

part 'issue_create_state.freezed.dart';

/// Issue作成の処理ステータス
enum IssueCreateStatus { initial, submitting, success, failure }

/// Issue作成画面の状態
/// title/body は UI 側の TextEditingController で保持する
@freezed
abstract class IssueCreateState with _$IssueCreateState {
  const factory IssueCreateState({
    @Default(IssueCreateStatus.initial) IssueCreateStatus status,
    String? errorMessage,
  }) = _IssueCreateState;
}
