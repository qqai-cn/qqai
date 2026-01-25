import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_page_model.freezed.dart';
part 'share_page_model.g.dart';

@freezed
sealed class ShareItem with _$ShareItem {
  const factory ShareItem({
    int? blogType,
    int? care,
    int? categary,
    String? content,
    String? creatorName,
    int? id,
    String? resources,
    int? shareType,
    int? squareId,
    String? topicIds,
    String? updateTime,
    int? zan,
  }) = _ShareItem;

  factory ShareItem.fromJson(Map<String, dynamic> json) => _$ShareItemFromJson(json);
}

@freezed
sealed class SharePageModelData with _$SharePageModelData {
  const factory SharePageModelData({
    List<ShareItem>? list,
    int? total,
  }) = _SharePageModelData;

  factory SharePageModelData.fromJson(Map<String, dynamic> json) => _$SharePageModelDataFromJson(json);
}

@freezed
sealed class SharePageModel with _$SharePageModel {
  const factory SharePageModel({
    int? code,
    SharePageModelData? data,
    String? msg,
  }) = _SharePageModel;

  factory SharePageModel.fromJson(Map<String, dynamic> json) => _$SharePageModelFromJson(json);
}

