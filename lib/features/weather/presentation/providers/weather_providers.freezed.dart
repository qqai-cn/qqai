// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherState {

 ApiCallStatus get apiCallStatus; dynamic get locationState; int get currentPage; Position? get curPosition; CityModelEntity? get curCity; RealTimeWeatherEntity? get realTimeWeather; List<CityModelLocation> get citys; List<RealTimeWeatherEntity> get realTimeWeathers; List<Map> get weatherMaps; bool get ifOnHour; Result? get selCity; TextEditingController get textEditingController; List<WeatherCityData> get weatherCitys; List<RealTimeWeatherEntity> get leftWeathers; List<DayWeatherDaily> get leftTodayDaily; List<Map<String, String>> get card1; List<HourWeatherHourly> get hourly; List<DayWeatherDaily> get daily; Map<int, String> get minMaxTemp; List<IndicesWeatherDaily> get indicesDaily; ScrollController get hourController; bool get showToTopBtn;
/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherStateCopyWith<WeatherState> get copyWith => _$WeatherStateCopyWithImpl<WeatherState>(this as WeatherState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherState&&(identical(other.apiCallStatus, apiCallStatus) || other.apiCallStatus == apiCallStatus)&&const DeepCollectionEquality().equals(other.locationState, locationState)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.curPosition, curPosition) || other.curPosition == curPosition)&&(identical(other.curCity, curCity) || other.curCity == curCity)&&(identical(other.realTimeWeather, realTimeWeather) || other.realTimeWeather == realTimeWeather)&&const DeepCollectionEquality().equals(other.citys, citys)&&const DeepCollectionEquality().equals(other.realTimeWeathers, realTimeWeathers)&&const DeepCollectionEquality().equals(other.weatherMaps, weatherMaps)&&(identical(other.ifOnHour, ifOnHour) || other.ifOnHour == ifOnHour)&&(identical(other.selCity, selCity) || other.selCity == selCity)&&(identical(other.textEditingController, textEditingController) || other.textEditingController == textEditingController)&&const DeepCollectionEquality().equals(other.weatherCitys, weatherCitys)&&const DeepCollectionEquality().equals(other.leftWeathers, leftWeathers)&&const DeepCollectionEquality().equals(other.leftTodayDaily, leftTodayDaily)&&const DeepCollectionEquality().equals(other.card1, card1)&&const DeepCollectionEquality().equals(other.hourly, hourly)&&const DeepCollectionEquality().equals(other.daily, daily)&&const DeepCollectionEquality().equals(other.minMaxTemp, minMaxTemp)&&const DeepCollectionEquality().equals(other.indicesDaily, indicesDaily)&&(identical(other.hourController, hourController) || other.hourController == hourController)&&(identical(other.showToTopBtn, showToTopBtn) || other.showToTopBtn == showToTopBtn));
}


@override
int get hashCode => Object.hashAll([runtimeType,apiCallStatus,const DeepCollectionEquality().hash(locationState),currentPage,curPosition,curCity,realTimeWeather,const DeepCollectionEquality().hash(citys),const DeepCollectionEquality().hash(realTimeWeathers),const DeepCollectionEquality().hash(weatherMaps),ifOnHour,selCity,textEditingController,const DeepCollectionEquality().hash(weatherCitys),const DeepCollectionEquality().hash(leftWeathers),const DeepCollectionEquality().hash(leftTodayDaily),const DeepCollectionEquality().hash(card1),const DeepCollectionEquality().hash(hourly),const DeepCollectionEquality().hash(daily),const DeepCollectionEquality().hash(minMaxTemp),const DeepCollectionEquality().hash(indicesDaily),hourController,showToTopBtn]);

@override
String toString() {
  return 'WeatherState(apiCallStatus: $apiCallStatus, locationState: $locationState, currentPage: $currentPage, curPosition: $curPosition, curCity: $curCity, realTimeWeather: $realTimeWeather, citys: $citys, realTimeWeathers: $realTimeWeathers, weatherMaps: $weatherMaps, ifOnHour: $ifOnHour, selCity: $selCity, textEditingController: $textEditingController, weatherCitys: $weatherCitys, leftWeathers: $leftWeathers, leftTodayDaily: $leftTodayDaily, card1: $card1, hourly: $hourly, daily: $daily, minMaxTemp: $minMaxTemp, indicesDaily: $indicesDaily, hourController: $hourController, showToTopBtn: $showToTopBtn)';
}


}

