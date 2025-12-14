import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/custom_process_widget.dart';
import '../../../data/models/day_weather_entity.dart';
import '../../../data/models/hour_weather_entity.dart';
import '../providers/weather_providers.dart';


class PerDayWeatherView extends ConsumerWidget {
  const PerDayWeatherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weatherNotifier = ref.read(weatherProvider.notifier);
    
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
                            style: TextStyle(
                                fontSize: 20,
                                color: weatherState.ifOnHour
                                    ? Colors.red
                                    : Colors.white),
                          ),
                          Text(
                            '温度：${weatherNotifier.getCurRealTimeWeather().now.temp} ℃   |  体感温度：${weatherNotifier.getCurRealTimeWeather().now.feelsLike} ℃',
                            style: TextStyle(
                                fontSize: 20,
                                color: weatherState.ifOnHour
                                    ? Colors.red
                                    : Colors.white),
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
                                style: TextStyle(
                                    fontSize: 20,
                                    color: weatherState.ifOnHour
                                        ? Colors.red
                                        : Colors.white),
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
                                  style: TextStyle(
                                      color: weatherState.ifOnHour
                                          ? Colors.red
                                          : Colors.white),
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
                                    style: TextStyle(color: Colors.white),
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
                                                style: TextStyle(
                                                    color: weatherState.ifOnHour
                                                        ? Colors.red
                                                        : Colors.white),
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
                                                style: TextStyle(
                                                    color: weatherState.ifOnHour
                                                        ? Colors.red
                                                        : Colors.white),
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
                                    style: TextStyle(
                                        color: weatherState.ifOnHour
                                            ? Colors.red
                                            : Colors.white),
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
                                      style: TextStyle(
                                          color: weatherState.ifOnHour
                                              ? Colors.red
                                              : Colors.white),
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
                                      style: TextStyle(
                                          color: weatherState.ifOnHour
                                              ? Colors.red
                                              : Colors.white),
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
                                      style: TextStyle(
                                          color: weatherState.ifOnHour
                                              ? Colors.red
                                              : Colors.white),
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
                                    style: TextStyle(
                                        color: weatherState.ifOnHour
                                            ? Colors.red
                                            : Colors.white),
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
                                        style: TextStyle(
                                            color: weatherState.ifOnHour
                                                ? Colors.red
                                                : Colors.white),
                                      ),
                                      subtitle: Text(
                                        '${weatherState.indicesDaily[index].category}',
                                        style: TextStyle(
                                            color: weatherState.ifOnHour
                                                ? Colors.red
                                                : Colors.white),
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
