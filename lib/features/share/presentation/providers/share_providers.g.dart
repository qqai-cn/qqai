// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShareNotifier)
const shareProvider = ShareNotifierFamily._();

final class ShareNotifierProvider
    extends $NotifierProvider<ShareNotifier, ShareState> {
  const ShareNotifierProvider._(
      {required ShareNotifierFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'shareProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$shareNotifierHash();

  @override
  String toString() {
    return r'shareProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is ShareNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shareNotifierHash() => r'45ed56c6d5cd79df3de43027a06017b2abcb0584';

final class ShareNotifierFamily extends $Family
    with
        $ClassFamilyOverride<ShareNotifier, ShareState, ShareState, ShareState,
            int> {
  const ShareNotifierFamily._()
      : super(
          retry: null,
          name: r'shareProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ShareNotifierProvider call(
    int category,
  ) =>
      ShareNotifierProvider._(argument: category, from: this);

  @override
  String toString() => r'shareProvider';
}

abstract class _$ShareNotifier extends $Notifier<ShareState> {
  late final _$args = ref.$arg as int;
  int get category => _$args;

  ShareState build(
    int category,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<ShareState, ShareState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ShareState, ShareState>, ShareState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
