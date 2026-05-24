// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabu_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FabuNotifier)
const fabuProvider = FabuNotifierProvider._();

final class FabuNotifierProvider
    extends $NotifierProvider<FabuNotifier, FabuState> {
  const FabuNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fabuProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fabuNotifierHash();

  @$internal
  @override
  FabuNotifier create() => FabuNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FabuState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FabuState>(value),
    );
  }
}

String _$fabuNotifierHash() => r'6aa5886f07425a8f9f7b23e1de07a499d99a026c';

abstract class _$FabuNotifier extends $Notifier<FabuState> {
  FabuState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FabuState, FabuState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FabuState, FabuState>,
              FabuState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
