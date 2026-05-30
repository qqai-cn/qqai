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
    extends $NotifierProvider<SquareNotifier, SquareListState> {
  const SquareNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'squareProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$squareNotifierHash();

  @$internal
  @override
  SquareNotifier create() => SquareNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SquareListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SquareListState>(value),
    );
  }
}

String _$squareNotifierHash() => r'8ba1ad8b7ba397815d5bfd73861ab1d9984495d2';

abstract class _$SquareNotifier extends $Notifier<SquareListState> {
  SquareListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SquareListState, SquareListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SquareListState, SquareListState>,
              SquareListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
