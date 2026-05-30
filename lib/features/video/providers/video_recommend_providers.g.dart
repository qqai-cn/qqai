// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_recommend_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoRecommendNotifier)
const videoRecommendProvider = VideoRecommendNotifierProvider._();

final class VideoRecommendNotifierProvider
    extends $NotifierProvider<VideoRecommendNotifier, VideoRecommendState> {
  const VideoRecommendNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoRecommendProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoRecommendNotifierHash();

  @$internal
  @override
  VideoRecommendNotifier create() => VideoRecommendNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoRecommendState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoRecommendState>(value),
    );
  }
}

String _$videoRecommendNotifierHash() =>
    r'7fd86d5531ea03dcf6b63cf3b81c7bd030b124fb';

abstract class _$VideoRecommendNotifier extends $Notifier<VideoRecommendState> {
  VideoRecommendState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VideoRecommendState, VideoRecommendState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VideoRecommendState, VideoRecommendState>,
              VideoRecommendState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 影视 Tab「推荐」竖滑流当前播放条目（评论 / 相关推荐侧栏用）。

@ProviderFor(VideoRecommendCurrentBlog)
const videoRecommendCurrentBlogProvider = VideoRecommendCurrentBlogProvider._();

/// 影视 Tab「推荐」竖滑流当前播放条目（评论 / 相关推荐侧栏用）。
final class VideoRecommendCurrentBlogProvider
    extends $NotifierProvider<VideoRecommendCurrentBlog, BlogItem?> {
  /// 影视 Tab「推荐」竖滑流当前播放条目（评论 / 相关推荐侧栏用）。
  const VideoRecommendCurrentBlogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoRecommendCurrentBlogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoRecommendCurrentBlogHash();

  @$internal
  @override
  VideoRecommendCurrentBlog create() => VideoRecommendCurrentBlog();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlogItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlogItem?>(value),
    );
  }
}

String _$videoRecommendCurrentBlogHash() =>
    r'd224a2f162073344ac8e9a8b17ac4368d4552c56';

/// 影视 Tab「推荐」竖滑流当前播放条目（评论 / 相关推荐侧栏用）。

abstract class _$VideoRecommendCurrentBlog extends $Notifier<BlogItem?> {
  BlogItem? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BlogItem?, BlogItem?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BlogItem?, BlogItem?>,
              BlogItem?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
