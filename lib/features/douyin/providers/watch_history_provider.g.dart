// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WatchHistory)
const watchHistoryProvider = WatchHistoryProvider._();

final class WatchHistoryProvider
    extends $NotifierProvider<WatchHistory, List<WatchHistoryItem>> {
  const WatchHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchHistoryHash();

  @$internal
  @override
  WatchHistory create() => WatchHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WatchHistoryItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WatchHistoryItem>>(value),
    );
  }
}

String _$watchHistoryHash() => r'07bd4933ae5a9049cb63dc9e24cebb05580f8fe1';

abstract class _$WatchHistory extends $Notifier<List<WatchHistoryItem>> {
  List<WatchHistoryItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<WatchHistoryItem>, List<WatchHistoryItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<WatchHistoryItem>, List<WatchHistoryItem>>,
              List<WatchHistoryItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
