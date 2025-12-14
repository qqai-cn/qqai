import 'package:qqai/generated/json/base/json_convert_content.dart';
import '../../../features/data/models/ip_bean_entity.dart';

IpBeanEntity $IpBeanEntityFromJson(Map<String, dynamic> json) {
  final IpBeanEntity ipBeanEntity = IpBeanEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    ipBeanEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    ipBeanEntity.message = message;
  }
  final IpBeanData? data = jsonConvert.convert<IpBeanData>(json['data']);
  if (data != null) {
    ipBeanEntity.data = data;
  }
  return ipBeanEntity;
}

Map<String, dynamic> $IpBeanEntityToJson(IpBeanEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension IpBeanEntityExtension on IpBeanEntity {
  IpBeanEntity copyWith({
    int? code,
    String? message,
    IpBeanData? data,
  }) {
    return IpBeanEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

IpBeanData $IpBeanDataFromJson(Map<String, dynamic> json) {
  final IpBeanData ipBeanData = IpBeanData();
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    ipBeanData.ip = ip;
  }
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    ipBeanData.country = country;
  }
  final dynamic region = json['region'];
  if (region != null) {
    ipBeanData.region = region;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    ipBeanData.province = province;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    ipBeanData.city = city;
  }
  final String? isp = jsonConvert.convert<String>(json['isp']);
  if (isp != null) {
    ipBeanData.isp = isp;
  }
  return ipBeanData;
}

Map<String, dynamic> $IpBeanDataToJson(IpBeanData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['ip'] = entity.ip;
  data['country'] = entity.country;
  data['region'] = entity.region;
  data['province'] = entity.province;
  data['city'] = entity.city;
  data['isp'] = entity.isp;
  return data;
}

extension IpBeanDataExtension on IpBeanData {
  IpBeanData copyWith({
    String? ip,
    String? country,
    dynamic region,
    String? province,
    String? city,
    String? isp,
  }) {
    return IpBeanData()
      ..ip = ip ?? this.ip
      ..country = country ?? this.country
      ..region = region ?? this.region
      ..province = province ?? this.province
      ..city = city ?? this.city
      ..isp = isp ?? this.isp;
  }
}