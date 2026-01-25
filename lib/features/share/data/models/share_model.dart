import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_model.freezed.dart';
part 'share_model.g.dart';

@freezed
sealed class ShareModel with _$ShareModel {
  const factory ShareModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _ShareModel;

  factory ShareModel.fromJson(Map<String, dynamic> json) =>
      _$ShareModelFromJson(json);
}
