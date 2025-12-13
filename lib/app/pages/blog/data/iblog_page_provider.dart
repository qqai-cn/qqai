import 'package:get/get.dart';
import 'package:qqai/app/pages/blog/domain/entity/blog_page_model.dart';
import 'package:qqai/app/pages/demo/getx/domain/entity/demo_modal.dart';
import 'package:qqai/constant/api_constant.dart';

abstract class IBlogPageProvider {
  Future<Response<BlogPageModel>> getBlogPageModel(int id);
}

class BlogPageProvider extends GetConnect implements IBlogPageProvider {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstant.BASE_URL;
    super.onInit();
  }

  Future<Response<DemoModal>> getDemoModal(int path) async {
    return get('/country/$path', decoder: (data) => DemoModal.fromJson(data));
  }

  @override
  Future<Response<BlogPageModel>> getBlogPageModel(int id) {
    return get(ApiConstant.BLOG_PAGE,
        decoder: (data) => BlogPageModel.fromJson(data));
  }
}
