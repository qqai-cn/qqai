import 'package:get/get.dart';

import '../controllers/fabu_dynamic_controller.dart';
import '../controllers/fabu_video_controller.dart';
import '../controllers/fabu_zuopin_controller.dart';

class FabuDynamicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FabuDynamicController>(
          () => FabuDynamicController(),
    );
  }
}
