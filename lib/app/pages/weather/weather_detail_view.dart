import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/print_utils.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/weather/controllers/weather_controller.dart';
import 'package:qqai/app/pages/weather/views/perday_weather_view.dart';
import 'package:qqai/constant/constant.dart';

import '../../components/AnimatedBottomBar.dart';

/// 普通的 ViewPager 展示样式
class WeatherDetailView extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherController>(builder: (a) {
      return Scaffold(
          appBar: 1.sw > Constant.CHAT_TWO_VIEW_WIDTH
              ? null
              : AppBar(
                  title: Text(controller.weatherCitys
                          .elementAt(controller.currentPage)
                          .province +
                      '-' +
                      controller.weatherCitys.elementAt(controller.currentPage).county),
                ),
          body: Container(
            child: Stack(
              children: [
                WeatherBg(
                  weatherType:
                  controller.getCurRealTimeWeather().now.weatherType,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                PerDayWeatherView()
              ],
            ),
          ),
          );
    });
  }
}