/// @nodoc
abstract mixin class $WeatherStateCopyWith<$Res>  {
  factory $WeatherStateCopyWith(WeatherState value, $Res Function(WeatherState) _then) = _$WeatherStateCopyWithImpl;
@useResult
$Res call({
 ApiCallStatus apiCallStatus, dynamic locationState, int currentPage, Position? curPosition, CityModelEntity? curCity, RealTimeWeatherEntity? realTimeWeather, List<CityModelLocation> citys, List<RealTimeWeatherEntity> realTimeWeathers, List<Map> weatherMaps, bool ifOnHour, Result? selCity, TextEditingController textEditingController, List<WeatherCityData> weatherCitys, List<RealTimeWeatherEntity> leftWeathers, List<DayWeatherDaily> leftTodayDaily, List<Map<String, String>> card1, List<HourWeatherHourly> hourly, List<DayWeatherDaily> daily, Map<int, String> minMaxTemp, List<IndicesWeatherDaily> indicesDaily, ScrollController hourController, bool showToTopBtn
});




}
/// @nodoc
class _$WeatherStateCopyWithImpl<$Res>
    implements $WeatherStateCopyWith<$Res> {
  _$WeatherStateCopyWithImpl(this._self, this._then);

  final WeatherState _self;
  final $Res Function(WeatherState) _then;

/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiCallStatus = null,Object? locationState = freezed,Object? currentPage = null,Object? curPosition = freezed,Object? curCity = freezed,Object? realTimeWeather = freezed,Object? citys = null,Object? realTimeWeathers = null,Object? weatherMaps = null,Object? ifOnHour = null,Object? selCity = freezed,Object? textEditingController = null,Object? weatherCitys = null,Object? leftWeathers = null,Object? leftTodayDaily = null,Object? card1 = null,Object? hourly = null,Object? daily = null,Object? minMaxTemp = null,Object? indicesDaily = null,Object? hourController = null,Object? showToTopBtn = null,}) {
  return _then(_self.copyWith(
apiCallStatus: null == apiCallStatus ? _self.apiCallStatus : apiCallStatus // ignore: cast_nullable_to_non_nullable
as ApiCallStatus,locationState: freezed == locationState ? _self.locationState : locationState // ignore: cast_nullable_to_non_nullable
as dynamic,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,curPosition: freezed == curPosition ? _self.curPosition : curPosition // ignore: cast_nullable_to_non_nullable
as Position?,curCity: freezed == curCity ? _self.curCity : curCity // ignore: cast_nullable_to_non_nullable
as CityModelEntity?,realTimeWeather: freezed == realTimeWeather ? _self.realTimeWeather : realTimeWeather // ignore: cast_nullable_to_non_nullable
as RealTimeWeatherEntity?,citys: null == citys ? _self.citys : citys // ignore: cast_nullable_to_non_nullable
as List<CityModelLocation>,realTimeWeathers: null == realTimeWeathers ? _self.realTimeWeathers : realTimeWeathers // ignore: cast_nullable_to_non_nullable
as List<RealTimeWeatherEntity>,weatherMaps: null == weatherMaps ? _self.weatherMaps : weatherMaps // ignore: cast_nullable_to_non_nullable
as List<Map>,ifOnHour: null == ifOnHour ? _self.ifOnHour : ifOnHour // ignore: cast_nullable_to_non_nullable
as bool,selCity: freezed == selCity ? _self.selCity : selCity // ignore: cast_nullable_to_non_nullable
as Result?,textEditingController: null == textEditingController ? _self.textEditingController : textEditingController // ignore: cast_nullable_to_non_nullable
as TextEditingController,weatherCitys: null == weatherCitys ? _self.weatherCitys : weatherCitys // ignore: cast_nullable_to_non_nullable
as List<WeatherCityData>,leftWeathers: null == leftWeathers ? _self.leftWeathers : leftWeathers // ignore: cast_nullable_to_non_nullable
as List<RealTimeWeatherEntity>,leftTodayDaily: null == leftTodayDaily ? _self.leftTodayDaily : leftTodayDaily // ignore: cast_nullable_to_non_nullable
as List<DayWeatherDaily>,card1: null == card1 ? _self.card1 : card1 // ignore: cast_nullable_to_non_nullable
as List<Map<String, String>>,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as List<HourWeatherHourly>,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DayWeatherDaily>,minMaxTemp: null == minMaxTemp ? _self.minMaxTemp : minMaxTemp // ignore: cast_nullable_to_non_nullable
as Map<int, String>,indicesDaily: null == indicesDaily ? _self.indicesDaily : indicesDaily // ignore: cast_nullable_to_non_nullable
as List<IndicesWeatherDaily>,hourController: null == hourController ? _self.hourController : hourController // ignore: cast_nullable_to_non_nullable
as ScrollController,showToTopBtn: null == showToTopBtn ? _self.showToTopBtn : showToTopBtn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherState].
extension WeatherStatePatterns on WeatherState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherState value)  $default,){
final _that = this;
switch (_that) {
case _WeatherState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherState value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiCallStatus apiCallStatus,  dynamic locationState,  int currentPage,  Position? curPosition,  CityModelEntity? curCity,  RealTimeWeatherEntity? realTimeWeather,  List<CityModelLocation> citys,  List<RealTimeWeatherEntity> realTimeWeathers,  List<Map> weatherMaps,  bool ifOnHour,  Result? selCity,  TextEditingController textEditingController,  List<WeatherCityData> weatherCitys,  List<RealTimeWeatherEntity> leftWeathers,  List<DayWeatherDaily> leftTodayDaily,  List<Map<String, String>> card1,  List<HourWeatherHourly> hourly,  List<DayWeatherDaily> daily,  Map<int, String> minMaxTemp,  List<IndicesWeatherDaily> indicesDaily,  ScrollController hourController,  bool showToTopBtn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherState() when $default != null:
return $default(_that.apiCallStatus,_that.locationState,_that.currentPage,_that.curPosition,_that.curCity,_that.realTimeWeather,_that.citys,_that.realTimeWeathers,_that.weatherMaps,_that.ifOnHour,_that.selCity,_that.textEditingController,_that.weatherCitys,_that.leftWeathers,_that.leftTodayDaily,_that.card1,_that.hourly,_that.daily,_that.minMaxTemp,_that.indicesDaily,_that.hourController,_that.showToTopBtn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiCallStatus apiCallStatus,  dynamic locationState,  int currentPage,  Position? curPosition,  CityModelEntity? curCity,  RealTimeWeatherEntity? realTimeWeather,  List<CityModelLocation> citys,  List<RealTimeWeatherEntity> realTimeWeathers,  List<Map> weatherMaps,  bool ifOnHour,  Result? selCity,  TextEditingController textEditingController,  List<WeatherCityData> weatherCitys,  List<RealTimeWeatherEntity> leftWeathers,  List<DayWeatherDaily> leftTodayDaily,  List<Map<String, String>> card1,  List<HourWeatherHourly> hourly,  List<DayWeatherDaily> daily,  Map<int, String> minMaxTemp,  List<IndicesWeatherDaily> indicesDaily,  ScrollController hourController,  bool showToTopBtn)  $default,) {final _that = this;
switch (_that) {
case _WeatherState():
return $default(_that.apiCallStatus,_that.locationState,_that.currentPage,_that.curPosition,_that.curCity,_that.realTimeWeather,_that.citys,_that.realTimeWeathers,_that.weatherMaps,_that.ifOnHour,_that.selCity,_that.textEditingController,_that.weatherCitys,_that.leftWeathers,_that.leftTodayDaily,_that.card1,_that.hourly,_that.daily,_that.minMaxTemp,_that.indicesDaily,_that.hourController,_that.showToTopBtn);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiCallStatus apiCallStatus,  dynamic locationState,  int currentPage,  Position? curPosition,  CityModelEntity? curCity,  RealTimeWeatherEntity? realTimeWeather,  List<CityModelLocation> citys,  List<RealTimeWeatherEntity> realTimeWeathers,  List<Map> weatherMaps,  bool ifOnHour,  Result? selCity,  TextEditingController textEditingController,  List<WeatherCityData> weatherCitys,  List<RealTimeWeatherEntity> leftWeathers,  List<DayWeatherDaily> leftTodayDaily,  List<Map<String, String>> card1,  List<HourWeatherHourly> hourly,  List<DayWeatherDaily> daily,  Map<int, String> minMaxTemp,  List<IndicesWeatherDaily> indicesDaily,  ScrollController hourController,  bool showToTopBtn)?  $default,) {final _that = this;
switch (_that) {
case _WeatherState() when $default != null:
return $default(_that.apiCallStatus,_that.locationState,_that.currentPage,_that.curPosition,_that.curCity,_that.realTimeWeather,_that.citys,_that.realTimeWeathers,_that.weatherMaps,_that.ifOnHour,_that.selCity,_that.textEditingController,_that.weatherCitys,_that.leftWeathers,_that.leftTodayDaily,_that.card1,_that.hourly,_that.daily,_that.minMaxTemp,_that.indicesDaily,_that.hourController,_that.showToTopBtn);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherState implements WeatherState {
  const _WeatherState({this.apiCallStatus = ApiCallStatus.holding, this.locationState, this.currentPage = -1, this.curPosition, this.curCity, this.realTimeWeather, final  List<CityModelLocation> citys = const [], final  List<RealTimeWeatherEntity> realTimeWeathers = const [], final  List<Map> weatherMaps = const [], this.ifOnHour = false, this.selCity, required this.textEditingController, final  List<WeatherCityData> weatherCitys = const [], final  List<RealTimeWeatherEntity> leftWeathers = const [], final  List<DayWeatherDaily> leftTodayDaily = const [], final  List<Map<String, String>> card1 = const [], final  List<HourWeatherHourly> hourly = const [], final  List<DayWeatherDaily> daily = const [], final  Map<int, String> minMaxTemp = const {}, final  List<IndicesWeatherDaily> indicesDaily = const [], required this.hourController, this.showToTopBtn = false}): _citys = citys,_realTimeWeathers = realTimeWeathers,_weatherMaps = weatherMaps,_weatherCitys = weatherCitys,_leftWeathers = leftWeathers,_leftTodayDaily = leftTodayDaily,_card1 = card1,_hourly = hourly,_daily = daily,_minMaxTemp = minMaxTemp,_indicesDaily = indicesDaily;
  

@override@JsonKey() final  ApiCallStatus apiCallStatus;
@override final  dynamic locationState;
@override@JsonKey() final  int currentPage;
@override final  Position? curPosition;
@override final  CityModelEntity? curCity;
@override final  RealTimeWeatherEntity? realTimeWeather;
 final  List<CityModelLocation> _citys;
@override@JsonKey() List<CityModelLocation> get citys {
  if (_citys is EqualUnmodifiableListView) return _citys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_citys);
}

 final  List<RealTimeWeatherEntity> _realTimeWeathers;
@override@JsonKey() List<RealTimeWeatherEntity> get realTimeWeathers {
  if (_realTimeWeathers is EqualUnmodifiableListView) return _realTimeWeathers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_realTimeWeathers);
}

 final  List<Map> _weatherMaps;
@override@JsonKey() List<Map> get weatherMaps {
  if (_weatherMaps is EqualUnmodifiableListView) return _weatherMaps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weatherMaps);
}

@override@JsonKey() final  bool ifOnHour;
@override final  Result? selCity;
@override final  TextEditingController textEditingController;
 final  List<WeatherCityData> _weatherCitys;
@override@JsonKey() List<WeatherCityData> get weatherCitys {
  if (_weatherCitys is EqualUnmodifiableListView) return _weatherCitys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weatherCitys);
}

 final  List<RealTimeWeatherEntity> _leftWeathers;
