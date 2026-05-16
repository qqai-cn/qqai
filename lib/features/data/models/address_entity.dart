import 'dart:convert';

import 'package:qqai/generated/json/address_entity.g.dart';
import 'package:qqai/generated/json/base/json_field.dart';
import '../../fabu/data/models/qqai_weather_city_model.dart';

export 'package:qqai/generated/json/address_entity.g.dart';

@JsonSerializable()
class AddressEntity {
	late int id;
	late String name;
	late String distance;
	late String detail;
	double? latitude;
	double? longitude;

	AddressEntity();

	/// 是否已选具体位置（非「不显示位置」）且含经纬度。
	bool get hasGeoCoordinates =>
	    id != 0 && latitude != null && longitude != null;

	factory AddressEntity.fromJson(Map<String, dynamic> json) => $AddressEntityFromJson(json);

	Map<String, dynamic> toJson() => $AddressEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}

	// Convert QqaiWeatherCityResVO to AddressEntity
  factory AddressEntity.fromWeatherCity(
    QqaiWeatherCityResVO weatherCity, {
    double? latitude,
    double? longitude,
  }) {
		final address = AddressEntity();
		address.id = weatherCity.adCode ?? 0;
		address.name = '${weatherCity.city ?? ''}${weatherCity.county ?? ''}';
		address.distance = '';
		address.detail = '${weatherCity.province ?? ''} ${weatherCity.city ?? ''} ${weatherCity.county ?? ''}';
		address.latitude = latitude ?? weatherCity.lat;
		address.longitude = longitude ?? weatherCity.lon;
		return address;
	}
  factory AddressEntity.fromWeatherCityOnly(
    QqaiWeatherCityResVO weatherCity, {
    double? latitude,
    double? longitude,
  }) {
		final address = AddressEntity();
		address.id = weatherCity.adCode ?? 0;
		address.name = '${weatherCity.city}';
		address.distance = '';
		address.detail = '${weatherCity.province ?? ''} ${weatherCity.city ?? ''} ${weatherCity.county ?? ''}';
		address.latitude = latitude ?? weatherCity.lat;
		address.longitude = longitude ?? weatherCity.lon;
		return address;
	}
}