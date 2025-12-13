import 'dart:convert';

import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/id_bean_entity.g.dart';

export 'package:qqai/generated/json/id_bean_entity.g.dart';

@JsonSerializable()
class IdBeanEntity {
	late int code;
	late String message;
	late IdBeanData data;

	IdBeanEntity();

	factory IdBeanEntity.fromJson(Map<String, dynamic> json) => $IdBeanEntityFromJson(json);

	Map<String, dynamic> toJson() => $IdBeanEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class IdBeanData {
	late String zoneCode;
	late bool abandoned;
	late String address;
	late List<String> addressList;
	late String birthday;
	late int age;
	late String constellation;
	late String chineseZodiac;
	late int sex;
	late int length;
	late String checkBit;

	IdBeanData();

	factory IdBeanData.fromJson(Map<String, dynamic> json) => $IdBeanDataFromJson(json);

	Map<String, dynamic> toJson() => $IdBeanDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}