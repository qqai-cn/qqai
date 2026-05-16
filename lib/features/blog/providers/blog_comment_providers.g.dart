// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_comment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BlogComments)
const blogCommentsProvider = BlogCommentsFamily._();

final class BlogCommentsProvider
    extends $NotifierProvider<BlogComments, BlogCommentFeedState> {
  const BlogCommentsProvider._({
    required BlogCommentsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'blogCommentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$blogCommentsHash();

  @override
  String toString() {
    return r'blogCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BlogComments create() => BlogComments();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlogCommentFeedState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlogCommentFeedState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BlogCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$blogCommentsHash() => r'401f7ad741f652b7a4d8389893fed78acc935161';

final class BlogCommentsFamily extends $Family
    with
        $ClassFamilyOverride<
          BlogComments,
          BlogCommentFeedState,
          BlogCommentFeedState,
          BlogCommentFeedState,
          int
        > {
  const BlogCommentsFamily._()
    : super(
        retry: null,
        name: r'blogCommentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BlogCommentsProvider call(int blogId) =>
      BlogCommentsProvider._(argument: blogId, from: this);

  @override
  String toString() => r'blogCommentsProvider';
}

abstract class _$BlogComments extends $Notifier<BlogCommentFeedState> {
  late final _$args = ref.$arg as int;
  int get blogId => _$args;

  BlogCommentFeedState build(int blogId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<BlogCommentFeedState, BlogCommentFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BlogCommentFeedState, BlogCommentFeedState>,
              BlogCommentFeedState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
