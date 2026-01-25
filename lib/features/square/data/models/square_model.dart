import 'package:freezed_annotation/freezed_annotation.dart';

part 'square_model.freezed.dart';
part 'square_model.g.dart';

@freezed
sealed class SquareModel with _$SquareModel {
  const factory SquareModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _SquareModel;

  factory SquareModel.fromJson(Map<String, dynamic> json) =>
      _$SquareModelFromJson(json);
}
