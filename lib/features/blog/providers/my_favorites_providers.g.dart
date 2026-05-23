// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_favorites_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyFavoritesNotifier)
const myFavoritesProvider = MyFavoritesNotifierProvider._();

final class MyFavoritesNotifierProvider
    extends $NotifierProvider<MyFavoritesNotifier, MyFavoritesState> {
  const MyFavoritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myFavoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myFavoritesNotifierHash();

  @$internal
  @override
  MyFavoritesNotifier create() => MyFavoritesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyFavoritesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyFavoritesState>(value),
    );
  }
}

String _$myFavoritesNotifierHash() =>
    r'cd98020702c795e881e7d4401aa23bc5036cfa10';

abstract class _$MyFavoritesNotifier extends $Notifier<MyFavoritesState> {
  MyFavoritesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MyFavoritesState, MyFavoritesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyFavoritesState, MyFavoritesState>,
              MyFavoritesState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
