import 'package:freezed_annotation/freezed_annotation.dart';

part 'flow_model.freezed.dart';
part 'flow_model.g.dart';

@freezed
sealed class FlowModel with _$FlowModel {
  const factory FlowModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _FlowModel;

  factory FlowModel.fromJson(Map<String, dynamic> json) =>
      _$FlowModelFromJson(json);
}
