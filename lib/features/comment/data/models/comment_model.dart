import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
sealed class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
