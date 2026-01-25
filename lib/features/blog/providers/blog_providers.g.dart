// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BlogNotifier)
const blogProvider = BlogNotifierProvider._();

final class BlogNotifierProvider
    extends $NotifierProvider<BlogNotifier, BlogState> {
  const BlogNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blogNotifierHash();

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
}

String _$blogNotifierHash() => r'e43a064849e98c141febba638c468f837c093e4e';

abstract class _$BlogNotifier extends $Notifier<BlogState> {
  BlogState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
