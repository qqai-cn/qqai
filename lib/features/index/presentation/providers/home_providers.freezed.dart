// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeState {
  bool get hasSearch;
  int get selected;
  int get bottomMenuType;
  List<String> get tabTitle;
  int get colCount;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeStateCopyWith<HomeState> get copyWith =>
      _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeState &&
            (identical(other.hasSearch, hasSearch) ||
                other.hasSearch == hasSearch) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.bottomMenuType, bottomMenuType) ||
                other.bottomMenuType == bottomMenuType) &&
            const DeepCollectionEquality().equals(other.tabTitle, tabTitle) &&
            (identical(other.colCount, colCount) ||
                other.colCount == colCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasSearch, selected,
      bottomMenuType, const DeepCollectionEquality().hash(tabTitle), colCount);

  @override
  String toString() {
    return 'HomeState(hasSearch: $hasSearch, selected: $selected, bottomMenuType: $bottomMenuType, tabTitle: $tabTitle, colCount: $colCount)';
  }
}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) =
      _$HomeStateCopyWithImpl;
  @useResult
  $Res call(
      {bool hasSearch,
      int selected,
      int bottomMenuType,
      List<String> tabTitle,
      int colCount});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasSearch = null,
    Object? selected = null,
    Object? bottomMenuType = null,
    Object? tabTitle = null,
    Object? colCount = null,
  }) {
    return _then(_self.copyWith(
      hasSearch: null == hasSearch
          ? _self.hasSearch
          : hasSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as int,
      bottomMenuType: null == bottomMenuType
          ? _self.bottomMenuType
          : bottomMenuType // ignore: cast_nullable_to_non_nullable
              as int,
      tabTitle: null == tabTitle
          ? _self.tabTitle
          : tabTitle // ignore: cast_nullable_to_non_nullable
              as List<String>,
      colCount: null == colCount
          ? _self.colCount
          : colCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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
    TResult Function(_HomeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(_HomeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
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
    TResult? Function(_HomeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(bool hasSearch, int selected, int bottomMenuType,
            List<String> tabTitle, int colCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(_that.hasSearch, _that.selected, _that.bottomMenuType,
            _that.tabTitle, _that.colCount);
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
    TResult Function(bool hasSearch, int selected, int bottomMenuType,
            List<String> tabTitle, int colCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
        return $default(_that.hasSearch, _that.selected, _that.bottomMenuType,
            _that.tabTitle, _that.colCount);
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
    TResult? Function(bool hasSearch, int selected, int bottomMenuType,
            List<String> tabTitle, int colCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(_that.hasSearch, _that.selected, _that.bottomMenuType,
            _that.tabTitle, _that.colCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HomeState implements HomeState {
  const _HomeState(
      {this.hasSearch = true,
      this.selected = 0,
      this.bottomMenuType = 1,
      final List<String> tabTitle = const [],
      this.colCount = 2})
      : _tabTitle = tabTitle;

  @override
  @JsonKey()
  final bool hasSearch;
  @override
  @JsonKey()
  final int selected;
  @override
  @JsonKey()
  final int bottomMenuType;
  final List<String> _tabTitle;
  @override
  @JsonKey()
  List<String> get tabTitle {
    if (_tabTitle is EqualUnmodifiableListView) return _tabTitle;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tabTitle);
  }

  @override
  @JsonKey()
  final int colCount;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeStateCopyWith<_HomeState> get copyWith =>
      __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeState &&
            (identical(other.hasSearch, hasSearch) ||
                other.hasSearch == hasSearch) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.bottomMenuType, bottomMenuType) ||
                other.bottomMenuType == bottomMenuType) &&
            const DeepCollectionEquality().equals(other._tabTitle, _tabTitle) &&
            (identical(other.colCount, colCount) ||
                other.colCount == colCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasSearch, selected,
      bottomMenuType, const DeepCollectionEquality().hash(_tabTitle), colCount);

  @override
  String toString() {
    return 'HomeState(hasSearch: $hasSearch, selected: $selected, bottomMenuType: $bottomMenuType, tabTitle: $tabTitle, colCount: $colCount)';
  }
}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(
          _HomeState value, $Res Function(_HomeState) _then) =
      __$HomeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool hasSearch,
      int selected,
      int bottomMenuType,
      List<String> tabTitle,
      int colCount});
}

/// @nodoc
class __$HomeStateCopyWithImpl<$Res> implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hasSearch = null,
    Object? selected = null,
    Object? bottomMenuType = null,
    Object? tabTitle = null,
    Object? colCount = null,
  }) {
    return _then(_HomeState(
      hasSearch: null == hasSearch
          ? _self.hasSearch
          : hasSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as int,
      bottomMenuType: null == bottomMenuType
          ? _self.bottomMenuType
          : bottomMenuType // ignore: cast_nullable_to_non_nullable
              as int,
      tabTitle: null == tabTitle
          ? _self._tabTitle
          : tabTitle // ignore: cast_nullable_to_non_nullable
              as List<String>,
      colCount: null == colCount
          ? _self.colCount
          : colCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
