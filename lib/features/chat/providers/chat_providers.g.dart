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
