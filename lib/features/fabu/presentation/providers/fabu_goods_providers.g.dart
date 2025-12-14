// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabu_goods_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FabuGoodsNotifier)
const fabuGoodsProvider = FabuGoodsNotifierProvider._();

final class FabuGoodsNotifierProvider
    extends $NotifierProvider<FabuGoodsNotifier, FabuGoodsState> {
  const FabuGoodsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fabuGoodsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fabuGoodsNotifierHash();

  @$internal
  @override
  FabuGoodsNotifier create() => FabuGoodsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FabuGoodsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FabuGoodsState>(value),
    );
  }
}

String _$fabuGoodsNotifierHash() => r'96413ad801170c027b33d3234fa5b1a9c499d48f';

abstract class _$FabuGoodsNotifier extends $Notifier<FabuGoodsState> {
  FabuGoodsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FabuGoodsState, FabuGoodsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FabuGoodsState, FabuGoodsState>,
        FabuGoodsState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
