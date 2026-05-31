// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_comments.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoodsComments)
const goodsCommentsProvider = GoodsCommentsFamily._();

final class GoodsCommentsProvider
    extends $AsyncNotifierProvider<GoodsComments, GoodsCommentsState> {
  const GoodsCommentsProvider._({
    required GoodsCommentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'goodsCommentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$goodsCommentsHash();

  @override
  String toString() {
    return r'goodsCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GoodsComments create() => GoodsComments();

  @override
  bool operator ==(Object other) {
    return other is GoodsCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$goodsCommentsHash() => r'db9926b080b225311e2e21e4500f56b5eb5e518a';

final class GoodsCommentsFamily extends $Family
    with
        $ClassFamilyOverride<
          GoodsComments,
          AsyncValue<GoodsCommentsState>,
          GoodsCommentsState,
          FutureOr<GoodsCommentsState>,
          String
        > {
  const GoodsCommentsFamily._()
    : super(
        retry: null,
        name: r'goodsCommentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GoodsCommentsProvider call(String goodsId) =>
      GoodsCommentsProvider._(argument: goodsId, from: this);

  @override
  String toString() => r'goodsCommentsProvider';
}

abstract class _$GoodsComments extends $AsyncNotifier<GoodsCommentsState> {
  late final _$args = ref.$arg as String;
  String get goodsId => _$args;

  FutureOr<GoodsCommentsState> build(String goodsId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<GoodsCommentsState>, GoodsCommentsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GoodsCommentsState>, GoodsCommentsState>,
              AsyncValue<GoodsCommentsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 当前用户对该商品可评价的订单项。

@ProviderFor(pendingGoodsCommentOrderItem)
const pendingGoodsCommentOrderItemProvider =
    PendingGoodsCommentOrderItemFamily._();

/// 当前用户对该商品可评价的订单项。

final class PendingGoodsCommentOrderItemProvider
    extends
        $FunctionalProvider<
          AsyncValue<TradeOrderItem?>,
          TradeOrderItem?,
          FutureOr<TradeOrderItem?>
        >
    with $FutureModifier<TradeOrderItem?>, $FutureProvider<TradeOrderItem?> {
  /// 当前用户对该商品可评价的订单项。
  const PendingGoodsCommentOrderItemProvider._({
    required PendingGoodsCommentOrderItemFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pendingGoodsCommentOrderItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingGoodsCommentOrderItemHash();

  @override
  String toString() {
    return r'pendingGoodsCommentOrderItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TradeOrderItem?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TradeOrderItem?> create(Ref ref) {
    final argument = this.argument as String;
    return pendingGoodsCommentOrderItem(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingGoodsCommentOrderItemProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingGoodsCommentOrderItemHash() =>
    r'293ee8dd527bd3d01da546946f7ebdd2b6599f42';

/// 当前用户对该商品可评价的订单项。

final class PendingGoodsCommentOrderItemFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TradeOrderItem?>, String> {
  const PendingGoodsCommentOrderItemFamily._()
    : super(
        retry: null,
        name: r'pendingGoodsCommentOrderItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 当前用户对该商品可评价的订单项。

  PendingGoodsCommentOrderItemProvider call(String goodsId) =>
      PendingGoodsCommentOrderItemProvider._(argument: goodsId, from: this);

  @override
  String toString() => r'pendingGoodsCommentOrderItemProvider';
}
