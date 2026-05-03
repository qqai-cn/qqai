// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qqai_weather_city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QqaiWeatherCityResVO _$QqaiWeatherCityResVOFromJson(
  Map<String, dynamic> json,
) => _QqaiWeatherCityResVO(
  id: json['id'] as String?,
  adCode: (json['adCode'] as num?)?.toInt(),
  province: json['province'] as String?,
  provincePinyin: json['provincePinyin'] as String?,
  city: json['city'] as String?,
  cityPinyin: json['cityPinyin'] as String?,
  county: json['county'] as String?,
  countyPinyin: json['countyPinyin'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lon: (json['lon'] as num?)?.toDouble(),
);

Map<String, dynamic> _$QqaiWeatherCityResVOToJson(
  _QqaiWeatherCityResVO instance,
) => <String, dynamic>{
  'id': instance.id,
  'adCode': instance.adCode,
  'province': instance.province,
  'provincePinyin': instance.provincePinyin,
  'city': instance.city,
  'cityPinyin': instance.cityPinyin,
  'county': instance.county,
  'countyPinyin': instance.countyPinyin,
  'lat': instance.lat,
  'lon': instance.lon,
};
