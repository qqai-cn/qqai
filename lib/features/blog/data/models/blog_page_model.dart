import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_page_model.freezed.dart';
part 'blog_page_model.g.dart';

@freezed
sealed class BlogItem with _$BlogItem {
  const factory BlogItem({
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
  }) = _BlogItem;

  factory BlogItem.fromJson(Map<String, dynamic> json) => _$BlogItemFromJson(json);
}

@freezed
sealed class BlogPageModelData with _$BlogPageModelData {
  const factory BlogPageModelData({
    List<BlogItem>? list,
    int? total,
  }) = _BlogPageModelData;

  factory BlogPageModelData.fromJson(Map<String, dynamic> json) => _$BlogPageModelDataFromJson(json);
}

@freezed
sealed class BlogPageModel with _$BlogPageModel {
  const factory BlogPageModel({
    int? code,
    BlogPageModelData? data,
    String? msg,
  }) = _BlogPageModel;

  factory BlogPageModel.fromJson(Map<String, dynamic> json) => _$BlogPageModelFromJson(json);
}

