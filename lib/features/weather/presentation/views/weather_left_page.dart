import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../router/app_routes.dart';
import '../../../../constant/constant.dart';
import '../../../data/models/day_weather_entity.dart';
import '../../../data/models/real_time_weather_entity.dart';
import '../../../data/models/weather_city_entity.dart';
import '../providers/weather_providers.dart';

class WeatherLeftPage extends ConsumerWidget {
  const WeatherLeftPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weatherNotifier = ref.read(weatherProvider.notifier);

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: weatherState.leftWeathers.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= weatherState.weatherCitys.length) {
          return const SizedBox.shrink();
        }

        final todayDaily = index < weatherState.leftTodayDaily.length
            ? weatherState.leftTodayDaily[index]
            : DayWeatherDaily();

        return InkWell(
          onTap: () async {
            await weatherNotifier.changeIndexLeft(index);
            if (!context.mounted) return;
            if (1.sw <= Constant.CHAT_TWO_VIEW_WIDTH) {
              context.push(Routes.weatherRightPageUrl);
            }
          },
          child: ListItemWidget(
            weatherType: weatherState.leftWeathers[index].now.weatherType,
            city: weatherState.weatherCitys[index],
            now: weatherState.leftWeathers[index].now,
            tempMax: todayDaily.tempMax,
            tempMin: todayDaily.tempMin,
            selected: weatherState.currentPage == index,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 4);
      },
    );
  }
}

class ListItemWidget extends StatelessWidget {
  static const _cardHeight = 120.0;

  final WeatherType weatherType;
  final WeatherCityData city;
  final RealTimeWeatherNow now;
  final String tempMax;
  final String tempMin;
  final bool selected;

  const ListItemWidget({
    super.key,
    required this.weatherType,
    required this.city,
    required this.now,
    required this.tempMax,
    required this.tempMin,
    required this.selected,
  });

  String get _locationName => '${city.province}${city.county}';

  String get _obsTimeLabel {
    if (now.obsTime.isEmpty) return '';
    try {
      return DateFormat('HH:mm').format(DateTime.parse(now.obsTime).toLocal());
    } catch (_) {
      return '';
    }
  }

  bool get _hasDailyRange => tempMax.isNotEmpty && tempMin.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.typo.pageTitle.copyWith(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
    final metaStyle = context.typo.caption.copyWith(
      color: Colors.white.withValues(alpha: 0.85),
      fontSize: 13,
    );
    final tempStyle = context.typo.pageTitle.copyWith(
      color: Colors.white,
      fontSize: 42,
      fontWeight: FontWeight.w300,
      height: 1,
    );
    final conditionStyle = context.typo.body.copyWith(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return Card(
      elevation: selected ? 6 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: selected
            ? BorderSide(color: Colors.white.withValues(alpha: 0.6), width: 1.5)
            : BorderSide.none,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: _cardHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            WeatherBg(
              weatherType: weatherType,
              width: MediaQuery.sizeOf(context).width,
              height: _cardHeight,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected ? '👉 $_locationName' : _locationName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle,
                            ),
                            if (_obsTimeLabel.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(_obsTimeLabel, style: metaStyle),
                            ],
                          ],
                        ),
                      ),
                      Text('${now.temp}°', style: tempStyle),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(now.text, style: conditionStyle),
                      if (_hasDailyRange)
                        Text(
                          '最高$tempMax° 最低$tempMin°',
                          style: metaStyle.copyWith(fontSize: 14),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
