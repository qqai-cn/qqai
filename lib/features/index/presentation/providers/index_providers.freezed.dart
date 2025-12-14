// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'index_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IndexState {
  bool get hasSearch;
  Map<int, ScrollController> get controllers;

  /// Create a copy of IndexState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IndexStateCopyWith<IndexState> get copyWith =>
      _$IndexStateCopyWithImpl<IndexState>(this as IndexState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IndexState &&
            (identical(other.hasSearch, hasSearch) ||
                other.hasSearch == hasSearch) &&
            const DeepCollectionEquality()
                .equals(other.controllers, controllers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, hasSearch, const DeepCollectionEquality().hash(controllers));

  @override
  String toString() {
    return 'IndexState(hasSearch: $hasSearch, controllers: $controllers)';
  }
}

/// @nodoc
abstract mixin class $IndexStateCopyWith<$Res> {
  factory $IndexStateCopyWith(
          IndexState value, $Res Function(IndexState) _then) =
      _$IndexStateCopyWithImpl;
  @useResult
  $Res call({bool hasSearch, Map<int, ScrollController> controllers});
}

/// @nodoc
class _$IndexStateCopyWithImpl<$Res> implements $IndexStateCopyWith<$Res> {
  _$IndexStateCopyWithImpl(this._self, this._then);

  final IndexState _self;
  final $Res Function(IndexState) _then;

  /// Create a copy of IndexState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasSearch = null,
    Object? controllers = null,
  }) {
    return _then(_self.copyWith(
      hasSearch: null == hasSearch
          ? _self.hasSearch
          : hasSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      controllers: null == controllers
          ? _self.controllers
          : controllers // ignore: cast_nullable_to_non_nullable
              as Map<int, ScrollController>,
    ));
  }
}

/// Adds pattern-matching-related methods to [IndexState].
extension IndexStatePatterns on IndexState {
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
    TResult Function(_IndexState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IndexState() when $default != null:
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
    TResult Function(_IndexState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IndexState():
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
    TResult? Function(_IndexState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IndexState() when $default != null:
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
    TResult Function(bool hasSearch, Map<int, ScrollController> controllers)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IndexState() when $default != null:
        return $default(_that.hasSearch, _that.controllers);
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
    TResult Function(bool hasSearch, Map<int, ScrollController> controllers)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IndexState():
        return $default(_that.hasSearch, _that.controllers);
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
    TResult? Function(bool hasSearch, Map<int, ScrollController> controllers)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IndexState() when $default != null:
        return $default(_that.hasSearch, _that.controllers);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _IndexState implements IndexState {
  const _IndexState(
      {this.hasSearch = true,
      final Map<int, ScrollController> controllers = const {}})
      : _controllers = controllers;

  @override
  @JsonKey()
  final bool hasSearch;
  final Map<int, ScrollController> _controllers;
  @override
  @JsonKey()
  Map<int, ScrollController> get controllers {
    if (_controllers is EqualUnmodifiableMapView) return _controllers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_controllers);
  }

  /// Create a copy of IndexState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IndexStateCopyWith<_IndexState> get copyWith =>
      __$IndexStateCopyWithImpl<_IndexState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IndexState &&
            (identical(other.hasSearch, hasSearch) ||
                other.hasSearch == hasSearch) &&
            const DeepCollectionEquality()
                .equals(other._controllers, _controllers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasSearch,
      const DeepCollectionEquality().hash(_controllers));

  @override
  String toString() {
    return 'IndexState(hasSearch: $hasSearch, controllers: $controllers)';
  }
}

/// @nodoc
abstract mixin class _$IndexStateCopyWith<$Res>
    implements $IndexStateCopyWith<$Res> {
  factory _$IndexStateCopyWith(
          _IndexState value, $Res Function(_IndexState) _then) =
      __$IndexStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool hasSearch, Map<int, ScrollController> controllers});
}

/// @nodoc
class __$IndexStateCopyWithImpl<$Res> implements _$IndexStateCopyWith<$Res> {
  __$IndexStateCopyWithImpl(this._self, this._then);

  final _IndexState _self;
  final $Res Function(_IndexState) _then;

  /// Create a copy of IndexState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hasSearch = null,
    Object? controllers = null,
  }) {
    return _then(_IndexState(
      hasSearch: null == hasSearch
          ? _self.hasSearch
          : hasSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      controllers: null == controllers
          ? _self._controllers
          : controllers // ignore: cast_nullable_to_non_nullable
              as Map<int, ScrollController>,
    ));
  }
}

// dart format on