@override@JsonKey() List<RealTimeWeatherEntity> get leftWeathers {
  if (_leftWeathers is EqualUnmodifiableListView) return _leftWeathers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leftWeathers);
}

 final  List<DayWeatherDaily> _leftTodayDaily;
@override@JsonKey() List<DayWeatherDaily> get leftTodayDaily {
  if (_leftTodayDaily is EqualUnmodifiableListView) return _leftTodayDaily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leftTodayDaily);
}

 final  List<Map<String, String>> _card1;
@override@JsonKey() List<Map<String, String>> get card1 {
  if (_card1 is EqualUnmodifiableListView) return _card1;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_card1);
}

 final  List<HourWeatherHourly> _hourly;
@override@JsonKey() List<HourWeatherHourly> get hourly {
  if (_hourly is EqualUnmodifiableListView) return _hourly;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourly);
}

 final  List<DayWeatherDaily> _daily;
@override@JsonKey() List<DayWeatherDaily> get daily {
  if (_daily is EqualUnmodifiableListView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daily);
}

 final  Map<int, String> _minMaxTemp;
@override@JsonKey() Map<int, String> get minMaxTemp {
  if (_minMaxTemp is EqualUnmodifiableMapView) return _minMaxTemp;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_minMaxTemp);
}

 final  List<IndicesWeatherDaily> _indicesDaily;
