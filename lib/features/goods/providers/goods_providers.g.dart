// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoodsNotifier)
const goodsProvider = GoodsNotifierProvider._();

final class GoodsNotifierProvider
    extends $NotifierProvider<GoodsNotifier, GoodsState> {
  const GoodsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goodsNotifierHash();

  @$internal
  @override
  GoodsNotifier create() => GoodsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoodsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoodsState>(value),
    );
  }
}

String _$goodsNotifierHash() => r'2057f75e3c0effa442cc57d3b1354b829c86b1f5';

abstract class _$GoodsNotifier extends $Notifier<GoodsState> {
  GoodsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GoodsState, GoodsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GoodsState, GoodsState>,
              GoodsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
