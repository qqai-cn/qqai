import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/weather_city_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/weather_city_entity.g.dart';

@JsonSerializable()
class WeatherCityEntity {
	late int code;
	late String message;
	late List<WeatherCityData> data;

	WeatherCityEntity();

	factory WeatherCityEntity.fromJson(Map<String, dynamic> json) => $WeatherCityEntityFromJson(json);

	Map<String, dynamic> toJson() => $WeatherCityEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class WeatherCityData {
	late String id;
	late int adCode;
	late String province;
	late String provincePinyin;
	late String city;
	late String cityPinyin;
	late String county;
	late String countyPinyin;
	late double lat;
	late double lon;

	WeatherCityData();

	factory WeatherCityData.fromJson(Map<String, dynamic> json) => $WeatherCityDataFromJson(json);

	Map<String, dynamic> toJson() => $WeatherCityDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}