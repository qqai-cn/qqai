// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabu_aixin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FabuAiXinNotifier)
const fabuAiXinProvider = FabuAiXinNotifierProvider._();

final class FabuAiXinNotifierProvider
    extends $NotifierProvider<FabuAiXinNotifier, FabuAiXinState> {
  const FabuAiXinNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fabuAiXinProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fabuAiXinNotifierHash();

  @$internal
  @override
  FabuAiXinNotifier create() => FabuAiXinNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FabuAiXinState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FabuAiXinState>(value),
    );
  }
}

String _$fabuAiXinNotifierHash() => r'6dabea270b12b25ed52657dcd829f4753e14c291';

abstract class _$FabuAiXinNotifier extends $Notifier<FabuAiXinState> {
  FabuAiXinState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FabuAiXinState, FabuAiXinState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FabuAiXinState, FabuAiXinState>,
              FabuAiXinState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
