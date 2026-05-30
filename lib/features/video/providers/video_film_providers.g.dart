// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_film_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoFilmNotifier)
const videoFilmProvider = VideoFilmNotifierProvider._();

final class VideoFilmNotifierProvider
    extends $NotifierProvider<VideoFilmNotifier, VideoFilmState> {
  const VideoFilmNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoFilmProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoFilmNotifierHash();

  @$internal
  @override
  VideoFilmNotifier create() => VideoFilmNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoFilmState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoFilmState>(value),
    );
  }
}

String _$videoFilmNotifierHash() => r'a0436ed227db37769765ea2f3060484c9576fc55';

abstract class _$VideoFilmNotifier extends $Notifier<VideoFilmState> {
  VideoFilmState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VideoFilmState, VideoFilmState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VideoFilmState, VideoFilmState>,
              VideoFilmState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
