import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ShortVideoController extends GetxController {
  final videoItems = <String>[
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
  ].obs;

  final double maxCross = 1000;

  double getRatio() {
    double width = 1.sw;
    if (width > maxCross) {
      width = 0.5.sw;
    }
    return width / (width / (15 / 9) + 150);
  }
}