@override@JsonKey() List<IndicesWeatherDaily> get indicesDaily {
  if (_indicesDaily is EqualUnmodifiableListView) return _indicesDaily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_indicesDaily);
}

@override final  ScrollController hourController;
@override@JsonKey() final  bool showToTopBtn;

/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherStateCopyWith<_WeatherState> get copyWith => __$WeatherStateCopyWithImpl<_WeatherState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherState&&(identical(other.apiCallStatus, apiCallStatus) || other.apiCallStatus == apiCallStatus)&&const DeepCollectionEquality().equals(other.locationState, locationState)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.curPosition, curPosition) || other.curPosition == curPosition)&&(identical(other.curCity, curCity) || other.curCity == curCity)&&(identical(other.realTimeWeather, realTimeWeather) || other.realTimeWeather == realTimeWeather)&&const DeepCollectionEquality().equals(other._citys, _citys)&&const DeepCollectionEquality().equals(other._realTimeWeathers, _realTimeWeathers)&&const DeepCollectionEquality().equals(other._weatherMaps, _weatherMaps)&&(identical(other.ifOnHour, ifOnHour) || other.ifOnHour == ifOnHour)&&(identical(other.selCity, selCity) || other.selCity == selCity)&&(identical(other.textEditingController, textEditingController) || other.textEditingController == textEditingController)&&const DeepCollectionEquality().equals(other._weatherCitys, _weatherCitys)&&const DeepCollectionEquality().equals(other._leftWeathers, _leftWeathers)&&const DeepCollectionEquality().equals(other._leftTodayDaily, _leftTodayDaily)&&const DeepCollectionEquality().equals(other._card1, _card1)&&const DeepCollectionEquality().equals(other._hourly, _hourly)&&const DeepCollectionEquality().equals(other._daily, _daily)&&const DeepCollectionEquality().equals(other._minMaxTemp, _minMaxTemp)&&const DeepCollectionEquality().equals(other._indicesDaily, _indicesDaily)&&(identical(other.hourController, hourController) || other.hourController == hourController)&&(identical(other.showToTopBtn, showToTopBtn) || other.showToTopBtn == showToTopBtn));
}


