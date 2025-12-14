// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabu_zuopin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FabuZuoPinNotifier)
const fabuZuoPinProvider = FabuZuoPinNotifierProvider._();

final class FabuZuoPinNotifierProvider
    extends $NotifierProvider<FabuZuoPinNotifier, FabuZuoPinState> {
  const FabuZuoPinNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fabuZuoPinProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fabuZuoPinNotifierHash();

  @$internal
  @override
  FabuZuoPinNotifier create() => FabuZuoPinNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FabuZuoPinState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FabuZuoPinState>(value),
    );
  }
}

String _$fabuZuoPinNotifierHash() =>
    r'a45cca8233083c14338b9ed299bce59436ffaebd';

abstract class _$FabuZuoPinNotifier extends $Notifier<FabuZuoPinState> {
  FabuZuoPinState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FabuZuoPinState, FabuZuoPinState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FabuZuoPinState, FabuZuoPinState>,
        FabuZuoPinState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
