import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'perday_weather_view.dart';
import '../../../../../constant/constant.dart';

import '../providers/weather_providers.dart';

/// 普通的 ViewPager 展示样式
class WeatherDetailView extends ConsumerWidget {
  const WeatherDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weatherNotifier = ref.read(weatherProvider.notifier);
    
    if (weatherState.weatherCitys.isEmpty || weatherState.currentPage < 0) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      appBar: 1.sw > Constant.CHAT_TWO_VIEW_WIDTH
          ? null
          : AppBar(
              title: Text(weatherState.weatherCitys
                      .elementAt(weatherState.currentPage)
                      .province +
                  '-' +
                  weatherState.weatherCitys.elementAt(weatherState.currentPage).county),
            ),
      body: Container(
        child: Stack(
          children: [
            WeatherBg(
              weatherType:
              weatherNotifier.getCurRealTimeWeather().now.weatherType,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            const PerDayWeatherView()
          ],
        ),
      ),
    );
  }
}
