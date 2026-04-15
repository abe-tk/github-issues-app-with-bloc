import 'package:freezed_annotation/freezed_annotation.dart';

part 'label.freezed.dart';
part 'label.g.dart';

/// GitHub Issueに付与されるラベルのモデル
@freezed
abstract class Label with _$Label {
  const factory Label({
    required String name,
    required String color,
    String? description,
  }) = _Label;

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);
}
