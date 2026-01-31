import 'package:freezed_annotation/freezed_annotation.dart';

part 'fabu_model.freezed.dart';
part 'fabu_model.g.dart';

@freezed
sealed class FabuModel with _$FabuModel {
  const factory FabuModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _FabuModel;

  factory FabuModel.fromJson(Map<String, dynamic> json) =>
      _$FabuModelFromJson(json);
}
