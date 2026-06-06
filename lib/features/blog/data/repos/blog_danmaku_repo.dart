import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/constant/api_constant.dart';
import 'package:qqai/features/blog/data/models/blog_danmaku_model.dart';
import 'package:qqai/util/api_base_client.dart';

final blogDanmakuRepoProvider = Provider<IBlogDanmakuRepo>(
  (ref) => BlogDanmakuRepo(),
);

abstract class IBlogDanmakuRepo {
  Future<List<BlogDanmakuItem>> getDanmakuList(int blogId);

  Future<int> createDanmaku({
    required int blogId,
    required String content,
    required int positionMillis,
  });
}

class BlogDanmakuRepo implements IBlogDanmakuRepo {
  @override
  Future<List<BlogDanmakuItem>> getDanmakuList(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_DANMAKU_LIST,
      RequestType.get,
      queryParameters: {'blogId': blogId},
    );
    final raw = response.data;
    if (raw is! Map<String, dynamic>) return const [];
    final data = raw['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map(
          (item) => BlogDanmakuItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.id > 0 && item.content.trim().isNotEmpty)
        .toList();
  }

  @override
  Future<int> createDanmaku({
    required int blogId,
    required String content,
    required int positionMillis,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_DANMAKU,
      RequestType.post,
      data: {
        'blogId': blogId,
        'content': content.trim(),
        'positionMillis': positionMillis,
      },
    );
    final raw = response.data;
    if (raw is! Map<String, dynamic>) return 0;
    return (raw['data'] as num?)?.toInt() ?? 0;
  }
}
