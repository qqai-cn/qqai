import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/my_fonts.dart';

import '../../../../router/app_routes.dart';
import '../../../../constant/constant.dart';
import '../../../data/models/weather_city_entity.dart';
import '../providers/weather_providers.dart';
import 'package:qqai/config/theme/app_typography.dart';

class WeatherLeftPage extends ConsumerWidget {
  const WeatherLeftPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weatherNotifier = ref.read(weatherProvider.notifier);
    
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: weatherState.leftWeathers.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= weatherState.weatherCitys.length) {
          return const SizedBox.shrink();
        }
        
        return InkWell(
          onTap: () {
            if (1.sw <= Constant.CHAT_TWO_VIEW_WIDTH) {
              context.push(Routes.weatherRightPageUrl);
              weatherNotifier.changeIndexLeft(index);
            } else {
              weatherNotifier.changeIndexLeft(index);
            }
          },
          child: ListItemWidget(
            weatherType: weatherState.leftWeathers[index].now.weatherType,
            city: weatherState.weatherCitys[index],
            weatherText: weatherState.leftWeathers[index].now.text,
            selected: weatherState.currentPage == index,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 5,
        );
      },
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final WeatherType weatherType;
  final WeatherCityData city;
  final String weatherText;
  final bool selected;

  ListItemWidget(
      {Key? key,
      required this.weatherType,
      required this.city,
      required this.weatherText,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ClipPath(
        child: Stack(
          children: [
            WeatherBg(
              weatherType: weatherType,
              width: MediaQuery.of(context).size.width,
              height: 100,
            ),
            Container(
              alignment: Alignment(-0.8, 0),
              height: 100,
              child: Text(
                selected
                    ? '👉 ${city.province}-${city.county}'
                    : '${city.province}-${city.county}',
                style: context.typo.pageTitle.copyWith(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment(0.8, 0),
              height: 100,
              child: Text(
                weatherText,
                style: context.typo.pageTitle.copyWith(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
      ),
    );
  }
}
