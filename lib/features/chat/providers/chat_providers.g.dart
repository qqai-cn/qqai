// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 单个会话详情（竖屏聊天页 AppBar 标题等）。

@ProviderFor(chatConversation)
const chatConversationProvider = ChatConversationFamily._();

/// 单个会话详情（竖屏聊天页 AppBar 标题等）。

final class ChatConversationProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChatConversationDto>,
          ChatConversationDto,
          FutureOr<ChatConversationDto>
        >
    with
        $FutureModifier<ChatConversationDto>,
        $FutureProvider<ChatConversationDto> {
  /// 单个会话详情（竖屏聊天页 AppBar 标题等）。
  const ChatConversationProvider._({
    required ChatConversationFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'chatConversationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatConversationHash();

  @override
  String toString() {
    return r'chatConversationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ChatConversationDto> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChatConversationDto> create(Ref ref) {
    final argument = this.argument as int;
    return chatConversation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatConversationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatConversationHash() => r'1d70941ab678ab3e137863d9aa5be9cc3f3d2709';

/// 单个会话详情（竖屏聊天页 AppBar 标题等）。

final class ChatConversationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ChatConversationDto>, int> {
  const ChatConversationFamily._()
    : super(
        retry: null,
        name: r'chatConversationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单个会话详情（竖屏聊天页 AppBar 标题等）。

  ChatConversationProvider call(int conversationId) =>
      ChatConversationProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'chatConversationProvider';
}

@ProviderFor(chatConversations)
const chatConversationsProvider = ChatConversationsProvider._();

final class ChatConversationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatConversationDto>>,
          List<ChatConversationDto>,
          FutureOr<List<ChatConversationDto>>
        >
    with
        $FutureModifier<List<ChatConversationDto>>,
        $FutureProvider<List<ChatConversationDto>> {
  const ChatConversationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatConversationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatConversationsHash();

  @$internal
  @override
  $FutureProviderElement<List<ChatConversationDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChatConversationDto>> create(Ref ref) {
    return chatConversations(ref);
  }
}

String _$chatConversationsHash() => r'e046db2a8722d41e9831f242a1202dee61f6d9e0';

@ProviderFor(groupInvitationPendingIncoming)
const groupInvitationPendingIncomingProvider =
    GroupInvitationPendingIncomingProvider._();

final class GroupInvitationPendingIncomingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroupInvitationPendingDto>>,
          List<GroupInvitationPendingDto>,
          FutureOr<List<GroupInvitationPendingDto>>
        >
    with
        $FutureModifier<List<GroupInvitationPendingDto>>,
        $FutureProvider<List<GroupInvitationPendingDto>> {
  const GroupInvitationPendingIncomingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupInvitationPendingIncomingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupInvitationPendingIncomingHash();

  @$internal
  @override
  $FutureProviderElement<List<GroupInvitationPendingDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GroupInvitationPendingDto>> create(Ref ref) {
    return groupInvitationPendingIncoming(ref);
  }
}

String _$groupInvitationPendingIncomingHash() =>
    r'035ca17ccbd7580a1243c8432bf0165fd619249d';

@ProviderFor(groupInvitationPendingOutgoing)
const groupInvitationPendingOutgoingProvider =
    GroupInvitationPendingOutgoingProvider._();

final class GroupInvitationPendingOutgoingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroupInvitationPendingDto>>,
          List<GroupInvitationPendingDto>,
          FutureOr<List<GroupInvitationPendingDto>>
        >
    with
        $FutureModifier<List<GroupInvitationPendingDto>>,
        $FutureProvider<List<GroupInvitationPendingDto>> {
  const GroupInvitationPendingOutgoingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupInvitationPendingOutgoingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupInvitationPendingOutgoingHash();

  @$internal
  @override
  $FutureProviderElement<List<GroupInvitationPendingDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GroupInvitationPendingDto>> create(Ref ref) {
    return groupInvitationPendingOutgoing(ref);
  }
}

String _$groupInvitationPendingOutgoingHash() =>
    r'ea6ce4c494ec317403a85d63eebcb4eff2dbed77';

/// 底部「消息」Tab 未读：会话未读 + 待处理好友申请 + 待处理群邀请。

@ProviderFor(messageTabUnreadCount)
const messageTabUnreadCountProvider = MessageTabUnreadCountProvider._();

/// 底部「消息」Tab 未读：会话未读 + 待处理好友申请 + 待处理群邀请。

final class MessageTabUnreadCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 底部「消息」Tab 未读：会话未读 + 待处理好友申请 + 待处理群邀请。
  const MessageTabUnreadCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messageTabUnreadCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messageTabUnreadCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return messageTabUnreadCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$messageTabUnreadCountHash() =>
    r'4748b554ff2215fc8025983a35605119293791d2';
