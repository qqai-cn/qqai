import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/idCard_bean_entity.dart';

IdCardBeanEntity $IdCardBeanEntityFromJson(Map<String, dynamic> json) {
  final IdCardBeanEntity idCardBeanEntity = IdCardBeanEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    idCardBeanEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    idCardBeanEntity.message = message;
  }
  final IdCardBeanData? data = jsonConvert.convert<IdCardBeanData>(
      json['data']);
  if (data != null) {
    idCardBeanEntity.data = data;
  }
  return idCardBeanEntity;
}

Map<String, dynamic> $IdCardBeanEntityToJson(IdCardBeanEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension IdCardBeanEntityExtension on IdCardBeanEntity {
  IdCardBeanEntity copyWith({
    int? code,
    String? message,
    IdCardBeanData? data,
  }) {
    return IdCardBeanEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

IdCardBeanData $IdCardBeanDataFromJson(Map<String, dynamic> json) {
  final IdCardBeanData idCardBeanData = IdCardBeanData();
  final String? zoneCode = jsonConvert.convert<String>(json['zoneCode']);
  if (zoneCode != null) {
    idCardBeanData.zoneCode = zoneCode;
  }
  final bool? abandoned = jsonConvert.convert<bool>(json['abandoned']);
  if (abandoned != null) {
    idCardBeanData.abandoned = abandoned;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    idCardBeanData.address = address;
  }
  final List<String>? addressList = (json['addressList'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<String>(e) as String)
      .toList();
  if (addressList != null) {
    idCardBeanData.addressList = addressList;
  }
  final String? birthday = jsonConvert.convert<String>(json['birthday']);
  if (birthday != null) {
    idCardBeanData.birthday = birthday;
  }
  final int? age = jsonConvert.convert<int>(json['age']);
  if (age != null) {
    idCardBeanData.age = age;
  }
  final String? constellation = jsonConvert.convert<String>(
      json['constellation']);
  if (constellation != null) {
    idCardBeanData.constellation = constellation;
  }
  final String? chineseZodiac = jsonConvert.convert<String>(
      json['chineseZodiac']);
  if (chineseZodiac != null) {
    idCardBeanData.chineseZodiac = chineseZodiac;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    idCardBeanData.sex = sex;
  }
  final int? length = jsonConvert.convert<int>(json['length']);
  if (length != null) {
    idCardBeanData.length = length;
  }
  final String? checkBit = jsonConvert.convert<String>(json['checkBit']);
  if (checkBit != null) {
    idCardBeanData.checkBit = checkBit;
  }
  return idCardBeanData;
}

Map<String, dynamic> $IdCardBeanDataToJson(IdCardBeanData entity) {
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

extension IdCardBeanDataExtension on IdCardBeanData {
  IdCardBeanData copyWith({
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
    return IdCardBeanData()
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