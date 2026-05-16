import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/blog_comment_model.dart';

final blogCommentRepoProvider = Provider<IBlogCommentRepo>(
  (ref) => BlogCommentRepo(),
);

abstract class IBlogCommentRepo {
  Future<BlogCommentPageData> getRootCommentPage({
    required int blogId,
    required int pageNo,
    int pageSize = 20,
    String sortType = 'hot',
    int previewReplySize = 2,
  });

  Future<BlogCommentPageData> getRepliesPage({
    required int rootId,
    required int pageNo,
    int pageSize = 20,
  });

  Future<int> createComment({
    required int blogId,
    required String content,
    int? parentId,
    int? replyUserId,
  });

  Future<bool> deleteComment(int id);

  Future<bool> pinComment(int id);

  Future<bool> toggleCommentLike(int commentId, {required bool currentlyLiked});

  Future<int> getCommentCount(int blogId);
}

class BlogCommentRepo implements IBlogCommentRepo {
  void _ensureEnvelope(Map<String, dynamic> root) {
    final code = root['code'];
    if (code != null && code != 0 && code != '0') {
      throw root['msg']?.toString() ?? '请求失败';
    }
  }

  BlogCommentPageData _parsePage(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      throw '评论分页返回格式错误';
    }
    _ensureEnvelope(raw);
    final inner = raw['data'];
    if (inner is! Map<String, dynamic>) {
      return const BlogCommentPageData(list: [], total: 0);
    }
    return BlogCommentPageData.fromJson(inner);
  }

  @override
  Future<BlogCommentPageData> getRootCommentPage({
    required int blogId,
    required int pageNo,
    int pageSize = 20,
    String sortType = 'hot',
    int previewReplySize = 2,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_COMMENTS_PAGE,
      RequestType.get,
      queryParameters: {
        'blogId': blogId,
        'pageNo': pageNo,
        'pageSize': pageSize,
        'sortType': sortType,
        'previewReplySize': previewReplySize,
      },
    );
    return _parsePage(response.data);
  }

  @override
  Future<BlogCommentPageData> getRepliesPage({
    required int rootId,
    required int pageNo,
    int pageSize = 20,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_COMMENTS_REPLIES_PAGE,
      RequestType.get,
      queryParameters: {
        'rootId': rootId,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    return _parsePage(response.data);
  }

  @override
  Future<int> createComment({
    required int blogId,
    required String content,
    int? parentId,
    int? replyUserId,
  }) async {
    final body = <String, dynamic>{
      'blogId': blogId,
      'content': content,
    };
    if (parentId != null && parentId > 0) {
      body['parentId'] = parentId;
    }
    if (replyUserId != null && replyUserId > 0) {
      body['replyUserId'] = replyUserId;
    }
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_COMMENTS,
      RequestType.post,
      data: body,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '发表评论返回格式错误';
    }
    _ensureEnvelope(data);
    final id = data['data'];
    if (id is num) return id.toInt();
    throw '未返回评论编号';
  }

  @override
  Future<bool> deleteComment(int id) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogCommentPath(id),
      RequestType.delete,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '删除评论返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<bool> pinComment(int id) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogCommentPinPath(id),
      RequestType.post,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '置顶评论返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<bool> toggleCommentLike(
    int commentId, {
    required bool currentlyLiked,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogCommentLikePath(commentId),
      currentlyLiked ? RequestType.delete : RequestType.post,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '评论点赞返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<int> getCommentCount(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_COMMENTS_COUNT,
      RequestType.get,
      queryParameters: {'blogId': blogId},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '评论总数返回格式错误';
    }
    _ensureEnvelope(data);
    final count = data['data'];
    if (count is num) return count.toInt();
    return 0;
  }
}
