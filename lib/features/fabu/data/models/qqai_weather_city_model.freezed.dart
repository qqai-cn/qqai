// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qqai_weather_city_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QqaiWeatherCityResVO implements DiagnosticableTreeMixin {

 String? get id; int? get adCode; String? get province; String? get provincePinyin; String? get city; String? get cityPinyin; String? get county; String? get countyPinyin; double? get lat; double? get lon;
/// Create a copy of QqaiWeatherCityResVO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QqaiWeatherCityResVOCopyWith<QqaiWeatherCityResVO> get copyWith => _$QqaiWeatherCityResVOCopyWithImpl<QqaiWeatherCityResVO>(this as QqaiWeatherCityResVO, _$identity);

  /// Serializes this QqaiWeatherCityResVO to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QqaiWeatherCityResVO'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('adCode', adCode))..add(DiagnosticsProperty('province', province))..add(DiagnosticsProperty('provincePinyin', provincePinyin))..add(DiagnosticsProperty('city', city))..add(DiagnosticsProperty('cityPinyin', cityPinyin))..add(DiagnosticsProperty('county', county))..add(DiagnosticsProperty('countyPinyin', countyPinyin))..add(DiagnosticsProperty('lat', lat))..add(DiagnosticsProperty('lon', lon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QqaiWeatherCityResVO&&(identical(other.id, id) || other.id == id)&&(identical(other.adCode, adCode) || other.adCode == adCode)&&(identical(other.province, province) || other.province == province)&&(identical(other.provincePinyin, provincePinyin) || other.provincePinyin == provincePinyin)&&(identical(other.city, city) || other.city == city)&&(identical(other.cityPinyin, cityPinyin) || other.cityPinyin == cityPinyin)&&(identical(other.county, county) || other.county == county)&&(identical(other.countyPinyin, countyPinyin) || other.countyPinyin == countyPinyin)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,adCode,province,provincePinyin,city,cityPinyin,county,countyPinyin,lat,lon);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'QqaiWeatherCityResVO(id: $id, adCode: $adCode, province: $province, provincePinyin: $provincePinyin, city: $city, cityPinyin: $cityPinyin, county: $county, countyPinyin: $countyPinyin, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class $QqaiWeatherCityResVOCopyWith<$Res>  {
  factory $QqaiWeatherCityResVOCopyWith(QqaiWeatherCityResVO value, $Res Function(QqaiWeatherCityResVO) _then) = _$QqaiWeatherCityResVOCopyWithImpl;
