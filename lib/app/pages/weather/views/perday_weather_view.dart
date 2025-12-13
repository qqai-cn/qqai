import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/weather/controllers/weather_controller.dart';

import '../../../components/custom_process_widget.dart';
import '../../../data/models/day_weather_entity.dart';
import '../../../data/models/hour_weather_entity.dart';

class PerDayWeatherView extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherController>(builder: (a) {
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
                            '${controller.getCurWeatherCityData().province}|${controller.getCurWeatherCityData().county}',
                            style: TextStyle(
                                fontSize: 20,
                                color: controller.ifOnHour
                                    ? Colors.red
                                    : Colors.white),
                          ),
                          Text(
                            '温度：${controller.getCurRealTimeWeather().now.temp} ℃   |  体感温度：${controller.getCurRealTimeWeather().now.feelsLike} ℃',
                            style: TextStyle(
                                fontSize: 20,
                                color: controller.ifOnHour
                                    ? Colors.red
                                    : Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'imgs/weather/${controller.getCurRealTimeWeather().now.icon}.svg',
                                fit: BoxFit.cover,
                                height: 20,
                                width: 20,
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${controller.getCurRealTimeWeather().now.text}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: controller.ifOnHour
                                        ? Colors.red
                                        : Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 20,
                              children:
                                  controller.getCurCard1().entries.map((entry) {
                                return Text(
                                  '${entry.key} \n ${entry.value}',
                                  style: TextStyle(
                                      color: controller.ifOnHour
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
                                    // controller: controller.hourController,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (HourWeatherHourly item
                                          in controller.hourly)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: Column(
                                            spacing: 10,
                                            children: [
                                              Text(
                                                '${item.fxTime}',
                                                style: TextStyle(
                                                    color: controller.ifOnHour
                                                        ? Colors.red
                                                        : Colors.white),
                                              ),
                                              SvgPicture.asset(
                                                'imgs/weather/${item.icon}.svg',
                                                fit: BoxFit.cover,
                                                height: 35,
                                                width: 35,
                                                colorFilter: ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.srcIn),
                                              ),
                                              Text(
                                                '${item.temp}℃',
                                                style: TextStyle(
                                                    color: controller.ifOnHour
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
                                        color: controller.ifOnHour
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ],
                              ),
                              Divider(),
                              for (DayWeatherDaily item in controller.daily)
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      '${item.fxDate}',
                                      style: TextStyle(
                                          color: controller.ifOnHour
                                              ? Colors.red
                                              : Colors.white),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 50, right: 50),
                                      child: SvgPicture.asset(
                                        'imgs/weather/${item.iconDay}.svg',
                                        fit: BoxFit.cover,
                                        height: 30,
                                        width: 30,
                                        colorFilter: ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                    Text(
                                      '${item.tempMin}℃',
                                      style: TextStyle(
                                          color: controller.ifOnHour
                                              ? Colors.red
                                              : Colors.white),
                                    ),
                                    Expanded(
                                        child: CustomeProcess(
                                            controller.getMinTemp(),
                                            controller.getMaxTemp(),
                                            double.parse(item.tempMin),
                                            double.parse(item.tempMax),
                                            5)),
                                    Text(
                                      '${item.tempMax}℃',
                                      style: TextStyle(
                                          color: controller.ifOnHour
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
                                        color: controller.ifOnHour
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ],
                              ),
                              Divider(),
                              Expanded(
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    // crossAxisSpacing: 3,
                                    childAspectRatio: 3,
                                  ),
                                  itemCount: controller.indicesDaily.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: Icon(
                                        Icons.ac_unit_outlined,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        '${controller.indicesDaily[index].name}',
                                        style: TextStyle(
                                            color: controller.ifOnHour
                                                ? Colors.red
                                                : Colors.white),
                                      ),
                                      subtitle: Text(
                                        '${controller.indicesDaily[index].category}',
                                        style: TextStyle(
                                            color: controller.ifOnHour
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
    });
  }
}
