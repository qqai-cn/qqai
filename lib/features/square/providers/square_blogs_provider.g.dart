// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_blogs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 单个广场下的公开博客瀑布流。

@ProviderFor(SquareBlogsNotifier)
const squareBlogsProvider = SquareBlogsNotifierFamily._();

/// 单个广场下的公开博客瀑布流。
final class SquareBlogsNotifierProvider
    extends $NotifierProvider<SquareBlogsNotifier, BlogState> {
  /// 单个广场下的公开博客瀑布流。
  const SquareBlogsNotifierProvider._({
    required SquareBlogsNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'squareBlogsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$squareBlogsNotifierHash();

  @override
  String toString() {
    return r'squareBlogsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SquareBlogsNotifier create() => SquareBlogsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlogState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SquareBlogsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$squareBlogsNotifierHash() =>
    r'852bc7115bf1ba4a033b7b5c51103724d9f029f1';

/// 单个广场下的公开博客瀑布流。

final class SquareBlogsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SquareBlogsNotifier,
          BlogState,
          BlogState,
          BlogState,
          int
        > {
  const SquareBlogsNotifierFamily._()
    : super(
        retry: null,
        name: r'squareBlogsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单个广场下的公开博客瀑布流。

  SquareBlogsNotifierProvider call(int squareId) =>
      SquareBlogsNotifierProvider._(argument: squareId, from: this);

  @override
  String toString() => r'squareBlogsProvider';
}

/// 单个广场下的公开博客瀑布流。

abstract class _$SquareBlogsNotifier extends $Notifier<BlogState> {
  late final _$args = ref.$arg as int;
  int get squareId => _$args;

  BlogState build(int squareId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<BlogState, BlogState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BlogState, BlogState>,
              BlogState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
