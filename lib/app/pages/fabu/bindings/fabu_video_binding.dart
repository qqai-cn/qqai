import 'package:get/get.dart';

import '../controllers/fabu_video_controller.dart';

class FabuVideoBinding extends Bindings {
  @override
  void dependencies() {
    return
    Get.lazyPut<FabuVideoController>(
      () => FabuVideoController(),
    );
  }
}
