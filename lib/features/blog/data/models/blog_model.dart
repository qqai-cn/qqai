import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_model.freezed.dart';
part 'blog_model.g.dart';

@freezed
sealed class BlogModel with _$BlogModel {
  const factory BlogModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _BlogModel;

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);
}
