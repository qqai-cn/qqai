import 'package:get/get.dart';
import 'package:qqai/app/pages/demo/getx/domain/entity/demo_modal.dart';
import 'package:qqai/constant/api_constant.dart';

abstract class IDemoProvider {
  Future<Response<List<DemoModal>>> getDemoModals();

  Future<Response<DemoModal>> getDemoModal(int id);
}

class DemoProvider extends GetConnect implements IDemoProvider {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstant.BASE_URL;

    super.onInit();
  }

  @override
  Future<Response<List<DemoModal>>> getDemoModals() {
    return get(
      ApiConstant.BLOG_PAGE,
      decoder: (data) =>
          (data as List).map((item) => DemoModal.fromJson(item)).toList(),
    );
  }

  Future<Response<DemoModal>> getDemoModal(int path) async {
    return get('/country/$path', decoder: (data) => DemoModal.fromJson(data));
  }
}
