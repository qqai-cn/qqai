import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/city_menu_model_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/city_menu_model_entity.g.dart';

@JsonSerializable()
class CityMenuModelEntity {
	late String provinceName;
	late String provinceId;
	late String cityName;
	late String cityId;
	late String areaName;
	late String areaId;

	CityMenuModelEntity();

	factory CityMenuModelEntity.fromJson(Map<String, dynamic> json) => $CityMenuModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $CityMenuModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}