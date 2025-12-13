import 'package:get/get.dart';
import 'package:qqai/app/pages/demo/getx/controllers/demo_controller.dart';

class DemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DemoController());
  }
}
