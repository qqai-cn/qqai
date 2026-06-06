import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_comment_model.freezed.dart';
part 'blog_comment_model.g.dart';

int? blogJsonInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String? blogJsonTime(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return value.length >= 16 ? value.substring(0, 16) : value;
  }
  if (value is List && value.length >= 3) {
    final year = blogJsonInt(value[0]) ?? 0;
    final month = blogJsonInt(value[1]) ?? 1;
    final day = blogJsonInt(value[2]) ?? 1;
    final hour = value.length > 3 ? blogJsonInt(value[3]) ?? 0 : 0;
    final minute = value.length > 4 ? blogJsonInt(value[4]) ?? 0 : 0;
    return '${year.toString().padLeft(4, '0')}-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')} '
        '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }
  return value.toString();
}

Map<String, dynamic> normalizeBlogCommentJson(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);
  for (final key in [
    'id',
    'blogId',
    'userId',
    'parentId',
    'rootId',
    'replyUserId',
    'likeCount',
    'replyCount',
  ]) {
    if (normalized.containsKey(key)) {
      normalized[key] = blogJsonInt(normalized[key]);
    }
  }
  if (normalized.containsKey('createTime')) {
    normalized['createTime'] = blogJsonTime(normalized['createTime']);
  }
  if (normalized.containsKey('pinTime')) {
    normalized['pinTime'] = blogJsonTime(normalized['pinTime']);
  }
  return normalized;
}

List<BlogComment> previewRepliesFromJson(dynamic json) {
  if (json == null) return [];
  if (json is List) {
    return json
        .whereType<Map<String, dynamic>>()
        .map((e) => BlogComment.fromJson(e))
        .toList();
  }
  if (json is Map<String, dynamic>) {
    final list = json['list'] ?? json['records'];
    if (list is List) {
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => BlogComment.fromJson(e))
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
      _$BlogCommentFromJson(normalizeBlogCommentJson(json));
}

BlogCommentPageData blogCommentPageDataFromJson(Map<String, dynamic> json) {
  final listRaw = json['list'] ?? json['records'];
  List<BlogComment>? list;
  if (listRaw is List) {
    list = listRaw
        .whereType<Map>()
        .map((e) => BlogComment.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
  return BlogCommentPageData(
    list: list,
    total: blogJsonInt(json['total']),
  );
}

@freezed
sealed class BlogCommentPageData with _$BlogCommentPageData {
  const factory BlogCommentPageData({
    List<BlogComment>? list,
    int? total,
  }) = _BlogCommentPageData;

  factory BlogCommentPageData.fromJson(Map<String, dynamic> json) =>
      blogCommentPageDataFromJson(json);
}
