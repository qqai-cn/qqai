import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/day_weather_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/day_weather_entity.g.dart';

@JsonSerializable()
class DayWeatherEntity {
	late String code;
	late String updateTime;
	late String fxLink;
	late List<DayWeatherDaily> daily;
	late DayWeatherRefer refer;

	DayWeatherEntity();

	factory DayWeatherEntity.fromJson(Map<String, dynamic> json) => $DayWeatherEntityFromJson(json);

	Map<String, dynamic> toJson() => $DayWeatherEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DayWeatherDaily {
	late String fxDate;
	late String sunrise;
	late String sunset;
	late String moonrise;
	late String moonset;
	late String moonPhase;
	late String moonPhaseIcon;
	late String tempMax;
	late String tempMin;
	late String iconDay;
	late String textDay;
	late String iconNight;
	late String textNight;
	late String wind360Day;
	late String windDirDay;
	late String windScaleDay;
	late String windSpeedDay;
	late String wind360Night;
	late String windDirNight;
	late String windScaleNight;
	late String windSpeedNight;
	late String humidity;
	late String precip;
	late String pressure;
	late String vis;
	late String cloud;
	late String uvIndex;

	DayWeatherDaily();

	factory DayWeatherDaily.fromJson(Map<String, dynamic> json) => $DayWeatherDailyFromJson(json);

	Map<String, dynamic> toJson() => $DayWeatherDailyToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DayWeatherRefer {
	late List<String> sources;
	late List<String> license;

	DayWeatherRefer();

	factory DayWeatherRefer.fromJson(Map<String, dynamic> json) => $DayWeatherReferFromJson(json);

	Map<String, dynamic> toJson() => $DayWeatherReferToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}