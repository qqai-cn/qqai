import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_model.freezed.dart';
part 'help_model.g.dart';

@freezed
sealed class HelpModel with _$HelpModel {
  const factory HelpModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _HelpModel;

  factory HelpModel.fromJson(Map<String, dynamic> json) =>
      _$HelpModelFromJson(json);
}
