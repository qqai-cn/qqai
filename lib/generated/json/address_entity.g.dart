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
  return addressEntity;
}

Map<String, dynamic> $AddressEntityToJson(AddressEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['distance'] = entity.distance;
  data['detail'] = entity.detail;
  return data;
}

extension AddressEntityExtension on AddressEntity {
  AddressEntity copyWith({
    int? id,
    String? name,
    String? distance,
    String? detail,
  }) {
    return AddressEntity()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..distance = distance ?? this.distance
      ..detail = detail ?? this.detail;
  }
}