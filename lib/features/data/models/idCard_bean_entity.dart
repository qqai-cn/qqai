import 'dart:convert';

import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/idCard_bean_entity.g.dart';

export 'package:qqai/generated/json/idCard_bean_entity.g.dart';

@JsonSerializable()
class IdCardBeanEntity {
	int? code;
	String? message;
	IdCardBeanData? data;

	IdCardBeanEntity();

	factory IdCardBeanEntity.fromJson(Map<String, dynamic> json) => $IdCardBeanEntityFromJson(json);

	Map<String, dynamic> toJson() => $IdCardBeanEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class IdCardBeanData {
	String? zoneCode;
	bool? abandoned;
	String? address;
	List<String>? addressList;
	String? birthday;
	int? age;
	String? constellation;
	String? chineseZodiac;
	int? sex;
	int? length;
	String? checkBit;

	IdCardBeanData();

	factory IdCardBeanData.fromJson(Map<String, dynamic> json) => $IdCardBeanDataFromJson(json);

	Map<String, dynamic> toJson() => $IdCardBeanDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}