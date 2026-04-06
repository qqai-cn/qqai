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
    extends $NotifierProvider<GoodsComments, List<GoodsCommentItem>> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<GoodsCommentItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<GoodsCommentItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GoodsCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$goodsCommentsHash() => r'7230339b73f99da598ed9b96d5b6db09ada7dc0c';

final class GoodsCommentsFamily extends $Family
    with
        $ClassFamilyOverride<
          GoodsComments,
          List<GoodsCommentItem>,
          List<GoodsCommentItem>,
          List<GoodsCommentItem>,
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

abstract class _$GoodsComments extends $Notifier<List<GoodsCommentItem>> {
  late final _$args = ref.$arg as String;
  String get goodsId => _$args;

  List<GoodsCommentItem> build(String goodsId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<List<GoodsCommentItem>, List<GoodsCommentItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<GoodsCommentItem>, List<GoodsCommentItem>>,
              List<GoodsCommentItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
