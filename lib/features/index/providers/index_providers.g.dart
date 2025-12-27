// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IndexNotifier)
const indexProvider = IndexNotifierProvider._();

final class IndexNotifierProvider
    extends $NotifierProvider<IndexNotifier, IndexState> {
  const IndexNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'indexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$indexNotifierHash();

  @$internal
  @override
  IndexNotifier create() => IndexNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IndexState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IndexState>(value),
    );
  }
}

String _$indexNotifierHash() => r'99685077c8229d8b8f0d40fa45dcca3432b5b726';

abstract class _$IndexNotifier extends $Notifier<IndexState> {
  IndexState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IndexState, IndexState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IndexState, IndexState>,
              IndexState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
