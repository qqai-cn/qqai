import 'package:get/get.dart';
import 'package:qqai/app/pages/tool/controllers/tool_controller.dart';

class ToolBing extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ToolController());
  }
}
