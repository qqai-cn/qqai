// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_shop_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myShopProfile)
const myShopProfileProvider = MyShopProfileProvider._();

final class MyShopProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<BlogShopResp?>,
          BlogShopResp?,
          FutureOr<BlogShopResp?>
        >
    with $FutureModifier<BlogShopResp?>, $FutureProvider<BlogShopResp?> {
  const MyShopProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myShopProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myShopProfileHash();

  @$internal
  @override
  $FutureProviderElement<BlogShopResp?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BlogShopResp?> create(Ref ref) {
    return myShopProfile(ref);
  }
}

String _$myShopProfileHash() => r'0566d1ef110949595354ce2969fd50798456dd10';
