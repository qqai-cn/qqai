// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weatherRepo)
const weatherRepoProvider = WeatherRepoProvider._();

final class WeatherRepoProvider
    extends $FunctionalProvider<WeatherRepo, WeatherRepo, WeatherRepo>
    with $Provider<WeatherRepo> {
  const WeatherRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepoHash();

  @$internal
  @override
  $ProviderElement<WeatherRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeatherRepo create(Ref ref) {
    return weatherRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepo>(value),
    );
  }
}

String _$weatherRepoHash() => r'6b598b12861fcb1c9fe34527da012f9fe5355541';

@ProviderFor(WeatherNotifier)
const weatherProvider = WeatherNotifierProvider._();

final class WeatherNotifierProvider
    extends $NotifierProvider<WeatherNotifier, WeatherState> {
  const WeatherNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherNotifierHash();

  @$internal
  @override
  WeatherNotifier create() => WeatherNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherState>(value),
    );
  }
}

String _$weatherNotifierHash() => r'340401c5fc766cbb750c34a90dbf714fbf41a663';

abstract class _$WeatherNotifier extends $Notifier<WeatherState> {
  WeatherState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WeatherState, WeatherState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WeatherState, WeatherState>,
              WeatherState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
