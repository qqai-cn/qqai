// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_follow_feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 首页「关注」Tab：所关注会员的公开作品流。

@ProviderFor(HomeFollowFeedNotifier)
const homeFollowFeedProvider = HomeFollowFeedNotifierProvider._();

/// 首页「关注」Tab：所关注会员的公开作品流。
final class HomeFollowFeedNotifierProvider
    extends $NotifierProvider<HomeFollowFeedNotifier, BlogState> {
  /// 首页「关注」Tab：所关注会员的公开作品流。
  const HomeFollowFeedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeFollowFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeFollowFeedNotifierHash();

  @$internal
  @override
  HomeFollowFeedNotifier create() => HomeFollowFeedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlogState>(value),
    );
  }
}

String _$homeFollowFeedNotifierHash() =>
    r'30ae30854c07d558f52f379f5de4f491d4e50012';

/// 首页「关注」Tab：所关注会员的公开作品流。

abstract class _$HomeFollowFeedNotifier extends $Notifier<BlogState> {
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
