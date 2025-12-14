// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_video_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShortVideoNotifier)
const shortVideoProvider = ShortVideoNotifierProvider._();

final class ShortVideoNotifierProvider
    extends $NotifierProvider<ShortVideoNotifier, ShortVideoState> {
  const ShortVideoNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'shortVideoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$shortVideoNotifierHash();

  @$internal
  @override
  ShortVideoNotifier create() => ShortVideoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShortVideoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShortVideoState>(value),
    );
  }
}

String _$shortVideoNotifierHash() =>
    r'18132492f04f7c35709c176b43fd49c5810c4b43';

abstract class _$ShortVideoNotifier extends $Notifier<ShortVideoState> {
  ShortVideoState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ShortVideoState, ShortVideoState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ShortVideoState, ShortVideoState>,
        ShortVideoState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
