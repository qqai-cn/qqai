import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_page_model.freezed.dart';
part 'blog_page_model.g.dart';

@freezed
sealed class BlogItem with _$BlogItem {
  const factory BlogItem({
    int? id,
    int? userId,
    int? squareId,
    String? topicIds,
    int? categary,
    int? blogType,
    String? title,
    String? content,
    String? resources,
    String? coverUrl,
    int? addressId,
    String? address,
    double? latitude,
    double? longitude,
    /// 与当前位置距离（千米，附近列表时有值）
    double? distance,
    int? shareType,
    /// 点赞数
    int? zan,
    /// 评论数（含回复）
    int? commentCount,
    /// 收藏数
    int? collectCount,
    /// 转发/分享数
    int? shareCount,
    /// 当前登录用户是否已关注作者：1 是，0 否
    int? care,
    /// 作者粉丝数
    int? followerCount,
    String? creator,
    String? creatorName,
    String? creatorAvatar,
    /// 作者等级（用于等级图标，一般 1–6）
    int? creatorLevel,
    String? creatorLevelName,
    String? updater,
    String? createTime,
    String? updateTime,
    /// 当前登录用户是否已点赞：1 是，0 否（若接口未返回则视为未赞）
    int? liked,
    /// 当前登录用户是否已收藏：1 是，0 否
    int? collect,
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

