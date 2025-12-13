import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qqai/app/components/my_widgets_animator.dart';
import 'package:qqai/app/pages/weather/controllers/weather_controller.dart';
import 'package:qqai/app/pages/weather/weather_detail_view.dart';
import 'package:qqai/app/pages/weather/weather_left_page.dart';
import 'package:qqai/constant/constant.dart';

import '../../../config/translations/strings_enum.dart';
import '../../components/api_error_widget.dart';
import '../../data/models/city_menu_model_entity.dart';

class WeatherHomePage extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Spacer(),
              Container(
                  width: 0.7.sw,
                  height: 40,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.w),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "快速搜索",
                      prefixIcon: Icon(Icons.search),
                    ),
                    controller: controller.textEditingController,
                    onTap: () async {
                      // type 2
                      Result? result2 =
                          await CityPickers.showFullPageCityPicker(
                        showType: ShowType.pcav,
                        context: context,
                      );
                      controller.updateSelCity(result2!);
                    },
                    // onChanged: (t) async {
                    //
                    // },
                  )),
              if (controller.textEditingController.text != '')
                IconButton(
                  icon: Icon(Icons.add_circle_sharp),
                  onPressed: () {},
                ),
              IconButton(
                icon: Icon(Icons.location_on),
                onPressed: () {
                  controller.getRealTimeWeather();
                },
              ),
              Spacer(),
            ],
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: MyWidgetsAnimator(
                    apiCallStatus: controller.apiCallStatus,
                    loadingWidget: () => const Center(child: CupertinoActivityIndicator(),),
                    errorWidget: () => ApiErrorWidget(
                      message: Strings.internetError.tr,
                      retryAction: () => controller.getCityList(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                    ),
                    successWidget: () => WeatherLeftPage())),
            if (1.sw > Constant.CHAT_TWO_VIEW_WIDTH)
              Expanded(flex: 5, child: WeatherDetailView()),
          ],
        ),
      );
    });
  }
}
