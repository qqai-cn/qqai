import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/blog_model.dart';
import '../models/blog_save_req_vo.dart';

final blogRepoProvider = Provider<IBlogRepo>((ref) => BlogRepo());

abstract class IBlogRepo {
  Future<List<BlogModel>> getAllBlogs();

  Future<BlogModel?> getBlogById(String id);

  Future<void> addBlog(BlogModel item);

  Future<void> updateBlog(BlogModel item);

  Future<void> deleteBlog(String id);

  Future<BlogPageModelData> getBlogPageModelData();
  
  Future<BlogPageModelData> getBlogPageModelDataWithPage(
    int page, {
    int pageSize = 10,
    int? blogType,
  });
  
  Future<void> createBlog(BlogSaveReqVO req);
}

class BlogRepo implements IBlogRepo {
  final List<BlogModel> _items = [];

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<BlogModel?> getBlogById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addBlog(BlogModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateBlog(BlogModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteBlog(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<BlogPageModelData> getBlogPageModelData() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_PAGE,
      RequestType.get,
    );
    return BlogPageModel.fromJson(response.data).data!;
  }

  @override
  Future<BlogPageModelData> getBlogPageModelDataWithPage(
    int page, {
    int pageSize = 10,
    int? blogType,
  }) async {
    final query = <String, dynamic>{
      'pageNo': page,
      'pageSize': pageSize,
    };
    if (blogType != null) {
      query['blogType'] = blogType;
    }
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    return BlogPageModel.fromJson(response.data).data!;
  }
  
  @override
  Future<void> createBlog(BlogSaveReqVO req) async {
    await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_SAVE,
      RequestType.post,
      data: req.toJson(),
    );
  }
}