import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods_model.freezed.dart';
part 'goods_model.g.dart';

@freezed
sealed class GoodsModel with _$GoodsModel {
  const factory GoodsModel({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _GoodsModel;

  factory GoodsModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsModelFromJson(json);
}
