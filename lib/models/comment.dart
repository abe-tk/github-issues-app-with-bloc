import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// GitHub Issueのコメントモデル。
/// user フィールドは GitHub API の `user.login` をフラット化して格納する。
@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required int id,
    required String body,
    @JsonKey(readValue: _readUserLogin) required String user,
    required DateTime createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

/// GitHub API の user オブジェクトから login 名を抽出する
Object? _readUserLogin(Map json, String key) =>
    (json['user'] as Map<String, dynamic>)['login'];
