import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/real_time_weather_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/real_time_weather_entity.g.dart';

@JsonSerializable()
class RealTimeWeatherEntity {
	late String code;
	late String updateTime;
	late String fxLink;
	late RealTimeWeatherNow now;
	late RealTimeWeatherRefer refer;

	RealTimeWeatherEntity();

	factory RealTimeWeatherEntity.fromJson(Map<String, dynamic> json) => $RealTimeWeatherEntityFromJson(json);

	Map<String, dynamic> toJson() => $RealTimeWeatherEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RealTimeWeatherNow {
	late String obsTime;
	late String temp;
	late String feelsLike;
	late String icon;
	late String text;
	late WeatherType weatherType;
	late String wind360;
	late String windDir;
	late String windScale;
	late String windSpeed;
	late String humidity;
	late String precip;
	late String pressure;
	late String vis;
	late String cloud;
	late String dew;

	RealTimeWeatherNow();

	factory RealTimeWeatherNow.fromJson(Map<String, dynamic> json) => $RealTimeWeatherNowFromJson(json);

	Map<String, dynamic> toJson() => $RealTimeWeatherNowToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RealTimeWeatherRefer {
	late List<String> sources;
	late List<String> license;

	RealTimeWeatherRefer();

	factory RealTimeWeatherRefer.fromJson(Map<String, dynamic> json) => $RealTimeWeatherReferFromJson(json);

	Map<String, dynamic> toJson() => $RealTimeWeatherReferToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}