// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabu_short_video_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FabuShortVideoNotifier)
const fabuShortVideoProvider = FabuShortVideoNotifierProvider._();

final class FabuShortVideoNotifierProvider
    extends $NotifierProvider<FabuShortVideoNotifier, FabuShortVideoState> {
  const FabuShortVideoNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fabuShortVideoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fabuShortVideoNotifierHash();

  @$internal
  @override
  FabuShortVideoNotifier create() => FabuShortVideoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FabuShortVideoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FabuShortVideoState>(value),
    );
  }
}

String _$fabuShortVideoNotifierHash() =>
    r'de54a2709faa7111b5cf4c463bba8d609c0affba';

abstract class _$FabuShortVideoNotifier extends $Notifier<FabuShortVideoState> {
  FabuShortVideoState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FabuShortVideoState, FabuShortVideoState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FabuShortVideoState, FabuShortVideoState>,
        FabuShortVideoState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
