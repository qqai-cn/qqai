// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HelpNotifier)
const helpProvider = HelpNotifierFamily._();

final class HelpNotifierProvider
    extends $NotifierProvider<HelpNotifier, HelpState> {
  const HelpNotifierProvider._(
      {required HelpNotifierFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'helpProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$helpNotifierHash();

  @override
  String toString() {
    return r'helpProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HelpNotifier create() => HelpNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HelpState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HelpState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HelpNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$helpNotifierHash() => r'c0237f6fe92f3858a0477e3c290e8378a4ea23b6';

final class HelpNotifierFamily extends $Family
    with
        $ClassFamilyOverride<HelpNotifier, HelpState, HelpState, HelpState,
            int> {
  const HelpNotifierFamily._()
      : super(
          retry: null,
          name: r'helpProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  HelpNotifierProvider call(
    int category,
  ) =>
      HelpNotifierProvider._(argument: category, from: this);

  @override
  String toString() => r'helpProvider';
}

abstract class _$HelpNotifier extends $Notifier<HelpState> {
  late final _$args = ref.$arg as int;
  int get category => _$args;

  HelpState build(
    int category,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<HelpState, HelpState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<HelpState, HelpState>, HelpState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
