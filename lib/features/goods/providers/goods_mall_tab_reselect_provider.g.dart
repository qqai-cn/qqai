// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_mall_tab_reselect_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 首页顶栏「商场」Tab 再次点击时递增，用于刷新列表并回到内嵌栈根页面。

@ProviderFor(GoodsMallTabReselect)
const goodsMallTabReselectProvider = GoodsMallTabReselectProvider._();

/// 首页顶栏「商场」Tab 再次点击时递增，用于刷新列表并回到内嵌栈根页面。
final class GoodsMallTabReselectProvider
    extends $NotifierProvider<GoodsMallTabReselect, int> {
  /// 首页顶栏「商场」Tab 再次点击时递增，用于刷新列表并回到内嵌栈根页面。
  const GoodsMallTabReselectProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goodsMallTabReselectProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goodsMallTabReselectHash();

  @$internal
  @override
  GoodsMallTabReselect create() => GoodsMallTabReselect();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$goodsMallTabReselectHash() =>
    r'e8508daebb8a6bb567ea5fac8861fd1479f3dafe';

/// 首页顶栏「商场」Tab 再次点击时递增，用于刷新列表并回到内嵌栈根页面。

abstract class _$GoodsMallTabReselect extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
