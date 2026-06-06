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
    r'810161c786d08ab7f297c7cb550dd17d0d4bd8b6';

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

/// 影视壳内子 Tab：0 = 推荐，1 = 影视网格。

@ProviderFor(VideoSubTabIndex)
const videoSubTabIndexProvider = VideoSubTabIndexProvider._();

/// 影视壳内子 Tab：0 = 推荐，1 = 影视网格。
final class VideoSubTabIndexProvider
    extends $NotifierProvider<VideoSubTabIndex, int> {
  /// 影视壳内子 Tab：0 = 推荐，1 = 影视网格。
  const VideoSubTabIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoSubTabIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoSubTabIndexHash();

  @$internal
  @override
  VideoSubTabIndex create() => VideoSubTabIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$videoSubTabIndexHash() => r'0af55b03558691cb784726e26fc3cb4eceb02b20';

/// 影视壳内子 Tab：0 = 推荐，1 = 影视网格。

abstract class _$VideoSubTabIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
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
