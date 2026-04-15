import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/models/label.dart';

part 'issue.freezed.dart';
part 'issue.g.dart';

/// GitHub IssueのstateをあらわすEnum
enum IssueState {
  open,
  closed;

  /// GitHub APIのレスポンス文字列からEnumに変換する
  static IssueState fromString(String value) {
    return IssueState.values.byName(value);
  }
}

/// GitHub Issueのモデル
@freezed
abstract class Issue with _$Issue {
  const Issue._();

  const factory Issue({
    required int number,
    required String title,
    String? body,
    required IssueState state,
    required List<Label> labels,
    required DateTime createdAt,

    /// Pull Requestかどうかを判定するためのフィールド。
    /// GitHub REST APIの /issues エンドポイントはPRも返すため、
    /// このフィールドが非nullならPRとして扱う。
    Map<String, dynamic>? pullRequest,
  }) = _Issue;

  /// Pull Requestかどうかを返す
  bool get isPullRequest => pullRequest != null;

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
}