@useResult
$Res call({
 String? id, int? adCode, String? province, String? provincePinyin, String? city, String? cityPinyin, String? county, String? countyPinyin, double? lat, double? lon
});




}
/// @nodoc
class _$QqaiWeatherCityResVOCopyWithImpl<$Res>
    implements $QqaiWeatherCityResVOCopyWith<$Res> {
  _$QqaiWeatherCityResVOCopyWithImpl(this._self, this._then);

  final QqaiWeatherCityResVO _self;
  final $Res Function(QqaiWeatherCityResVO) _then;

/// Create a copy of QqaiWeatherCityResVO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? adCode = freezed,Object? province = freezed,Object? provincePinyin = freezed,Object? city = freezed,Object? cityPinyin = freezed,Object? county = freezed,Object? countyPinyin = freezed,Object? lat = freezed,Object? lon = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,adCode: freezed == adCode ? _self.adCode : adCode // ignore: cast_nullable_to_non_nullable
as int?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,provincePinyin: freezed == provincePinyin ? _self.provincePinyin : provincePinyin // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,cityPinyin: freezed == cityPinyin ? _self.cityPinyin : cityPinyin // ignore: cast_nullable_to_non_nullable
as String?,county: freezed == county ? _self.county : county // ignore: cast_nullable_to_non_nullable
as String?,countyPinyin: freezed == countyPinyin ? _self.countyPinyin : countyPinyin // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [QqaiWeatherCityResVO].
extension QqaiWeatherCityResVOPatterns on QqaiWeatherCityResVO {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QqaiWeatherCityResVO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QqaiWeatherCityResVO() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QqaiWeatherCityResVO value)  $default,){
final _that = this;
switch (_that) {
case _QqaiWeatherCityResVO():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QqaiWeatherCityResVO value)?  $default,){
final _that = this;
switch (_that) {
case _QqaiWeatherCityResVO() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  int? adCode,  String? province,  String? provincePinyin,  String? city,  String? cityPinyin,  String? county,  String? countyPinyin,  double? lat,  double? lon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QqaiWeatherCityResVO() when $default != null:
return $default(_that.id,_that.adCode,_that.province,_that.provincePinyin,_that.city,_that.cityPinyin,_that.county,_that.countyPinyin,_that.lat,_that.lon);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  int? adCode,  String? province,  String? provincePinyin,  String? city,  String? cityPinyin,  String? county,  String? countyPinyin,  double? lat,  double? lon)  $default,) {final _that = this;
switch (_that) {
case _QqaiWeatherCityResVO():
return $default(_that.id,_that.adCode,_that.province,_that.provincePinyin,_that.city,_that.cityPinyin,_that.county,_that.countyPinyin,_that.lat,_that.lon);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  int? adCode,  String? province,  String? provincePinyin,  String? city,  String? cityPinyin,  String? county,  String? countyPinyin,  double? lat,  double? lon)?  $default,) {final _that = this;
switch (_that) {
case _QqaiWeatherCityResVO() when $default != null:
return $default(_that.id,_that.adCode,_that.province,_that.provincePinyin,_that.city,_that.cityPinyin,_that.county,_that.countyPinyin,_that.lat,_that.lon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QqaiWeatherCityResVO with DiagnosticableTreeMixin implements QqaiWeatherCityResVO {
  const _QqaiWeatherCityResVO({this.id, this.adCode, this.province, this.provincePinyin, this.city, this.cityPinyin, this.county, this.countyPinyin, this.lat, this.lon});
  factory _QqaiWeatherCityResVO.fromJson(Map<String, dynamic> json) => _$QqaiWeatherCityResVOFromJson(json);

@override final  String? id;
@override final  int? adCode;
@override final  String? province;
@override final  String? provincePinyin;
@override final  String? city;
@override final  String? cityPinyin;
@override final  String? county;
@override final  String? countyPinyin;
@override final  double? lat;
@override final  double? lon;

/// Create a copy of QqaiWeatherCityResVO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QqaiWeatherCityResVOCopyWith<_QqaiWeatherCityResVO> get copyWith => __$QqaiWeatherCityResVOCopyWithImpl<_QqaiWeatherCityResVO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QqaiWeatherCityResVOToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QqaiWeatherCityResVO'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('adCode', adCode))..add(DiagnosticsProperty('province', province))..add(DiagnosticsProperty('provincePinyin', provincePinyin))..add(DiagnosticsProperty('city', city))..add(DiagnosticsProperty('cityPinyin', cityPinyin))..add(DiagnosticsProperty('county', county))..add(DiagnosticsProperty('countyPinyin', countyPinyin))..add(DiagnosticsProperty('lat', lat))..add(DiagnosticsProperty('lon', lon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QqaiWeatherCityResVO&&(identical(other.id, id) || other.id == id)&&(identical(other.adCode, adCode) || other.adCode == adCode)&&(identical(other.province, province) || other.province == province)&&(identical(other.provincePinyin, provincePinyin) || other.provincePinyin == provincePinyin)&&(identical(other.city, city) || other.city == city)&&(identical(other.cityPinyin, cityPinyin) || other.cityPinyin == cityPinyin)&&(identical(other.county, county) || other.county == county)&&(identical(other.countyPinyin, countyPinyin) || other.countyPinyin == countyPinyin)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,adCode,province,provincePinyin,city,cityPinyin,county,countyPinyin,lat,lon);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'QqaiWeatherCityResVO(id: $id, adCode: $adCode, province: $province, provincePinyin: $provincePinyin, city: $city, cityPinyin: $cityPinyin, county: $county, countyPinyin: $countyPinyin, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class _$QqaiWeatherCityResVOCopyWith<$Res> implements $QqaiWeatherCityResVOCopyWith<$Res> {
  factory _$QqaiWeatherCityResVOCopyWith(_QqaiWeatherCityResVO value, $Res Function(_QqaiWeatherCityResVO) _then) = __$QqaiWeatherCityResVOCopyWithImpl;
@override @useResult
$Res call({
 String? id, int? adCode, String? province, String? provincePinyin, String? city, String? cityPinyin, String? county, String? countyPinyin, double? lat, double? lon
});




}
/// @nodoc
class __$QqaiWeatherCityResVOCopyWithImpl<$Res>
    implements _$QqaiWeatherCityResVOCopyWith<$Res> {
  __$QqaiWeatherCityResVOCopyWithImpl(this._self, this._then);

  final _QqaiWeatherCityResVO _self;
  final $Res Function(_QqaiWeatherCityResVO) _then;

/// Create a copy of QqaiWeatherCityResVO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? adCode = freezed,Object? province = freezed,Object? provincePinyin = freezed,Object? city = freezed,Object? cityPinyin = freezed,Object? county = freezed,Object? countyPinyin = freezed,Object? lat = freezed,Object? lon = freezed,}) {
  return _then(_QqaiWeatherCityResVO(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,adCode: freezed == adCode ? _self.adCode : adCode // ignore: cast_nullable_to_non_nullable
as int?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,provincePinyin: freezed == provincePinyin ? _self.provincePinyin : provincePinyin // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,cityPinyin: freezed == cityPinyin ? _self.cityPinyin : cityPinyin // ignore: cast_nullable_to_non_nullable
as String?,county: freezed == county ? _self.county : county // ignore: cast_nullable_to_non_nullable
as String?,countyPinyin: freezed == countyPinyin ? _self.countyPinyin : countyPinyin // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
