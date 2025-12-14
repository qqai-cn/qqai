// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ToolNotifier)
const toolProvider = ToolNotifierProvider._();

final class ToolNotifierProvider
    extends $NotifierProvider<ToolNotifier, ToolState> {
  const ToolNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'toolProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$toolNotifierHash();

  @$internal
  @override
  ToolNotifier create() => ToolNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToolState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToolState>(value),
    );
  }
}

String _$toolNotifierHash() => r'3bbe5450543953d20a419980d6aabb3fc32a4e47';

abstract class _$ToolNotifier extends $Notifier<ToolState> {
  ToolState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ToolState, ToolState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ToolState, ToolState>, ToolState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
