import 'package:freezed_annotation/freezed_annotation.dart';

part 'square_model.freezed.dart';
part 'square_model.g.dart';

/// 广场条目（SkuuSquareRespVO）
@freezed
sealed class SquareItem with _$SquareItem {
  const factory SquareItem({
    int? id,
    String? squareName,
    int? userId,
    String? userAvatar,
    String? squareImg,
    String? squareDesc,
    int? areaId,
    String? areaName,
    int? chatConversationId,
    bool? hasChatConversation,
    int? blogCount,
    bool? followedByMe,
    String? createTime,
  }) = _SquareItem;

  factory SquareItem.fromJson(Map<String, dynamic> json) =>
      _$SquareItemFromJson(json);
}

@freezed
sealed class SquarePageData with _$SquarePageData {
  const factory SquarePageData({
    int? total,
    List<SquareItem>? list,
  }) = _SquarePageData;

  factory SquarePageData.fromJson(Map<String, dynamic> json) =>
      _$SquarePageDataFromJson(json);
}

/// 加入广场群聊响应（SkuuSquareConversationRespVO）
@freezed
sealed class SquareConversationJoinResult with _$SquareConversationJoinResult {
  const factory SquareConversationJoinResult({
    int? squareId,
    int? chatConversationId,
  }) = _SquareConversationJoinResult;

  factory SquareConversationJoinResult.fromJson(Map<String, dynamic> json) =>
      _$SquareConversationJoinResultFromJson(json);
}
