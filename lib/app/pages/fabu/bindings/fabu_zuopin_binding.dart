import 'package:get/get.dart';
import 'package:qqai/app/pages/fabu/controllers/fabu_aixin_controller.dart';
import 'package:qqai/app/pages/fabu/controllers/fabu_goods_controller.dart';

import '../controllers/fabu_dynamic_controller.dart';
import '../controllers/fabu_video_controller.dart';
import '../controllers/fabu_zuopin_controller.dart';

class FabuZuoPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FabuZuoPinController>(
      () => FabuZuoPinController(),
    );

    Get.lazyPut<FabuDynamicController>(
      () => FabuDynamicController(),
      fenix: true,
    );
    Get.lazyPut<FabuVideoController>(
      () => FabuVideoController(),
      fenix: true,
    );
    Get.lazyPut<FabuGoodsController>(
          () => FabuGoodsController(),
      fenix: true,
    );
    Get.lazyPut<FabuAiXinController>(
          () => FabuAiXinController(),
      fenix: true,
    );
  }
}
