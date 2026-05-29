// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_follows_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyFollowsNotifier)
const myFollowsProvider = MyFollowsNotifierProvider._();

final class MyFollowsNotifierProvider
    extends $NotifierProvider<MyFollowsNotifier, MyFollowsState> {
  const MyFollowsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myFollowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myFollowsNotifierHash();

  @$internal
  @override
  MyFollowsNotifier create() => MyFollowsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyFollowsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyFollowsState>(value),
    );
  }
}

String _$myFollowsNotifierHash() => r'421f5bce267694908d08cd95fd0676bf4290f593';

abstract class _$MyFollowsNotifier extends $Notifier<MyFollowsState> {
  MyFollowsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MyFollowsState, MyFollowsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyFollowsState, MyFollowsState>,
              MyFollowsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
