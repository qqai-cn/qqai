import 'package:qqai/generated/json/base/json_convert_content.dart';
import '../../../features/data/models/huati_entity.dart';

HuatiEntity $HuatiEntityFromJson(Map<String, dynamic> json) {
  final HuatiEntity huatiEntity = HuatiEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    huatiEntity.code = code;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    huatiEntity.name = name;
  }
  return huatiEntity;
}

Map<String, dynamic> $HuatiEntityToJson(HuatiEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['name'] = entity.name;
  return data;
}

extension HuatiEntityExtension on HuatiEntity {
  HuatiEntity copyWith({
    int? code,
    String? name,
  }) {
    return HuatiEntity()
      ..code = code ?? this.code
      ..name = name ?? this.name;
  }
}