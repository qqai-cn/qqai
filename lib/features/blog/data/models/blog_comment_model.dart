import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_comment_model.freezed.dart';
part 'blog_comment_model.g.dart';

List<BlogComment> previewRepliesFromJson(dynamic json) {
  if (json == null) return [];
  if (json is List) {
    return json
        .whereType<Map<String, dynamic>>()
        .map(BlogComment.fromJson)
        .toList();
  }
  if (json is Map<String, dynamic>) {
    final list = json['list'] ?? json['records'];
    if (list is List) {
      return list
          .whereType<Map<String, dynamic>>()
          .map(BlogComment.fromJson)
          .toList();
    }
  }
  return [];
}

List<dynamic> previewRepliesToJson(List<BlogComment> list) =>
    list.map((e) => e.toJson()).toList();

@freezed
sealed class BlogComment with _$BlogComment {
  const factory BlogComment({
    int? id,
    int? blogId,
    int? userId,
    String? nickname,
    String? avatar,
    String? content,
    int? parentId,
    int? rootId,
    int? replyUserId,
    String? replyNickname,
    int? likeCount,
    bool? liked,
    int? replyCount,
    bool? pinned,
    String? pinTime,
    @JsonKey(fromJson: previewRepliesFromJson, toJson: previewRepliesToJson)
    @Default([])
    List<BlogComment> previewReplies,
    String? createTime,
  }) = _BlogComment;

  factory BlogComment.fromJson(Map<String, dynamic> json) =>
      _$BlogCommentFromJson(json);
}

@freezed
sealed class BlogCommentPageData with _$BlogCommentPageData {
  const factory BlogCommentPageData({
    List<BlogComment>? list,
    int? total,
  }) = _BlogCommentPageData;

  factory BlogCommentPageData.fromJson(Map<String, dynamic> json) =>
      _$BlogCommentPageDataFromJson(json);
}
