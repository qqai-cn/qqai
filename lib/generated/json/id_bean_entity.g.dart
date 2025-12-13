import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/id_bean_entity.dart';

IdBeanEntity $IdBeanEntityFromJson(Map<String, dynamic> json) {
  final IdBeanEntity idBeanEntity = IdBeanEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    idBeanEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    idBeanEntity.message = message;
  }
  final IdBeanData? data = jsonConvert.convert<IdBeanData>(json['data']);
  if (data != null) {
    idBeanEntity.data = data;
  }
  return idBeanEntity;
}

Map<String, dynamic> $IdBeanEntityToJson(IdBeanEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data.toJson();
  return data;
}

extension IdBeanEntityExtension on IdBeanEntity {
  IdBeanEntity copyWith({
    int? code,
    String? message,
    IdBeanData? data,
  }) {
    return IdBeanEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

IdBeanData $IdBeanDataFromJson(Map<String, dynamic> json) {
  final IdBeanData idBeanData = IdBeanData();
  final String? zoneCode = jsonConvert.convert<String>(json['zoneCode']);
  if (zoneCode != null) {
    idBeanData.zoneCode = zoneCode;
  }
  final bool? abandoned = jsonConvert.convert<bool>(json['abandoned']);
  if (abandoned != null) {
    idBeanData.abandoned = abandoned;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    idBeanData.address = address;
  }
  final List<String>? addressList = (json['addressList'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<String>(e) as String)
      .toList();
  if (addressList != null) {
    idBeanData.addressList = addressList;
  }
  final String? birthday = jsonConvert.convert<String>(json['birthday']);
  if (birthday != null) {
    idBeanData.birthday = birthday;
  }
  final int? age = jsonConvert.convert<int>(json['age']);
  if (age != null) {
    idBeanData.age = age;
  }
  final String? constellation = jsonConvert.convert<String>(
      json['constellation']);
  if (constellation != null) {
    idBeanData.constellation = constellation;
  }
  final String? chineseZodiac = jsonConvert.convert<String>(
      json['chineseZodiac']);
  if (chineseZodiac != null) {
    idBeanData.chineseZodiac = chineseZodiac;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    idBeanData.sex = sex;
  }
  final int? length = jsonConvert.convert<int>(json['length']);
  if (length != null) {
    idBeanData.length = length;
  }
  final String? checkBit = jsonConvert.convert<String>(json['checkBit']);
  if (checkBit != null) {
    idBeanData.checkBit = checkBit;
  }
  return idBeanData;
}

Map<String, dynamic> $IdBeanDataToJson(IdBeanData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['zoneCode'] = entity.zoneCode;
  data['abandoned'] = entity.abandoned;
  data['address'] = entity.address;
  data['addressList'] = entity.addressList;
  data['birthday'] = entity.birthday;
  data['age'] = entity.age;
  data['constellation'] = entity.constellation;
  data['chineseZodiac'] = entity.chineseZodiac;
  data['sex'] = entity.sex;
  data['length'] = entity.length;
  data['checkBit'] = entity.checkBit;
  return data;
}

extension IdBeanDataExtension on IdBeanData {
  IdBeanData copyWith({
    String? zoneCode,
    bool? abandoned,
    String? address,
    List<String>? addressList,
    String? birthday,
    int? age,
    String? constellation,
    String? chineseZodiac,
    int? sex,
    int? length,
    String? checkBit,
  }) {
    return IdBeanData()
      ..zoneCode = zoneCode ?? this.zoneCode
      ..abandoned = abandoned ?? this.abandoned
      ..address = address ?? this.address
      ..addressList = addressList ?? this.addressList
      ..birthday = birthday ?? this.birthday
      ..age = age ?? this.age
      ..constellation = constellation ?? this.constellation
      ..chineseZodiac = chineseZodiac ?? this.chineseZodiac
      ..sex = sex ?? this.sex
      ..length = length ?? this.length
      ..checkBit = checkBit ?? this.checkBit;
  }
}