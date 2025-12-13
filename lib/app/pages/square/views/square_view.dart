import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/square/controllers/square_controller.dart';
import 'package:qqai/app/pages/square/views/square_item_view.dart';
import 'package:qqai/util/constants.dart';

import '../../../../constant/constant.dart';

class SquareView extends GetView<SquareController> {
  const SquareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400.0,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio:
                  1.sw > Constant.SQUARE_SPLIT_WIDTH ? 5 / 4 : 5/4),
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            return SquareItemView();
          });
    });
  }
}
