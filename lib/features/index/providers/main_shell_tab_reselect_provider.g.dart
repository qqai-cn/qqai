// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_shell_tab_reselect_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 底部主壳 Tab（首页 / 影视 / 消息 / 我的）重复点击时递增，子页通过 [ref.listen] 触发刷新。

@ProviderFor(MainShellTabReselect)
const mainShellTabReselectProvider = MainShellTabReselectFamily._();

/// 底部主壳 Tab（首页 / 影视 / 消息 / 我的）重复点击时递增，子页通过 [ref.listen] 触发刷新。
final class MainShellTabReselectProvider
    extends $NotifierProvider<MainShellTabReselect, int> {
  /// 底部主壳 Tab（首页 / 影视 / 消息 / 我的）重复点击时递增，子页通过 [ref.listen] 触发刷新。
  const MainShellTabReselectProvider._({
    required MainShellTabReselectFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'mainShellTabReselectProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mainShellTabReselectHash();

  @override
  String toString() {
    return r'mainShellTabReselectProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MainShellTabReselect create() => MainShellTabReselect();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MainShellTabReselectProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mainShellTabReselectHash() =>
    r'a54410d052db584ca1298e5511964aeb8d17560e';

/// 底部主壳 Tab（首页 / 影视 / 消息 / 我的）重复点击时递增，子页通过 [ref.listen] 触发刷新。

final class MainShellTabReselectFamily extends $Family
    with $ClassFamilyOverride<MainShellTabReselect, int, int, int, int> {
  const MainShellTabReselectFamily._()
    : super(
        retry: null,
        name: r'mainShellTabReselectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 底部主壳 Tab（首页 / 影视 / 消息 / 我的）重复点击时递增，子页通过 [ref.listen] 触发刷新。

  MainShellTabReselectProvider call(int branchIndex) =>
      MainShellTabReselectProvider._(argument: branchIndex, from: this);

  @override
  String toString() => r'mainShellTabReselectProvider';
}

/// 底部主壳 Tab（首页 / 影视 / 消息 / 我的）重复点击时递增，子页通过 [ref.listen] 触发刷新。

abstract class _$MainShellTabReselect extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get branchIndex => _$args;

  int build(int branchIndex);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
