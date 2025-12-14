import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/weather/presentation/views/weather_detail_view.dart';
import 'package:qqai/features/weather/presentation/views/weather_left_page.dart';

import '../../../../../config/translations/strings_enum.dart';
import '../../../../../constant/constant.dart';
import '../../../../components/api_error_widget.dart';
import '../../../../components/my_widgets_animator.dart';
import '../providers/weather_providers.dart';

class WeatherHomePage extends ConsumerWidget {
  const WeatherHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weatherNotifier = ref.read(weatherProvider.notifier);
    
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
                    controller: weatherState.textEditingController,
                    onTap: () async {
                      // type 2
                      Result? result2 =
                          await CityPickers.showFullPageCityPicker(
                        showType: ShowType.pcav,
                        context: context,
                      );
                      if (result2 != null) {
                        weatherNotifier.updateSelCity(result2);
                      }
                    },
                    // onChanged: (t) async {
                    //
                    // },
                  )),
              if (weatherState.textEditingController.text != '')
                const IconButton(
                  icon: Icon(Icons.add_circle_sharp),
                  onPressed: null,
                ),
              IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: () {
                  weatherNotifier.getRealTimeWeather();
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
                    apiCallStatus: weatherState.apiCallStatus,
                    loadingWidget: () => const Center(child: CupertinoActivityIndicator(),),
                    errorWidget: () => ApiErrorWidget(
                      message: Strings.internetError,
                      retryAction: () => weatherNotifier.getCityList(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                    ),
                    successWidget: () => const WeatherLeftPage())),
            if (1.sw > Constant.CHAT_TWO_VIEW_WIDTH)
              const Expanded(flex: 5, child: WeatherDetailView()),
          ],
        ),
      );
  }
}
