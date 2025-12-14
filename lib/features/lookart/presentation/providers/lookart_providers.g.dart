// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookart_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LookArtNotifier)
const lookArtProvider = LookArtNotifierProvider._();

final class LookArtNotifierProvider
    extends $NotifierProvider<LookArtNotifier, LookArtState> {
  const LookArtNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lookArtProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lookArtNotifierHash();

  @$internal
  @override
  LookArtNotifier create() => LookArtNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LookArtState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LookArtState>(value),
    );
  }
}

String _$lookArtNotifierHash() => r'1cb9cef3c5f95edead894f590ced5b23378640c8';

abstract class _$LookArtNotifier extends $Notifier<LookArtState> {
  LookArtState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LookArtState, LookArtState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<LookArtState, LookArtState>,
        LookArtState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
