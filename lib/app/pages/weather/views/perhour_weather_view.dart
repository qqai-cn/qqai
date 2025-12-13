import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/weather/controllers/weather_controller.dart';

class PerHourWeatherView extends GetView<WeatherController> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherController>(builder: (a) {
      return Center(
          child: Card(child:
            Row(
              children: [
                Column(
                  children: [
                    Text('1'),
                    Text('1'),
                  ],
                )
              ],
            ),));
    });
  }

}