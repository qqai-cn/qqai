// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_play_queue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 影视 Tab 播放队列：用户通过「加入播放队列」追加的待播视频。

@ProviderFor(VideoPlayQueue)
const videoPlayQueueProvider = VideoPlayQueueProvider._();

/// 影视 Tab 播放队列：用户通过「加入播放队列」追加的待播视频。
final class VideoPlayQueueProvider
    extends $NotifierProvider<VideoPlayQueue, List<BlogItem>> {
  /// 影视 Tab 播放队列：用户通过「加入播放队列」追加的待播视频。
  const VideoPlayQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoPlayQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoPlayQueueHash();

  @$internal
  @override
  VideoPlayQueue create() => VideoPlayQueue();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BlogItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BlogItem>>(value),
    );
  }
}

String _$videoPlayQueueHash() => r'0b1639afbf33546afb2edddba1242796c7de9b8f';

/// 影视 Tab 播放队列：用户通过「加入播放队列」追加的待播视频。

abstract class _$VideoPlayQueue extends $Notifier<List<BlogItem>> {
  List<BlogItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<BlogItem>, List<BlogItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<BlogItem>, List<BlogItem>>,
              List<BlogItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