@override
int get hashCode => Object.hashAll([runtimeType,apiCallStatus,const DeepCollectionEquality().hash(locationState),currentPage,curPosition,curCity,realTimeWeather,const DeepCollectionEquality().hash(_citys),const DeepCollectionEquality().hash(_realTimeWeathers),const DeepCollectionEquality().hash(_weatherMaps),ifOnHour,selCity,textEditingController,const DeepCollectionEquality().hash(_weatherCitys),const DeepCollectionEquality().hash(_leftWeathers),const DeepCollectionEquality().hash(_leftTodayDaily),const DeepCollectionEquality().hash(_card1),const DeepCollectionEquality().hash(_hourly),const DeepCollectionEquality().hash(_daily),const DeepCollectionEquality().hash(_minMaxTemp),const DeepCollectionEquality().hash(_indicesDaily),hourController,showToTopBtn]);

@override
String toString() {
  return 'WeatherState(apiCallStatus: $apiCallStatus, locationState: $locationState, currentPage: $currentPage, curPosition: $curPosition, curCity: $curCity, realTimeWeather: $realTimeWeather, citys: $citys, realTimeWeathers: $realTimeWeathers, weatherMaps: $weatherMaps, ifOnHour: $ifOnHour, selCity: $selCity, textEditingController: $textEditingController, weatherCitys: $weatherCitys, leftWeathers: $leftWeathers, leftTodayDaily: $leftTodayDaily, card1: $card1, hourly: $hourly, daily: $daily, minMaxTemp: $minMaxTemp, indicesDaily: $indicesDaily, hourController: $hourController, showToTopBtn: $showToTopBtn)';
}


}

