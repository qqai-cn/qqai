// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'short_video_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShortVideoState {
  List<String> get videoItems;
  double get maxCross;

  /// Create a copy of ShortVideoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShortVideoStateCopyWith<ShortVideoState> get copyWith =>
      _$ShortVideoStateCopyWithImpl<ShortVideoState>(
          this as ShortVideoState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShortVideoState &&
            const DeepCollectionEquality()
                .equals(other.videoItems, videoItems) &&
            (identical(other.maxCross, maxCross) ||
                other.maxCross == maxCross));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(videoItems), maxCross);

  @override
  String toString() {
    return 'ShortVideoState(videoItems: $videoItems, maxCross: $maxCross)';
  }
}

/// @nodoc
abstract mixin class $ShortVideoStateCopyWith<$Res> {
  factory $ShortVideoStateCopyWith(
          ShortVideoState value, $Res Function(ShortVideoState) _then) =
      _$ShortVideoStateCopyWithImpl;
  @useResult
  $Res call({List<String> videoItems, double maxCross});
}

/// @nodoc
class _$ShortVideoStateCopyWithImpl<$Res>
    implements $ShortVideoStateCopyWith<$Res> {
  _$ShortVideoStateCopyWithImpl(this._self, this._then);

  final ShortVideoState _self;
  final $Res Function(ShortVideoState) _then;

  /// Create a copy of ShortVideoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoItems = null,
    Object? maxCross = null,
  }) {
    return _then(_self.copyWith(
      videoItems: null == videoItems
          ? _self.videoItems
          : videoItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxCross: null == maxCross
          ? _self.maxCross
          : maxCross // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShortVideoState].
extension ShortVideoStatePatterns on ShortVideoState {
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
    TResult Function(_ShortVideoState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShortVideoState() when $default != null:
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
    TResult Function(_ShortVideoState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShortVideoState():
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
    TResult? Function(_ShortVideoState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShortVideoState() when $default != null:
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
    TResult Function(List<String> videoItems, double maxCross)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShortVideoState() when $default != null:
        return $default(_that.videoItems, _that.maxCross);
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
    TResult Function(List<String> videoItems, double maxCross) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShortVideoState():
        return $default(_that.videoItems, _that.maxCross);
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
    TResult? Function(List<String> videoItems, double maxCross)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShortVideoState() when $default != null:
        return $default(_that.videoItems, _that.maxCross);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ShortVideoState implements ShortVideoState {
  const _ShortVideoState(
      {final List<String> videoItems = const [], this.maxCross = 1000.0})
      : _videoItems = videoItems;

  final List<String> _videoItems;
  @override
  @JsonKey()
  List<String> get videoItems {
    if (_videoItems is EqualUnmodifiableListView) return _videoItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoItems);
  }

  @override
  @JsonKey()
  final double maxCross;

  /// Create a copy of ShortVideoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShortVideoStateCopyWith<_ShortVideoState> get copyWith =>
      __$ShortVideoStateCopyWithImpl<_ShortVideoState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShortVideoState &&
            const DeepCollectionEquality()
                .equals(other._videoItems, _videoItems) &&
            (identical(other.maxCross, maxCross) ||
                other.maxCross == maxCross));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_videoItems), maxCross);

  @override
  String toString() {
    return 'ShortVideoState(videoItems: $videoItems, maxCross: $maxCross)';
  }
}

/// @nodoc
abstract mixin class _$ShortVideoStateCopyWith<$Res>
    implements $ShortVideoStateCopyWith<$Res> {
  factory _$ShortVideoStateCopyWith(
          _ShortVideoState value, $Res Function(_ShortVideoState) _then) =
      __$ShortVideoStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<String> videoItems, double maxCross});
}

/// @nodoc
class __$ShortVideoStateCopyWithImpl<$Res>
    implements _$ShortVideoStateCopyWith<$Res> {
  __$ShortVideoStateCopyWithImpl(this._self, this._then);

  final _ShortVideoState _self;
  final $Res Function(_ShortVideoState) _then;

  /// Create a copy of ShortVideoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? videoItems = null,
    Object? maxCross = null,
  }) {
    return _then(_ShortVideoState(
      videoItems: null == videoItems
          ? _self._videoItems
          : videoItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxCross: null == maxCross
          ? _self.maxCross
          : maxCross // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
