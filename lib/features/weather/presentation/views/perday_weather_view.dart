import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qqai/config/theme/my_fonts.dart';

import '../../../../components/custom_process_widget.dart';
import '../../../data/models/day_weather_entity.dart';
import '../../../data/models/hour_weather_entity.dart';
import '../providers/weather_providers.dart';
import 'package:qqai/config/theme/app_typography.dart';


class PerDayWeatherView extends ConsumerWidget {
  const PerDayWeatherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weatherNotifier = ref.read(weatherProvider.notifier);
    final Color primaryTextColor =
        weatherState.ifOnHour ? Colors.red : Colors.white;
    
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Container(
                  width: 450,
                  height: 160,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Card(
                          color: Colors.grey,
                          child: Container(
                            width: 450,
                            height: 160,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${weatherNotifier.getCurWeatherCityData().province}|${weatherNotifier.getCurWeatherCityData().county}',
                            style: context.typo.pageTitle.copyWith(fontSize: 20, color: primaryTextColor),
                          ),
                          Text(
                            '温度：${weatherNotifier.getCurRealTimeWeather().now.temp} ℃   |  体感温度：${weatherNotifier.getCurRealTimeWeather().now.feelsLike} ℃',
                            style: context.typo.body.copyWith(fontSize: 20, color: primaryTextColor),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'imgs/weather/${weatherNotifier.getCurRealTimeWeather().now.icon}.svg',
                                fit: BoxFit.cover,
                                height: 20,
                                width: 20,
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${weatherNotifier.getCurRealTimeWeather().now.text}',
                                style: context.typo.sectionTitle.copyWith(fontSize: 20, color: primaryTextColor),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 20,
                              children:
                                  weatherNotifier.getCurCard1().entries.map((entry) {
                                return Text(
                                  '${entry.key} \n ${entry.value}',
                                  style: context.typo.body.copyWith(color: primaryTextColor),
                                );
                              }).toList())
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 450,
                  height: 160,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Card(
                          color: Colors.grey,
                          child: Container(
                            width: 450,
                            height: 160,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '24小时天气',
                                    style: context.typo.sectionTitle.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              Divider(),
                              Expanded(
                                child: RawScrollbar(
                                  thumbVisibility: true,
                                  thumbColor: Colors.white,
                                  radius: const Radius.circular(4),
                                  child: ListView(
                                    primary: true,
                                    controller: weatherState.hourController,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (HourWeatherHourly item
                                          in weatherState.hourly)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: Column(
                                            spacing: 10,
                                            children: [
                                              Text(
                                                '${item.fxTime}',
                                                style: context.typo.caption
                                                    .copyWith(color: primaryTextColor),
                                              ),
                                              SvgPicture.asset(
                                                'imgs/weather/${item.icon}.svg',
                                                fit: BoxFit.cover,
                                                height: 35,
                                                width: 35,
                                                colorFilter: const ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.srcIn),
                                              ),
                                              Text(
                                                '${item.temp}℃',
                                                style: context.typo.body
                                                    .copyWith(color: primaryTextColor),
                                              ),
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  width: 450,
                  height: 480,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Card(
                          color: Colors.grey,
                          child: Container(
                            width: 450,
                            height: 480,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            spacing: 10,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '最近10天天气',
                                    style: context.typo.sectionTitle.copyWith(color: primaryTextColor),
                                  ),
                                ],
                              ),
                              const Divider(),
                              for (DayWeatherDaily item in weatherState.daily)
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      '${item.fxDate}',
                                      style: context.typo.caption.copyWith(color: primaryTextColor),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 50, right: 50),
                                      child: SvgPicture.asset(
                                        'imgs/weather/${item.iconDay}.svg',
                                        fit: BoxFit.cover,
                                        height: 30,
                                        width: 30,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                    Text(
                                      '${item.tempMin}℃',
                                      style: context.typo.body.copyWith(color: primaryTextColor),
                                    ),
                                    Expanded(
                                        child: CustomeProcess(
                                            weatherNotifier.getMinTemp(),
                                            weatherNotifier.getMaxTemp(),
                                            double.parse(item.tempMin),
                                            double.parse(item.tempMax),
                                            5)),
                                    Text(
                                      '${item.tempMax}℃',
                                      style: context.typo.body.copyWith(color: primaryTextColor),
                                    ),
                                  ],
                                )
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  width: 450,
                  height: 480,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Card(
                          color: Colors.grey,
                          child: Container(
                            width: 450,
                            height: 480,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '生活指数',
                                    style: context.typo.sectionTitle.copyWith(color: primaryTextColor),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Expanded(
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    // crossAxisSpacing: 3,
                                    childAspectRatio: 3,
                                  ),
                                  itemCount: weatherState.indicesDaily.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.ac_unit_outlined,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        '${weatherState.indicesDaily[index].name}',
                                        style: context.typo.bodyStrong.copyWith(color: primaryTextColor),
                                      ),
                                      subtitle: Text(
                                        '${weatherState.indicesDaily[index].category}',
                                        style: context.typo.caption.copyWith(color: primaryTextColor),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
