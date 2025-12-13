import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/indices_weather_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/indices_weather_entity.g.dart';

@JsonSerializable()
class IndicesWeatherEntity {
	late String code;
	late String updateTime;
	late String fxLink;
	late List<IndicesWeatherDaily> daily;
	late IndicesWeatherRefer refer;

	IndicesWeatherEntity();

	factory IndicesWeatherEntity.fromJson(Map<String, dynamic> json) => $IndicesWeatherEntityFromJson(json);

	Map<String, dynamic> toJson() => $IndicesWeatherEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class IndicesWeatherDaily {
	late String date;
	late String type;
	late String name;
	late String level;
	late String category;
	late String text;

	IndicesWeatherDaily();

	factory IndicesWeatherDaily.fromJson(Map<String, dynamic> json) => $IndicesWeatherDailyFromJson(json);

	Map<String, dynamic> toJson() => $IndicesWeatherDailyToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class IndicesWeatherRefer {
	late List<String> sources;
	late List<String> license;

	IndicesWeatherRefer();

	factory IndicesWeatherRefer.fromJson(Map<String, dynamic> json) => $IndicesWeatherReferFromJson(json);

	Map<String, dynamic> toJson() => $IndicesWeatherReferToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}