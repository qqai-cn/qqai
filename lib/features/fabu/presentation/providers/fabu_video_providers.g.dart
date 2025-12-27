// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabu_video_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FabuVideoNotifier)
const fabuVideoProvider = FabuVideoNotifierProvider._();

final class FabuVideoNotifierProvider
    extends $NotifierProvider<FabuVideoNotifier, FabuVideoState> {
  const FabuVideoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fabuVideoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fabuVideoNotifierHash();

  @$internal
  @override
  FabuVideoNotifier create() => FabuVideoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FabuVideoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FabuVideoState>(value),
    );
  }
}

String _$fabuVideoNotifierHash() => r'de49100a7833e0802aaf045662225e5e8faef444';

abstract class _$FabuVideoNotifier extends $Notifier<FabuVideoState> {
  FabuVideoState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FabuVideoState, FabuVideoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FabuVideoState, FabuVideoState>,
              FabuVideoState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
