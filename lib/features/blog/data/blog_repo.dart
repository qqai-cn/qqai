import 'package:dio/dio.dart';
import 'package:qqai/constant/api_constant.dart';

import '../domain/blog_page_model.dart';

class BlogRepo {
  BlogRepo({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: ApiConstant.BASE_URL,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  final Dio _dio;

  Future<BlogPageModel> getBlogPageModel(int id) async {
    try {
      final response = await _dio.get(ApiConstant.BLOG_PAGE);
      return BlogPageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get blog page: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
