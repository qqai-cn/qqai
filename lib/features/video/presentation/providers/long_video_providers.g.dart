// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_video_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LongVideoNotifier)
const longVideoProvider = LongVideoNotifierProvider._();

final class LongVideoNotifierProvider
    extends $NotifierProvider<LongVideoNotifier, LongVideoState> {
  const LongVideoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'longVideoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$longVideoNotifierHash();

  @$internal
  @override
  LongVideoNotifier create() => LongVideoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LongVideoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LongVideoState>(value),
    );
  }
}

String _$longVideoNotifierHash() => r'ac7fff40363a26e4cccc663a0052087361d14e99';

abstract class _$LongVideoNotifier extends $Notifier<LongVideoState> {
  LongVideoState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LongVideoState, LongVideoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LongVideoState, LongVideoState>,
              LongVideoState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
