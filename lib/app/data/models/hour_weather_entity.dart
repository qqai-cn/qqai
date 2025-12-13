import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/hour_weather_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/hour_weather_entity.g.dart';

@JsonSerializable()
class HourWeatherEntity {
	late String code;
	late String updateTime;
	late String fxLink;
	late List<HourWeatherHourly> hourly;
	late HourWeatherRefer refer;

	HourWeatherEntity();

	factory HourWeatherEntity.fromJson(Map<String, dynamic> json) => $HourWeatherEntityFromJson(json);

	Map<String, dynamic> toJson() => $HourWeatherEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HourWeatherHourly {
	late String fxTime;
	late String temp;
	late String icon;
	late String text;
	late String wind360;
	late String windDir;
	late String windScale;
	late String windSpeed;
	late String humidity;
	late String pop;
	late String precip;
	late String pressure;
	late String cloud;
	late String dew;

	HourWeatherHourly();

	factory HourWeatherHourly.fromJson(Map<String, dynamic> json) => $HourWeatherHourlyFromJson(json);

	Map<String, dynamic> toJson() => $HourWeatherHourlyToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HourWeatherRefer {
	late List<String> sources;
	late List<String> license;

	HourWeatherRefer();

	factory HourWeatherRefer.fromJson(Map<String, dynamic> json) => $HourWeatherReferFromJson(json);

	Map<String, dynamic> toJson() => $HourWeatherReferToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}