/// @nodoc
abstract mixin class _$WeatherStateCopyWith<$Res> implements $WeatherStateCopyWith<$Res> {
  factory _$WeatherStateCopyWith(_WeatherState value, $Res Function(_WeatherState) _then) = __$WeatherStateCopyWithImpl;
@override @useResult
$Res call({
 ApiCallStatus apiCallStatus, dynamic locationState, int currentPage, Position? curPosition, CityModelEntity? curCity, RealTimeWeatherEntity? realTimeWeather, List<CityModelLocation> citys, List<RealTimeWeatherEntity> realTimeWeathers, List<Map> weatherMaps, bool ifOnHour, Result? selCity, TextEditingController textEditingController, List<WeatherCityData> weatherCitys, List<RealTimeWeatherEntity> leftWeathers, List<DayWeatherDaily> leftTodayDaily, List<Map<String, String>> card1, List<HourWeatherHourly> hourly, List<DayWeatherDaily> daily, Map<int, String> minMaxTemp, List<IndicesWeatherDaily> indicesDaily, ScrollController hourController, bool showToTopBtn
});




}
/// @nodoc
class __$WeatherStateCopyWithImpl<$Res>
    implements _$WeatherStateCopyWith<$Res> {
  __$WeatherStateCopyWithImpl(this._self, this._then);

  final _WeatherState _self;
  final $Res Function(_WeatherState) _then;

/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiCallStatus = null,Object? locationState = freezed,Object? currentPage = null,Object? curPosition = freezed,Object? curCity = freezed,Object? realTimeWeather = freezed,Object? citys = null,Object? realTimeWeathers = null,Object? weatherMaps = null,Object? ifOnHour = null,Object? selCity = freezed,Object? textEditingController = null,Object? weatherCitys = null,Object? leftWeathers = null,Object? leftTodayDaily = null,Object? card1 = null,Object? hourly = null,Object? daily = null,Object? minMaxTemp = null,Object? indicesDaily = null,Object? hourController = null,Object? showToTopBtn = null,}) {
  return _then(_WeatherState(
apiCallStatus: null == apiCallStatus ? _self.apiCallStatus : apiCallStatus // ignore: cast_nullable_to_non_nullable
as ApiCallStatus,locationState: freezed == locationState ? _self.locationState : locationState // ignore: cast_nullable_to_non_nullable
as dynamic,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,curPosition: freezed == curPosition ? _self.curPosition : curPosition // ignore: cast_nullable_to_non_nullable
as Position?,curCity: freezed == curCity ? _self.curCity : curCity // ignore: cast_nullable_to_non_nullable
as CityModelEntity?,realTimeWeather: freezed == realTimeWeather ? _self.realTimeWeather : realTimeWeather // ignore: cast_nullable_to_non_nullable
as RealTimeWeatherEntity?,citys: null == citys ? _self._citys : citys // ignore: cast_nullable_to_non_nullable
as List<CityModelLocation>,realTimeWeathers: null == realTimeWeathers ? _self._realTimeWeathers : realTimeWeathers // ignore: cast_nullable_to_non_nullable
as List<RealTimeWeatherEntity>,weatherMaps: null == weatherMaps ? _self._weatherMaps : weatherMaps // ignore: cast_nullable_to_non_nullable
as List<Map>,ifOnHour: null == ifOnHour ? _self.ifOnHour : ifOnHour // ignore: cast_nullable_to_non_nullable
as bool,selCity: freezed == selCity ? _self.selCity : selCity // ignore: cast_nullable_to_non_nullable
as Result?,textEditingController: null == textEditingController ? _self.textEditingController : textEditingController // ignore: cast_nullable_to_non_nullable
as TextEditingController,weatherCitys: null == weatherCitys ? _self._weatherCitys : weatherCitys // ignore: cast_nullable_to_non_nullable
as List<WeatherCityData>,leftWeathers: null == leftWeathers ? _self._leftWeathers : leftWeathers // ignore: cast_nullable_to_non_nullable
as List<RealTimeWeatherEntity>,leftTodayDaily: null == leftTodayDaily ? _self._leftTodayDaily : leftTodayDaily // ignore: cast_nullable_to_non_nullable
as List<DayWeatherDaily>,card1: null == card1 ? _self._card1 : card1 // ignore: cast_nullable_to_non_nullable
as List<Map<String, String>>,hourly: null == hourly ? _self._hourly : hourly // ignore: cast_nullable_to_non_nullable
as List<HourWeatherHourly>,daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as List<DayWeatherDaily>,minMaxTemp: null == minMaxTemp ? _self._minMaxTemp : minMaxTemp // ignore: cast_nullable_to_non_nullable
as Map<int, String>,indicesDaily: null == indicesDaily ? _self._indicesDaily : indicesDaily // ignore: cast_nullable_to_non_nullable
as List<IndicesWeatherDaily>,hourController: null == hourController ? _self.hourController : hourController // ignore: cast_nullable_to_non_nullable
as ScrollController,showToTopBtn: null == showToTopBtn ? _self.showToTopBtn : showToTopBtn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
