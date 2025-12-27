// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(blogRepo)
const blogRepoProvider = BlogRepoProvider._();

final class BlogRepoProvider
    extends $FunctionalProvider<BlogRepo, BlogRepo, BlogRepo>
    with $Provider<BlogRepo> {
  const BlogRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blogRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blogRepoHash();

  @$internal
  @override
  $ProviderElement<BlogRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BlogRepo create(Ref ref) {
    return blogRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlogRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlogRepo>(value),
    );
  }
}

String _$blogRepoHash() => r'ec8d33c2b7afd2d085d0e24e9f087c273b0fb066';

@ProviderFor(BlogNotifier)
const blogProvider = BlogNotifierFamily._();

final class BlogNotifierProvider
    extends $AsyncNotifierProvider<BlogNotifier, BlogState> {
  const BlogNotifierProvider._({
    required BlogNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'blogProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$blogNotifierHash();

  @override
  String toString() {
    return r'blogProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BlogNotifier create() => BlogNotifier();

  @override
  bool operator ==(Object other) {
    return other is BlogNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$blogNotifierHash() => r'7668a755842c9a75cce427742d2cb90035877adb';

final class BlogNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          BlogNotifier,
          AsyncValue<BlogState>,
          BlogState,
          FutureOr<BlogState>,
          int
        > {
  const BlogNotifierFamily._()
    : super(
        retry: null,
        name: r'blogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BlogNotifierProvider call(int category) =>
      BlogNotifierProvider._(argument: category, from: this);

  @override
  String toString() => r'blogProvider';
}

abstract class _$BlogNotifier extends $AsyncNotifier<BlogState> {
  late final _$args = ref.$arg as int;
  int get category => _$args;

  FutureOr<BlogState> build(int category);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<BlogState>, BlogState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BlogState>, BlogState>,
              AsyncValue<BlogState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
