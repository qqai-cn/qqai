// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_followers_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyFollowersNotifier)
const myFollowersProvider = MyFollowersNotifierProvider._();

final class MyFollowersNotifierProvider
    extends $NotifierProvider<MyFollowersNotifier, MyFollowersState> {
  const MyFollowersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myFollowersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myFollowersNotifierHash();

  @$internal
  @override
  MyFollowersNotifier create() => MyFollowersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyFollowersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyFollowersState>(value),
    );
  }
}

String _$myFollowersNotifierHash() =>
    r'44c72e407fe386fd810bd3f9d0617de58d1089be';

abstract class _$MyFollowersNotifier extends $Notifier<MyFollowersState> {
  MyFollowersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MyFollowersState, MyFollowersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyFollowersState, MyFollowersState>,
              MyFollowersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
