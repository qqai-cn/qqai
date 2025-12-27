import 'package:freezed_annotation/freezed_annotation.dart';

part 'flow.freezed.dart';
part 'flow.g.dart';

@freezed
abstract class Flow with _$Flow {
  const factory Flow({
    required String id,
    required String name,
    @Default('') String description,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Flow;

  factory Flow.fromJson(Map<String, dynamic> json) =>
      _$FlowFromJson(json);
}
