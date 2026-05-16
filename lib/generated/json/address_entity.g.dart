import 'package:qqai/generated/json/base/json_convert_content.dart';
import '../../../features/data/models/address_entity.dart';

AddressEntity $AddressEntityFromJson(Map<String, dynamic> json) {
  final AddressEntity addressEntity = AddressEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    addressEntity.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    addressEntity.name = name;
  }
  final String? distance = jsonConvert.convert<String>(json['distance']);
  if (distance != null) {
    addressEntity.distance = distance;
  }
  final String? detail = jsonConvert.convert<String>(json['detail']);
  if (detail != null) {
    addressEntity.detail = detail;
  }
  final double? latitude = jsonConvert.convert<double>(json['latitude']);
  if (latitude != null) {
    addressEntity.latitude = latitude;
  }
  final double? longitude = jsonConvert.convert<double>(json['longitude']);
  if (longitude != null) {
    addressEntity.longitude = longitude;
  }
  return addressEntity;
}

Map<String, dynamic> $AddressEntityToJson(AddressEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['distance'] = entity.distance;
  data['detail'] = entity.detail;
  data['latitude'] = entity.latitude;
  data['longitude'] = entity.longitude;
  return data;
}

extension AddressEntityExtension on AddressEntity {
  AddressEntity copyWith({
    int? id,
    String? name,
    String? distance,
    String? detail,
    double? latitude,
    double? longitude,
  }) {
    return AddressEntity()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..distance = distance ?? this.distance
      ..detail = detail ?? this.detail
      ..latitude = latitude ?? this.latitude
      ..longitude = longitude ?? this.longitude;
  }
}