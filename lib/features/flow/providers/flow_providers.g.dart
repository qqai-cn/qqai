// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FlowNotifier)
const flowProvider = FlowNotifierProvider._();

final class FlowNotifierProvider
    extends $NotifierProvider<FlowNotifier, FlowState> {
  const FlowNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flowNotifierHash();

  @$internal
  @override
  FlowNotifier create() => FlowNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlowState>(value),
    );
  }
}

String _$flowNotifierHash() => r'8356b2568efd4cd7ff036113f2e1c81790b1d12f';

abstract class _$FlowNotifier extends $Notifier<FlowState> {
  FlowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FlowState, FlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FlowState, FlowState>,
              FlowState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
