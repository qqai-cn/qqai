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
    r'feafcfbb9c63c28cfb17d6462527c91087583a21';

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
