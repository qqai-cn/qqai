import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'qqai_weather_city_model.freezed.dart';
part 'qqai_weather_city_model.g.dart';

@freezed
sealed class QqaiWeatherCityResVO with _$QqaiWeatherCityResVO {
  const factory QqaiWeatherCityResVO({
    String? id,
    int? adCode,
    String? province,
    String? provincePinyin,
    String? city,
    String? cityPinyin,
    String? county,
    String? countyPinyin,
    double? lat,
    double? lon,
  }) = _QqaiWeatherCityResVO;

  factory QqaiWeatherCityResVO.fromJson(Map<String, Object?> json) =>
      _$QqaiWeatherCityResVOFromJson(json);
}
