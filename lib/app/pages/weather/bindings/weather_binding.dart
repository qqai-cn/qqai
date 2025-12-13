import 'package:get/get.dart';
import 'package:qqai/app/pages/index/controllers/home_controller.dart';
import 'package:qqai/app/pages/weather/controllers/weather_controller.dart';

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeatherController(),fenix: true);
  }
}
