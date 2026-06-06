// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
