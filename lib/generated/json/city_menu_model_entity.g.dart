import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/city_menu_model_entity.dart';

CityMenuModelEntity $CityMenuModelEntityFromJson(Map<String, dynamic> json) {
  final CityMenuModelEntity cityMenuModelEntity = CityMenuModelEntity();
  final String? provinceName = jsonConvert.convert<String>(
      json['provinceName']);
  if (provinceName != null) {
    cityMenuModelEntity.provinceName = provinceName;
  }
  final String? provinceId = jsonConvert.convert<String>(json['provinceId']);
  if (provinceId != null) {
    cityMenuModelEntity.provinceId = provinceId;
  }
  final String? cityName = jsonConvert.convert<String>(json['cityName']);
  if (cityName != null) {
    cityMenuModelEntity.cityName = cityName;
  }
  final String? cityId = jsonConvert.convert<String>(json['cityId']);
  if (cityId != null) {
    cityMenuModelEntity.cityId = cityId;
  }
  final String? areaName = jsonConvert.convert<String>(json['areaName']);
  if (areaName != null) {
    cityMenuModelEntity.areaName = areaName;
  }
  final String? areaId = jsonConvert.convert<String>(json['areaId']);
  if (areaId != null) {
    cityMenuModelEntity.areaId = areaId;
  }
  return cityMenuModelEntity;
}

Map<String, dynamic> $CityMenuModelEntityToJson(CityMenuModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['provinceName'] = entity.provinceName;
  data['provinceId'] = entity.provinceId;
  data['cityName'] = entity.cityName;
  data['cityId'] = entity.cityId;
  data['areaName'] = entity.areaName;
  data['areaId'] = entity.areaId;
  return data;
}

extension CityMenuModelEntityExtension on CityMenuModelEntity {
  CityMenuModelEntity copyWith({
    String? provinceName,
    String? provinceId,
    String? cityName,
    String? cityId,
    String? areaName,
    String? areaId,
  }) {
    return CityMenuModelEntity()
      ..provinceName = provinceName ?? this.provinceName
      ..provinceId = provinceId ?? this.provinceId
      ..cityName = cityName ?? this.cityName
      ..cityId = cityId ?? this.cityId
      ..areaName = areaName ?? this.areaName
      ..areaId = areaId ?? this.areaId;
  }
}