import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/city_model_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/city_model_entity.g.dart';

@JsonSerializable()
class CityModelEntity {
	late String code;
	late List<CityModelLocation> data;
	late CityModelRefer refer;

	CityModelEntity();

	factory CityModelEntity.fromJson(Map<String, dynamic> json) => $CityModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $CityModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CityModelLocation {
	late String name;
	late String id;
	late String lat;
	late String lon;
	late String adm2;
	late String adm1;
	late String country;
	late String tz;
	late String utcOffset;
	late String isDst;
	late String type;
	late String rank;
	late String fxLink;

	CityModelLocation();

	factory CityModelLocation.fromJson(Map<String, dynamic> json) => $CityModelLocationFromJson(json);

	Map<String, dynamic> toJson() => $CityModelLocationToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CityModelRefer {
	late List<String> sources;
	late List<String> license;

	CityModelRefer();

	factory CityModelRefer.fromJson(Map<String, dynamic> json) => $CityModelReferFromJson(json);

	Map<String, dynamic> toJson() => $CityModelReferToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}