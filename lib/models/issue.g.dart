// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Issue _$IssueFromJson(Map<String, dynamic> json) => _Issue(
  number: (json['number'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String?,
  state: $enumDecode(_$IssueStateEnumMap, json['state']),
  labels: (json['labels'] as List<dynamic>)
      .map((e) => Label.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
  pullRequest: json['pull_request'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$IssueToJson(_Issue instance) => <String, dynamic>{
  'number': instance.number,
  'title': instance.title,
  'body': instance.body,
  'state': _$IssueStateEnumMap[instance.state]!,
  'labels': instance.labels,
  'created_at': instance.createdAt.toIso8601String(),
  'pull_request': instance.pullRequest,
};

const _$IssueStateEnumMap = {
  IssueState.open: 'open',
  IssueState.closed: 'closed',
};
