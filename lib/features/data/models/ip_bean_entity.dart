import 'dart:convert';

import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/ip_bean_entity.g.dart';

export 'package:qqai/generated/json/ip_bean_entity.g.dart';

@JsonSerializable()
class IpBeanEntity {
	int? code;
	String? message;
	IpBeanData? data;

	IpBeanEntity();

	factory IpBeanEntity.fromJson(Map<String, dynamic> json) => $IpBeanEntityFromJson(json);

	Map<String, dynamic> toJson() => $IpBeanEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class IpBeanData {
	String? ip;
	String? country;
	dynamic region;
	String? province;
	String? city;
	String? isp;

	IpBeanData();

	factory IpBeanData.fromJson(Map<String, dynamic> json) => $IpBeanDataFromJson(json);

	Map<String, dynamic> toJson() => $IpBeanDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}