import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_save_req_vo.freezed.dart';
part 'blog_save_req_vo.g.dart';

@freezed
sealed class BlogSaveReqVO with _$BlogSaveReqVO {
  const factory BlogSaveReqVO({
    int? id,
    int? squareId,
    String? topicIds,
    int? categary,
    int? blogType,
    String? title,
    String? content,
    String? resources,
    String? coverUrl,
    int? videoWidth,
    int? videoHeight,
    double? videoAspectRatio,
    int? addressId,
    String? address,
    double? latitude,
    double? longitude,
    int? shareType,
    List<int>? collectionIds,
  }) = _BlogSaveReqVO;

  factory BlogSaveReqVO.fromJson(Map<String, dynamic> json) =>
      _$BlogSaveReqVOFromJson(json);
}
