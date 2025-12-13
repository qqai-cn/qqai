import 'package:get/get.dart';

import '../thumbnail_page.dart';


class ToolController extends GetxController {

  Map<int, GenThumbnailImage> imgMap = {};
  int curStyle = 1;

  void setGenThumbnailImage(int index, GenThumbnailImage gen) {
    imgMap[index] = gen;
    update();
  }

  void setStyle(int style) {
    curStyle = style;
    update();
  }
}
