import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/city_model_entity.dart';

CityModelEntity $CityModelEntityFromJson(Map<String, dynamic> json) {
  final CityModelEntity cityModelEntity = CityModelEntity();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    cityModelEntity.code = code;
  }
  final List<CityModelLocation>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<CityModelLocation>(e) as CityModelLocation)
      .toList();
  if (data != null) {
    cityModelEntity.data = data;
  }
  final CityModelRefer? refer = jsonConvert.convert<CityModelRefer>(
      json['refer']);
  if (refer != null) {
    cityModelEntity.refer = refer;
  }
  return cityModelEntity;
}

Map<String, dynamic> $CityModelEntityToJson(CityModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['data'] = entity.data.map((v) => v.toJson()).toList();
  data['refer'] = entity.refer.toJson();
  return data;
}

extension CityModelEntityExtension on CityModelEntity {
  CityModelEntity copyWith({
    String? code,
    List<CityModelLocation>? data,
    CityModelRefer? refer,
  }) {
    return CityModelEntity()
      ..code = code ?? this.code
      ..data = data ?? this.data
      ..refer = refer ?? this.refer;
  }
}

CityModelLocation $CityModelLocationFromJson(Map<String, dynamic> json) {
  final CityModelLocation cityModelLocation = CityModelLocation();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    cityModelLocation.name = name;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    cityModelLocation.id = id;
  }
  final String? lat = jsonConvert.convert<String>(json['lat']);
  if (lat != null) {
    cityModelLocation.lat = lat;
  }
  final String? lon = jsonConvert.convert<String>(json['lon']);
  if (lon != null) {
    cityModelLocation.lon = lon;
  }
  final String? adm2 = jsonConvert.convert<String>(json['adm2']);
  if (adm2 != null) {
    cityModelLocation.adm2 = adm2;
  }
  final String? adm1 = jsonConvert.convert<String>(json['adm1']);
  if (adm1 != null) {
    cityModelLocation.adm1 = adm1;
  }
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    cityModelLocation.country = country;
  }
  final String? tz = jsonConvert.convert<String>(json['tz']);
  if (tz != null) {
    cityModelLocation.tz = tz;
  }
  final String? utcOffset = jsonConvert.convert<String>(json['utcOffset']);
  if (utcOffset != null) {
    cityModelLocation.utcOffset = utcOffset;
  }
  final String? isDst = jsonConvert.convert<String>(json['isDst']);
  if (isDst != null) {
    cityModelLocation.isDst = isDst;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    cityModelLocation.type = type;
  }
  final String? rank = jsonConvert.convert<String>(json['rank']);
  if (rank != null) {
    cityModelLocation.rank = rank;
  }
  final String? fxLink = jsonConvert.convert<String>(json['fxLink']);
  if (fxLink != null) {
    cityModelLocation.fxLink = fxLink;
  }
  return cityModelLocation;
}

Map<String, dynamic> $CityModelLocationToJson(CityModelLocation entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['id'] = entity.id;
  data['lat'] = entity.lat;
  data['lon'] = entity.lon;
  data['adm2'] = entity.adm2;
  data['adm1'] = entity.adm1;
  data['country'] = entity.country;
  data['tz'] = entity.tz;
  data['utcOffset'] = entity.utcOffset;
  data['isDst'] = entity.isDst;
  data['type'] = entity.type;
  data['rank'] = entity.rank;
  data['fxLink'] = entity.fxLink;
  return data;
}

extension CityModelLocationExtension on CityModelLocation {
  CityModelLocation copyWith({
    String? name,
    String? id,
    String? lat,
    String? lon,
    String? adm2,
    String? adm1,
    String? country,
    String? tz,
    String? utcOffset,
    String? isDst,
    String? type,
    String? rank,
    String? fxLink,
  }) {
    return CityModelLocation()
      ..name = name ?? this.name
      ..id = id ?? this.id
      ..lat = lat ?? this.lat
      ..lon = lon ?? this.lon
      ..adm2 = adm2 ?? this.adm2
      ..adm1 = adm1 ?? this.adm1
      ..country = country ?? this.country
      ..tz = tz ?? this.tz
      ..utcOffset = utcOffset ?? this.utcOffset
      ..isDst = isDst ?? this.isDst
      ..type = type ?? this.type
      ..rank = rank ?? this.rank
      ..fxLink = fxLink ?? this.fxLink;
  }
}

CityModelRefer $CityModelReferFromJson(Map<String, dynamic> json) {
  final CityModelRefer cityModelRefer = CityModelRefer();
  final List<String>? sources = (json['sources'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (sources != null) {
    cityModelRefer.sources = sources;
  }
  final List<String>? license = (json['license'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (license != null) {
    cityModelRefer.license = license;
  }
  return cityModelRefer;
}

Map<String, dynamic> $CityModelReferToJson(CityModelRefer entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['sources'] = entity.sources;
  data['license'] = entity.license;
  return data;
}

extension CityModelReferExtension on CityModelRefer {
  CityModelRefer copyWith({
    List<String>? sources,
    List<String>? license,
  }) {
    return CityModelRefer()
      ..sources = sources ?? this.sources
      ..license = license ?? this.license;
  }
}