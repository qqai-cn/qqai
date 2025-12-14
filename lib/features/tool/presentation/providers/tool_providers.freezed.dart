// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ToolState {
  Map<int, GenThumbnailImage> get imgMap;
  int get curStyle;

  /// Create a copy of ToolState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolStateCopyWith<ToolState> get copyWith =>
      _$ToolStateCopyWithImpl<ToolState>(this as ToolState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolState &&
            const DeepCollectionEquality().equals(other.imgMap, imgMap) &&
            (identical(other.curStyle, curStyle) ||
                other.curStyle == curStyle));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(imgMap), curStyle);

  @override
  String toString() {
    return 'ToolState(imgMap: $imgMap, curStyle: $curStyle)';
  }
}

/// @nodoc
abstract mixin class $ToolStateCopyWith<$Res> {
  factory $ToolStateCopyWith(ToolState value, $Res Function(ToolState) _then) =
      _$ToolStateCopyWithImpl;
  @useResult
  $Res call({Map<int, GenThumbnailImage> imgMap, int curStyle});
}

/// @nodoc
class _$ToolStateCopyWithImpl<$Res> implements $ToolStateCopyWith<$Res> {
  _$ToolStateCopyWithImpl(this._self, this._then);

  final ToolState _self;
  final $Res Function(ToolState) _then;

  /// Create a copy of ToolState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imgMap = null,
    Object? curStyle = null,
  }) {
    return _then(_self.copyWith(
      imgMap: null == imgMap
          ? _self.imgMap
          : imgMap // ignore: cast_nullable_to_non_nullable
              as Map<int, GenThumbnailImage>,
      curStyle: null == curStyle
          ? _self.curStyle
          : curStyle // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ToolState].
extension ToolStatePatterns on ToolState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ToolState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ToolState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolState():
        return $default(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ToolState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Map<int, GenThumbnailImage> imgMap, int curStyle)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolState() when $default != null:
        return $default(_that.imgMap, _that.curStyle);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Map<int, GenThumbnailImage> imgMap, int curStyle) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolState():
        return $default(_that.imgMap, _that.curStyle);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(Map<int, GenThumbnailImage> imgMap, int curStyle)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolState() when $default != null:
        return $default(_that.imgMap, _that.curStyle);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ToolState implements ToolState {
  const _ToolState(
      {final Map<int, GenThumbnailImage> imgMap = const {}, this.curStyle = 1})
      : _imgMap = imgMap;

  final Map<int, GenThumbnailImage> _imgMap;
  @override
  @JsonKey()
  Map<int, GenThumbnailImage> get imgMap {
    if (_imgMap is EqualUnmodifiableMapView) return _imgMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_imgMap);
  }

  @override
  @JsonKey()
  final int curStyle;

  /// Create a copy of ToolState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ToolStateCopyWith<_ToolState> get copyWith =>
      __$ToolStateCopyWithImpl<_ToolState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ToolState &&
            const DeepCollectionEquality().equals(other._imgMap, _imgMap) &&
            (identical(other.curStyle, curStyle) ||
                other.curStyle == curStyle));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_imgMap), curStyle);

  @override
  String toString() {
    return 'ToolState(imgMap: $imgMap, curStyle: $curStyle)';
  }
}

/// @nodoc
abstract mixin class _$ToolStateCopyWith<$Res>
    implements $ToolStateCopyWith<$Res> {
  factory _$ToolStateCopyWith(
          _ToolState value, $Res Function(_ToolState) _then) =
      __$ToolStateCopyWithImpl;
  @override
  @useResult
  $Res call({Map<int, GenThumbnailImage> imgMap, int curStyle});
}

/// @nodoc
class __$ToolStateCopyWithImpl<$Res> implements _$ToolStateCopyWith<$Res> {
  __$ToolStateCopyWithImpl(this._self, this._then);

  final _ToolState _self;
  final $Res Function(_ToolState) _then;

  /// Create a copy of ToolState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? imgMap = null,
    Object? curStyle = null,
  }) {
    return _then(_ToolState(
      imgMap: null == imgMap
          ? _self._imgMap
          : imgMap // ignore: cast_nullable_to_non_nullable
              as Map<int, GenThumbnailImage>,
      curStyle: null == curStyle
          ? _self.curStyle
          : curStyle // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
