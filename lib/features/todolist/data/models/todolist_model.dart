import 'package:freezed_annotation/freezed_annotation.dart';

part 'todolist_model.freezed.dart';
part 'todolist_model.g.dart';

@freezed
sealed class TodoListModel with _$TodoListModel {
  const factory TodoListModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _TodoListModel;

  factory TodoListModel.fromJson(Map<String, dynamic> json) =>
      _$TodoListModelFromJson(json);
}
