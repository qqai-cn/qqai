// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SquareDetail)
const squareDetailProvider = SquareDetailFamily._();

final class SquareDetailProvider
    extends $AsyncNotifierProvider<SquareDetail, SquareItem> {
  const SquareDetailProvider._({
    required SquareDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'squareDetailProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$squareDetailHash();

  @override
  String toString() {
    return r'squareDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SquareDetail create() => SquareDetail();

  @override
  bool operator ==(Object other) {
    return other is SquareDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$squareDetailHash() => r'67106fe47b8b868291a96639fe70c7e53d5b4669';

final class SquareDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          SquareDetail,
          AsyncValue<SquareItem>,
          SquareItem,
          FutureOr<SquareItem>,
          int
        > {
  const SquareDetailFamily._()
    : super(
        retry: null,
        name: r'squareDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  SquareDetailProvider call(int squareId) =>
      SquareDetailProvider._(argument: squareId, from: this);

  @override
  String toString() => r'squareDetailProvider';
}

abstract class _$SquareDetail extends $AsyncNotifier<SquareItem> {
  late final _$args = ref.$arg as int;
  int get squareId => _$args;

  FutureOr<SquareItem> build(int squareId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<SquareItem>, SquareItem>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SquareItem>, SquareItem>,
              AsyncValue<SquareItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
