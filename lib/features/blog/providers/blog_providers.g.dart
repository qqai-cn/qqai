// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BlogNotifier)
const blogProvider = BlogNotifierFamily._();

final class BlogNotifierProvider
    extends $NotifierProvider<BlogNotifier, BlogState> {
  const BlogNotifierProvider._({
    required BlogNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'blogProvider',
         isAutoDispose: false,
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlogState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BlogNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$blogNotifierHash() => r'3040c516ffdbc2fa995edd07aaa9f6127da7d5f1';

final class BlogNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          BlogNotifier,
          BlogState,
          BlogState,
          BlogState,
          int
        > {
  const BlogNotifierFamily._()
    : super(
        retry: null,
        name: r'blogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  BlogNotifierProvider call(int category) =>
      BlogNotifierProvider._(argument: category, from: this);

  @override
  String toString() => r'blogProvider';
}

abstract class _$BlogNotifier extends $Notifier<BlogState> {
  late final _$args = ref.$arg as int;
  int get category => _$args;

  BlogState build(int category);
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
