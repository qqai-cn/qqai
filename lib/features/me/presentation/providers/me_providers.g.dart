// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MeNotifier)
const meProvider = MeNotifierProvider._();

final class MeNotifierProvider extends $NotifierProvider<MeNotifier, MeState> {
  const MeNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'meProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$meNotifierHash();

  @$internal
  @override
  MeNotifier create() => MeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeState>(value),
    );
  }
}

String _$meNotifierHash() => r'485a596a11b2e7f4f01e1cb208e558e138ed0654';

abstract class _$MeNotifier extends $Notifier<MeState> {
  MeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MeState, MeState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MeState, MeState>, MeState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
