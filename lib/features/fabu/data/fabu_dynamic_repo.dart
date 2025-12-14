import 'package:dio/dio.dart';
import 'package:qqai/constant/api_constant.dart';

import '../../data/models/skuu_blog_save_entity.dart';

class FabuDynamicRepo {
  FabuDynamicRepo({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstant.BASE_URL,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ));

  final Dio _dio;

  /// 保存动态
  Future<void> saveBlog(SkuuBlogSaveEntity saveEntity) async {
    try {
      await _dio.post(
        ApiConstant.BLOG_SAVE,
        queryParameters: saveEntity.toJson(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to save blog: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
