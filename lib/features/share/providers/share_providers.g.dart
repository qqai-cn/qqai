// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShareNotifier)
const shareProvider = ShareNotifierProvider._();

final class ShareNotifierProvider
    extends $NotifierProvider<ShareNotifier, ShareState> {
  const ShareNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareNotifierHash();

  @$internal
  @override
  ShareNotifier create() => ShareNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareState>(value),
    );
  }
}

String _$shareNotifierHash() => r'3cbf9f0aca1de4e1c64bbdf501ba6f6b1cf2359b';

abstract class _$ShareNotifier extends $Notifier<ShareState> {
  ShareState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ShareState, ShareState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShareState, ShareState>,
              ShareState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
