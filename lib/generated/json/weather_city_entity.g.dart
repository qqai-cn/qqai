import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/weather_city_entity.dart';

WeatherCityEntity $WeatherCityEntityFromJson(Map<String, dynamic> json) {
  final WeatherCityEntity weatherCityEntity = WeatherCityEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    weatherCityEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    weatherCityEntity.message = message;
  }
  final List<WeatherCityData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<WeatherCityData>(e) as WeatherCityData)
      .toList();
  if (data != null) {
    weatherCityEntity.data = data;
  }
  return weatherCityEntity;
}

Map<String, dynamic> $WeatherCityEntityToJson(WeatherCityEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data.map((v) => v.toJson()).toList();
  return data;
}

extension WeatherCityEntityExtension on WeatherCityEntity {
  WeatherCityEntity copyWith({
    int? code,
    String? message,
    List<WeatherCityData>? data,
  }) {
    return WeatherCityEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

WeatherCityData $WeatherCityDataFromJson(Map<String, dynamic> json) {
  final WeatherCityData weatherCityData = WeatherCityData();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    weatherCityData.id = id;
  }
  final int? adCode = jsonConvert.convert<int>(json['adCode']);
  if (adCode != null) {
    weatherCityData.adCode = adCode;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    weatherCityData.province = province;
  }
  final String? provincePinyin = jsonConvert.convert<String>(
      json['provincePinyin']);
  if (provincePinyin != null) {
    weatherCityData.provincePinyin = provincePinyin;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    weatherCityData.city = city;
  }
  final String? cityPinyin = jsonConvert.convert<String>(json['cityPinyin']);
  if (cityPinyin != null) {
    weatherCityData.cityPinyin = cityPinyin;
  }
  final String? county = jsonConvert.convert<String>(json['county']);
  if (county != null) {
    weatherCityData.county = county;
  }
  final String? countyPinyin = jsonConvert.convert<String>(
      json['countyPinyin']);
  if (countyPinyin != null) {
    weatherCityData.countyPinyin = countyPinyin;
  }
  final double? lat = jsonConvert.convert<double>(json['lat']);
  if (lat != null) {
    weatherCityData.lat = lat;
  }
  final double? lon = jsonConvert.convert<double>(json['lon']);
  if (lon != null) {
    weatherCityData.lon = lon;
  }
  return weatherCityData;
}

Map<String, dynamic> $WeatherCityDataToJson(WeatherCityData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['adCode'] = entity.adCode;
  data['province'] = entity.province;
  data['provincePinyin'] = entity.provincePinyin;
  data['city'] = entity.city;
  data['cityPinyin'] = entity.cityPinyin;
  data['county'] = entity.county;
  data['countyPinyin'] = entity.countyPinyin;
  data['lat'] = entity.lat;
  data['lon'] = entity.lon;
  return data;
}

extension WeatherCityDataExtension on WeatherCityData {
  WeatherCityData copyWith({
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
  }) {
    return WeatherCityData()
      ..id = id ?? this.id
      ..adCode = adCode ?? this.adCode
      ..province = province ?? this.province
      ..provincePinyin = provincePinyin ?? this.provincePinyin
      ..city = city ?? this.city
      ..cityPinyin = cityPinyin ?? this.cityPinyin
      ..county = county ?? this.county
      ..countyPinyin = countyPinyin ?? this.countyPinyin
      ..lat = lat ?? this.lat
      ..lon = lon ?? this.lon;
  }
}