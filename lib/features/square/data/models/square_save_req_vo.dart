import 'package:freezed_annotation/freezed_annotation.dart';

part 'square_save_req_vo.freezed.dart';
part 'square_save_req_vo.g.dart';

/// 广场创建/更新请求（SkuuSquareSaveReqVO）
@freezed
sealed class SquareSaveReqVO with _$SquareSaveReqVO {
  const factory SquareSaveReqVO({
    required int id,
    required String squareName,
    int? userId,
    String? squareImg,
    String? squareDesc,
    int? areaId,
    int? chatConversationId,
    int? groupCreatorUserId,
  }) = _SquareSaveReqVO;

  factory SquareSaveReqVO.fromJson(Map<String, dynamic> json) =>
      _$SquareSaveReqVOFromJson(json);
}
