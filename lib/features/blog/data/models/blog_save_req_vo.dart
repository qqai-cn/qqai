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
    String? content,
    String? resources,
    int? addressId,
    String? address,
    int? shareType,
  }) = _BlogSaveReqVO;

  factory BlogSaveReqVO.fromJson(Map<String, dynamic> json) =>
      _$BlogSaveReqVOFromJson(json);
}