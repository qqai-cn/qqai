// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabu_dynamic_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fabuDynamicRepo)
const fabuDynamicRepoProvider = FabuDynamicRepoProvider._();

final class FabuDynamicRepoProvider extends $FunctionalProvider<FabuDynamicRepo,
    FabuDynamicRepo, FabuDynamicRepo> with $Provider<FabuDynamicRepo> {
  const FabuDynamicRepoProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fabuDynamicRepoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fabuDynamicRepoHash();

  @$internal
  @override
  $ProviderElement<FabuDynamicRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FabuDynamicRepo create(Ref ref) {
    return fabuDynamicRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FabuDynamicRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FabuDynamicRepo>(value),
    );
  }
}

String _$fabuDynamicRepoHash() => r'1ce8ba75ef74fe8546e6c72b7169a7c478293e69';

@ProviderFor(FabuDynamicNotifier)
const fabuDynamicProvider = FabuDynamicNotifierProvider._();

final class FabuDynamicNotifierProvider
    extends $NotifierProvider<FabuDynamicNotifier, FabuDynamicState> {
  const FabuDynamicNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fabuDynamicProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fabuDynamicNotifierHash();

  @$internal
  @override
  FabuDynamicNotifier create() => FabuDynamicNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FabuDynamicState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FabuDynamicState>(value),
    );
  }
}

String _$fabuDynamicNotifierHash() =>
    r'6ae1daf5ce7d9555358b42cc5d09433af9715f4d';

abstract class _$FabuDynamicNotifier extends $Notifier<FabuDynamicState> {
  FabuDynamicState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FabuDynamicState, FabuDynamicState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FabuDynamicState, FabuDynamicState>,
        FabuDynamicState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
