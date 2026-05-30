// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_index_tab_navigate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeIndexTabNavigate)
const homeIndexTabNavigateProvider = HomeIndexTabNavigateProvider._();

final class HomeIndexTabNavigateProvider
    extends $NotifierProvider<HomeIndexTabNavigate, HomeIndexTabNavRequest> {
  const HomeIndexTabNavigateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeIndexTabNavigateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeIndexTabNavigateHash();

  @$internal
  @override
  HomeIndexTabNavigate create() => HomeIndexTabNavigate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeIndexTabNavRequest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeIndexTabNavRequest>(value),
    );
  }
}

String _$homeIndexTabNavigateHash() =>
    r'f6c2d87eac73b4dc228229c29280c30673c1d32f';

abstract class _$HomeIndexTabNavigate
    extends $Notifier<HomeIndexTabNavRequest> {
  HomeIndexTabNavRequest build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<HomeIndexTabNavRequest, HomeIndexTabNavRequest>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeIndexTabNavRequest, HomeIndexTabNavRequest>,
              HomeIndexTabNavRequest,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
