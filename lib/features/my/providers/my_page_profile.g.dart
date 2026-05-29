// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_page_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myPageProfile)
const myPageProfileProvider = MyPageProfileProvider._();

final class MyPageProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<BlogMyPageResp>,
          BlogMyPageResp,
          FutureOr<BlogMyPageResp>
        >
    with $FutureModifier<BlogMyPageResp>, $FutureProvider<BlogMyPageResp> {
  const MyPageProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPageProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPageProfileHash();

  @$internal
  @override
  $FutureProviderElement<BlogMyPageResp> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BlogMyPageResp> create(Ref ref) {
    return myPageProfile(ref);
  }
}

String _$myPageProfileHash() => r'16f9242baafa84d296bc93eb390559f4c2a39f3c';
