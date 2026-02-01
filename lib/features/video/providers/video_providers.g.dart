// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoNotifier)
const videoProvider = VideoNotifierProvider._();

final class VideoNotifierProvider
    extends $NotifierProvider<VideoNotifier, VideoState> {
  const VideoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoNotifierHash();

  @$internal
  @override
  VideoNotifier create() => VideoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoState>(value),
    );
  }
}

String _$videoNotifierHash() => r'aae90d541b8f5def2d9e5375a00f54b87b68742d';

abstract class _$VideoNotifier extends $Notifier<VideoState> {
  VideoState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VideoState, VideoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VideoState, VideoState>,
              VideoState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
