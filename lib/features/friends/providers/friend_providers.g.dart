// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(friendPendingIncoming)
const friendPendingIncomingProvider = FriendPendingIncomingProvider._();

final class FriendPendingIncomingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FriendPendingDto>>,
          List<FriendPendingDto>,
          FutureOr<List<FriendPendingDto>>
        >
    with
        $FutureModifier<List<FriendPendingDto>>,
        $FutureProvider<List<FriendPendingDto>> {
  const FriendPendingIncomingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendPendingIncomingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendPendingIncomingHash();

  @$internal
  @override
  $FutureProviderElement<List<FriendPendingDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FriendPendingDto>> create(Ref ref) {
    return friendPendingIncoming(ref);
  }
}

String _$friendPendingIncomingHash() =>
    r'de06e3643782d641f3c39fc4679c7c97cbe27665';

@ProviderFor(friendPendingOutgoing)
const friendPendingOutgoingProvider = FriendPendingOutgoingProvider._();

final class FriendPendingOutgoingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FriendPendingDto>>,
          List<FriendPendingDto>,
          FutureOr<List<FriendPendingDto>>
        >
    with
        $FutureModifier<List<FriendPendingDto>>,
        $FutureProvider<List<FriendPendingDto>> {
  const FriendPendingOutgoingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendPendingOutgoingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendPendingOutgoingHash();

  @$internal
  @override
  $FutureProviderElement<List<FriendPendingDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FriendPendingDto>> create(Ref ref) {
    return friendPendingOutgoing(ref);
  }
}

String _$friendPendingOutgoingHash() =>
    r'8c81e3670882ae63315c0c0f650c5d61150a94fa';

@ProviderFor(friendListGrouped)
const friendListGroupedProvider = FriendListGroupedProvider._();

final class FriendListGroupedProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FriendLetterGroupDto>>,
          List<FriendLetterGroupDto>,
          FutureOr<List<FriendLetterGroupDto>>
        >
    with
        $FutureModifier<List<FriendLetterGroupDto>>,
        $FutureProvider<List<FriendLetterGroupDto>> {
  const FriendListGroupedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendListGroupedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendListGroupedHash();

  @$internal
  @override
  $FutureProviderElement<List<FriendLetterGroupDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FriendLetterGroupDto>> create(Ref ref) {
    return friendListGrouped(ref);
  }
}

String _$friendListGroupedHash() => r'0e00f5c818edddf2792fddb6613789b839c45c70';

/// 本地备注缓存（修改成功后写入，用于好友列表展示）

@ProviderFor(FriendRemarkCache)
const friendRemarkCacheProvider = FriendRemarkCacheProvider._();

/// 本地备注缓存（修改成功后写入，用于好友列表展示）
final class FriendRemarkCacheProvider
    extends $NotifierProvider<FriendRemarkCache, Map<int, String>> {
  /// 本地备注缓存（修改成功后写入，用于好友列表展示）
  const FriendRemarkCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendRemarkCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendRemarkCacheHash();

  @$internal
  @override
  FriendRemarkCache create() => FriendRemarkCache();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, String>>(value),
    );
  }
}

String _$friendRemarkCacheHash() => r'0f6ace52af274a45ef604c42b15519be3ef714b1';

/// 本地备注缓存（修改成功后写入，用于好友列表展示）

abstract class _$FriendRemarkCache extends $Notifier<Map<int, String>> {
  Map<int, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<int, String>, Map<int, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, String>, Map<int, String>>,
              Map<int, String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
