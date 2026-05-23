// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyNotifier)
const myProvider = MyNotifierProvider._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, MyState> {
  const MyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @$internal
  @override
  MyNotifier create() => MyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyState>(value),
    );
  }
}

String _$myNotifierHash() => r'9b6ecaff1c4d9d1e9e2a67e47cca2449362e4925';

abstract class _$MyNotifier extends $Notifier<MyState> {
  MyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MyState, MyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MyState, MyState>,
              MyState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
