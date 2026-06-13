import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/custom_process_widget.dart';
import '../../../data/models/day_weather_entity.dart';
import '../../../data/models/hour_weather_entity.dart';
import '../providers/weather_providers.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 天气详情卡片宽度：宽屏右栏两列排布，窄屏尽量占满。
double _weatherCardWidth(double panelWidth) {
  if (panelWidth <= 0) return 450;
  if (panelWidth > 700) {
    return ((panelWidth - 10) / 2).clamp(380.0, 520.0);
  }
  return panelWidth.clamp(300.0, 450.0);
}

class PerDayWeatherView extends ConsumerWidget {
  const PerDayWeatherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weatherNotifier = ref.read(weatherProvider.notifier);
    final Color primaryTextColor =
        weatherState.ifOnHour ? Colors.red : Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = _weatherCardWidth(constraints.maxWidth);

        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildOverviewCard(
                    context,
                    cardWidth: cardWidth,
                    primaryTextColor: primaryTextColor,
                    weatherNotifier: weatherNotifier,
                  ),
                  _buildHourlyCard(
                    context,
                    cardWidth: cardWidth,
                    primaryTextColor: primaryTextColor,
                    weatherState: weatherState,
                  ),
                  _buildDailyCard(
                    context,
                    cardWidth: cardWidth,
                    primaryTextColor: primaryTextColor,
                    weatherState: weatherState,
                    weatherNotifier: weatherNotifier,
                  ),
                  _buildIndicesCard(
                    context,
                    cardWidth: cardWidth,
                    primaryTextColor: primaryTextColor,
                    weatherState: weatherState,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required double cardWidth,
    required Color primaryTextColor,
    required WeatherNotifier weatherNotifier,
  }) {
    final metrics = weatherNotifier.getCurCard1().entries.toList();
    final metricColumns = cardWidth >= 400 ? 3 : 2;
    const horizontalPadding = 24.0;
    const spacing = 10.0;
    final metricItemWidth = (cardWidth -
            horizontalPadding -
            spacing * (metricColumns - 1)) /
        metricColumns;

    return SizedBox(
      width: cardWidth,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Card(
                color: Colors.grey,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${weatherNotifier.getCurWeatherCityData().province}|${weatherNotifier.getCurWeatherCityData().county}',
                  style: context.typo.pageTitle.copyWith(color: primaryTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '温度：${weatherNotifier.getCurRealTimeWeather().now.temp} ℃   |  体感温度：${weatherNotifier.getCurRealTimeWeather().now.feelsLike} ℃',
                  style: context.typo.body.copyWith(color: primaryTextColor),
                  textAlign: TextAlign.center,
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
                    const SizedBox(width: 5),
                    Text(
                      weatherNotifier.getCurRealTimeWeather().now.text,
                      style: context.typo.sectionTitle
                          .copyWith(color: primaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: spacing,
                  runSpacing: 6,
                  children: metrics
                      .map(
                        (entry) => SizedBox(
                          width: metricItemWidth,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                entry.key,
                                style: context.typo.caption
                                    .copyWith(color: primaryTextColor),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                entry.value,
                                style: context.typo.body
                                    .copyWith(color: primaryTextColor),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyCard(
    BuildContext context, {
    required double cardWidth,
    required Color primaryTextColor,
    required WeatherState weatherState,
  }) {
    return SizedBox(
      width: cardWidth,
      height: 160,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Card(
                color: Colors.grey,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
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
                const Divider(),
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
                        for (HourWeatherHourly item in weatherState.hourly)
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Column(
                              spacing: 10,
                              children: [
                                Text(
                                  item.fxTime,
                                  style: context.typo.caption
                                      .copyWith(color: primaryTextColor),
                                ),
                                SvgPicture.asset(
                                  'imgs/weather/${item.icon}.svg',
                                  fit: BoxFit.cover,
                                  height: 35,
                                  width: 35,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCard(
    BuildContext context, {
    required double cardWidth,
    required Color primaryTextColor,
    required WeatherState weatherState,
    required WeatherNotifier weatherNotifier,
  }) {
    return SizedBox(
      width: cardWidth,
      height: 480,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Card(
                color: Colors.grey,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  children: [
                    Text(
                      '最近10天天气',
                      style: context.typo.sectionTitle
                          .copyWith(color: primaryTextColor),
                    ),
                  ],
                ),
                const Divider(),
                for (DayWeatherDaily item in weatherState.daily)
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        item.fxDate,
                        style: context.typo.caption
                            .copyWith(color: primaryTextColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
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
                          5,
                        ),
                      ),
                      Text(
                        '${item.tempMax}℃',
                        style: context.typo.body.copyWith(color: primaryTextColor),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicesCard(
    BuildContext context, {
    required double cardWidth,
    required Color primaryTextColor,
    required WeatherState weatherState,
  }) {
    return SizedBox(
      width: cardWidth,
      height: 480,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Card(
                color: Colors.grey,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '生活指数',
                      style: context.typo.sectionTitle
                          .copyWith(color: primaryTextColor),
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
                      childAspectRatio: 3,
                    ),
                    itemCount: weatherState.indicesDaily.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.ac_unit_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          weatherState.indicesDaily[index].name,
                          style: context.typo.bodyStrong
                              .copyWith(color: primaryTextColor),
                        ),
                        subtitle: Text(
                          weatherState.indicesDaily[index].category,
                          style: context.typo.caption
                              .copyWith(color: primaryTextColor),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
