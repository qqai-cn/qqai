// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SquareNotifier)
const squareProvider = SquareNotifierProvider._();

final class SquareNotifierProvider
    extends $NotifierProvider<SquareNotifier, SquareState> {
  const SquareNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'squareProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$squareNotifierHash();

  @$internal
  @override
  SquareNotifier create() => SquareNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SquareState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SquareState>(value),
    );
  }
}

String _$squareNotifierHash() => r'2261d3f39f65ce2c8f93d3841bc6f5a0bc568038';

abstract class _$SquareNotifier extends $Notifier<SquareState> {
  SquareState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SquareState, SquareState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SquareState, SquareState>,
              SquareState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
