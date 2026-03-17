import 'dart:async';

import 'package:cross_cache/cross_cache.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flyer_chat_file_message/flyer_chat_file_message.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:flyer_chat_system_message/flyer_chat_system_message.dart';
import 'package:flyer_chat_text_message/flyer_chat_text_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:qqai/components/chat/socketio_service.dart';
import 'package:uuid/uuid.dart';

import 'chat_api_service.dart';
import 'connection_status.dart';
import 'create_message.dart';
import 'upload_file.dart';
import 'widgets/composer_action_bar.dart';

const baseUrl = 'https://qqai.cn';
// Base origin for Socket.IO; path is configured in SocketioService
const host = 'https://qqai.cn';

class ChatWidget extends StatefulWidget {
  final UserID currentUserId;
  final String chatId;
  final List<Message> initialMessages;
  final Dio dio;
  /// 登录 token，用于 Socket.IO 连接鉴权
  final String? token;

  const ChatWidget({
    super.key,
    required this.currentUserId,
    required this.chatId,
    required this.initialMessages,
    required this.dio,
    this.token,
  });

  @override
  _ChatWidget createState() => _ChatWidget();
}

class _ChatWidget extends State<ChatWidget> {
  final _crossCache = CrossCache();
  final _uuid = const Uuid();

  late final ChatApiService _apiService;
  late final SocketioService _webSocketService;
  late final StreamSubscription<WebSocketEvent> _webSocketSubscription;
  late final ChatController _chatController;
  final _systemUser = const User(id: 'system');
  final _currentUser = const User(
    id: 'me',
    imageSource: 'https://file.qqai.cn/qqai/2025/09/1.webp',
    name: '马化腾',
  );
  final _recipient = const User(
    id: 'recipient',
    imageSource: 'https://file.qqai.cn/qqai/2025/09/1.webp',
    name: '马云',
  );
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController(messages: widget.initialMessages);
    _apiService = ChatApiService(
      baseUrl: baseUrl,
      chatId: widget.chatId,
      dio: widget.dio,
    );
    _webSocketService = SocketioService(
      host: host,
      chatId: widget.chatId,
      authorId: widget.currentUserId,
      token: widget.token,
    );
    _connectToWs();
  }

  @override
  void dispose() {
    _webSocketSubscription.cancel();
    _webSocketService.dispose();
    _chatController.dispose();
    _crossCache.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // appBar: AppBar(title: const Text('Api')),
      body: Stack(
        children: [
          Chat(
            builders: Builders(
              chatAnimatedListBuilder: (context, itemBuilder) {
                return ChatAnimatedList(
                  itemBuilder: itemBuilder,
                  insertAnimationDurationResolver: (message) {
                    if (message is SystemMessage) return Duration.zero;
                    return null;
                  },
                );
              },
              customMessageBuilder:
                  (
                    context,
                    message,
                    index, {
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? ChatColors.dark().surfaceContainer
                          : ChatColors.light().surfaceContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: IsTypingIndicator(),
                  ),
              imageMessageBuilder:
                  (
                    context,
                    message,
                    index, {
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) => FlyerChatImageMessage(message: message, index: index),
              systemMessageBuilder:
                  (
                    context,
                    message,
                    index, {
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) => FlyerChatSystemMessage(message: message, index: index),
              composerBuilder: (context) => Composer(
                topWidget: ComposerActionBar(
                  buttons: [
                    ComposerActionButton(
                      icon: Icons.type_specimen,
                      title: '输入中...',
                      onPressed: () => _toggleTyping(),
                    ),
                    ComposerActionButton(
                      icon: Icons.shuffle,
                      title: '随机发送',
                      onPressed: () => _addItem('sasasa'),
                    ),
                    ComposerActionButton(
                      icon: Icons.delete_sweep,
                      title: '清除',
                      onPressed: () => _chatController.setMessages([]),
                      destructive: true,
                    ),
                  ],
                ),
              ),
              linkPreviewBuilder: (context, message, isSentByMe) {
                return LinkPreview(
                  text: message.text,
                  linkPreviewData: message.linkPreviewData,
                  onLinkPreviewDataFetched: (linkPreviewData) {
                    _chatController.updateMessage(
                      message,
                      message.copyWith(linkPreviewData: linkPreviewData),
                    );
                  },
                );
              },
              textMessageBuilder:
                  (
                    context,
                    message,
                    index, {
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) => FlyerChatTextMessage(message: message, index: index),
              fileMessageBuilder:
                  (
                    context,
                    message,
                    index, {
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) => FlyerChatFileMessage(message: message, index: index),
              chatMessageBuilder:
                  (
                    context,
                    message,
                    index,
                    animation,
                    child, {
                    bool? isRemoved,
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) {
                    final isSystemMessage = message.authorId == 'system';
                    final isFirstInGroup = groupStatus?.isFirst ?? true;
                    final isLastInGroup = groupStatus?.isLast ?? true;
                    final shouldShowAvatar =
                        !isSystemMessage && isLastInGroup && isRemoved != true;
                    final isCurrentUser = message.authorId == _currentUser.id;
                    final shouldShowUsername =
                        !isSystemMessage && isFirstInGroup && isRemoved != true;

                    Widget? avatar;
                    if (shouldShowAvatar) {
                      avatar = Padding(
                        padding: EdgeInsets.only(
                          left: isCurrentUser ? 8 : 0,
                          right: isCurrentUser ? 0 : 8,
                        ),
                        child: Avatar(userId: message.authorId),
                      );
                    } else if (!isSystemMessage) {
                      avatar = const SizedBox(width: 40);
                    }

                    return ChatMessage(
                      message: message,
                      index: index,
                      animation: animation,
                      isRemoved: isRemoved,
                      groupStatus: groupStatus,
                      topWidget: shouldShowUsername
                          ? Padding(
                              padding: EdgeInsets.only(
                                bottom: 4,
                                left: isCurrentUser ? 0 : 48,
                                right: isCurrentUser ? 48 : 0,
                              ),
                              child: Username(userId: message.authorId),
                            )
                          : null,
                      leadingWidget: !isCurrentUser
                          ? avatar
                          : isSystemMessage
                          ? null
                          : const SizedBox(width: 40),
                      trailingWidget: isCurrentUser
                          ? avatar
                          : isSystemMessage
                          ? null
                          : const SizedBox(width: 40),
                      receivedMessageScaleAnimationAlignment:
                          (message is SystemMessage)
                          ? Alignment.center
                          : Alignment.centerLeft,
                      receivedMessageAlignment: (message is SystemMessage)
                          ? AlignmentDirectional.center
                          : AlignmentDirectional.centerStart,
                      horizontalPadding: (message is SystemMessage) ? 0 : 8,
                      child: child,
                    );
                  },
            ),
            chatController: _chatController,
            crossCache: _crossCache,
            currentUserId: _currentUser.id,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? ChatColors.dark().surface
                  : ChatColors.light().surface,
              image: DecorationImage(
                image: AssetImage('imgs/defbak.png'),
                repeat: ImageRepeat.repeat,
                colorFilter: ColorFilter.mode(
                  theme.brightness == Brightness.dark
                      ? ChatColors.dark().surfaceContainerLow
                      : ChatColors.light().surfaceContainerLow,
                  BlendMode.srcIn,
                ),
              ),
            ),
            onAttachmentTap: _handleAttachmentTap,
            onMessageSend: _addItem,
            // onMessageTap: _removeItem1,
            onMessageLongPress: _handleMessageLongPress,
            resolveUser: (id) => Future.value(switch (id) {
              'me' => _currentUser,
              'recipient' => _recipient,
              'system' => _systemUser,
              _ => null,
            }),
            theme: theme.brightness == Brightness.dark
                ? ChatTheme.dark()
                : ChatTheme.light(),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: ConnectionStatus(webSocketService: _webSocketService),
          ),
        ],
      ),
    );
  }

  void _handleMessageLongPress(
    BuildContext context,
    Message message, {
    int? index,
    LongPressStartDetails? details,
  }) async {
    // Skip showing menu for system messages
    if (message.authorId == 'system' || details == null) return;

    // Calculate position for the menu
    final position = details.globalPosition;

    // Create a Rect for the menu position (small area around tap point)
    final menuRect = Rect.fromCenter(
      center: position,
      width: 0, // Width and height of 0 means show exactly at the point
      height: 0,
    );

    final items = [
      if (message is TextMessage)
        PullDownMenuItem(
          title: '复制',
          icon: CupertinoIcons.doc_on_doc,
          onTap: () {
            _copyMessage(message);
          },
        ),
      PullDownMenuItem(
        title: '删除',
        icon: CupertinoIcons.delete,
        isDestructive: true,
        onTap: () {
          _removeItem(message);
        },
      ),
    ];

    await showPullDownMenu(context: context, position: menuRect, items: items);
  }

  void _copyMessage(TextMessage message) async {
    await Clipboard.setData(ClipboardData(text: message.text));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied: ${message.text}')));
  }

  Future<void> _toggleTyping() async {
    if (!_isTyping) {
      await _chatController.insertMessage(
        CustomMessage(
          id: _uuid.v4(),
          authorId: _systemUser.id,
          metadata: {'type': 'typing'},
          createdAt: DateTime.now().toUtc(),
        ),
      );
      _isTyping = true;
    } else {
      try {
        final typingMessage = _chatController.messages.firstWhere(
          (message) => message.metadata?['type'] == 'typing',
        );

        await _chatController.removeMessage(typingMessage);
        _isTyping = false;
      } catch (e) {
        _isTyping = false;
        await _toggleTyping();
      }
    }
  }

  void _connectToWs() {
    _webSocketSubscription = _webSocketService.connect().listen((event) {
      if (!mounted) return;

      switch (event.type) {
        case WebSocketEventType.newMessage:
          _chatController.insertMessage(event.message!);
          break;
        case WebSocketEventType.deleteMessage:
          _chatController.removeMessage(event.message!);
          break;
        case WebSocketEventType.flush:
          _chatController.setMessages([]);
          break;
        case WebSocketEventType.error:
          _showInfo('Error: ${event.error}');
          break;
        case WebSocketEventType.unknown:
          break;
      }
    });
  }

  void _addItem(String? text) async {
    final message = await createMessage(
      widget.currentUserId,
      widget.dio,
      text: text,
    );
    final originalMetadata = message.metadata;

    if (mounted) {
      await _chatController.insertMessage(
        message.copyWith(metadata: {...?originalMetadata, 'sending': true}),
      );
    }

    try {
      final response = await _apiService.send(message);

      if (mounted) {
        // Make sure to get the updated message
        // (width and height might have been set by the image message widget)
        final currentMessage = _chatController.messages.firstWhere(
          (element) => element.id == message.id,
          orElse: () => message,
        );
        final nextMessage = currentMessage.copyWith(
          id: response['id'],
          createdAt: null,
          sentAt: DateTime.fromMillisecondsSinceEpoch(
            response['ts'],
            isUtc: true,
          ),
          metadata: originalMetadata,
        );
        await _chatController.updateMessage(currentMessage, nextMessage);
      }
    } catch (error) {
      debugPrint('Error sending message: $error');
    }
  }

  void _handleAttachmentTap() async {
    await showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Image'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (image != null) {
                    final imageMessage = ImageMessage(
                      id: _uuid.v4(),
                      authorId: _currentUser.id,
                      createdAt: DateTime.now().toUtc(),
                      sentAt: DateTime.now().toUtc(),
                      source: image.path,
                    );

                    await _chatController.insertMessage(imageMessage);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_present),
                title: const Text('File'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await FilePicker.platform.pickFiles(
                    withData: false,
                    withReadStream: false,
                  );

                  if (result != null && result.files.isNotEmpty) {
                    final file = result.files.first;
                    final filePath = file.path!;
                    final fileName = file.name;
                    final fileSize = file.size;

                    // Create a proper file message
                    final fileMessage = FileMessage(
                      id: _uuid.v4(),
                      authorId: _currentUser.id,
                      createdAt: DateTime.now().toUtc(),
                      sentAt: DateTime.now().toUtc(),
                      source: filePath,
                      name: fileName,
                      size: fileSize,
                      mimeType: file.extension != null
                          ? 'application/${file.extension}'
                          : null,
                    );

                    await _chatController.insertMessage(fileMessage);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAttachmentTap1() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final bytes = await image.readAsBytes();
    // Saves image to persistent cache using image.path as key
    await _crossCache.set(image.path, bytes);

    final id = _uuid.v4();

    final imageMessage = ImageMessage(
      id: id,
      authorId: widget.currentUserId,
      createdAt: DateTime.now().toUtc(),
      source: image.path,
    );

    // Insert message to UI before uploading
    await _chatController.insertMessage(imageMessage);

    try {
      final response = await uploadFile(image.path, bytes, id, _chatController);

      if (mounted) {
        final blobId = response['blob_id'];

        // Make sure to get the updated message
        // (width and height might have been set by the image message widget)
        final currentMessage =
            _chatController.messages.firstWhere(
                  (element) => element.id == id,
                  orElse: () => imageMessage,
                )
                as ImageMessage;
        final originalMetadata = currentMessage.metadata;
        final nextMessage = currentMessage.copyWith(
          source: 'https://whatever.diamanthq.dev/blob/$blobId',
        );
        // Saves the same image to persistent cache using the new url as key
        // Alternatively, you could use updateKey to update the same content with a different key
        await _crossCache.set(nextMessage.source, bytes);
        await _chatController.updateMessage(
          currentMessage,
          nextMessage.copyWith(
            metadata: {...?originalMetadata, 'sending': true},
          ),
        );

        final newMessageResponse = await _apiService.send(nextMessage);

        if (mounted) {
          // Make sure to get the updated message
          // (width and height might have been set by the image message widget)
          final currentMessage2 = _chatController.messages.firstWhere(
            (element) => element.id == nextMessage.id,
            orElse: () => nextMessage,
          );
          final nextMessage2 = currentMessage2.copyWith(
            id: newMessageResponse['id'],
            createdAt: null,
            sentAt: DateTime.fromMillisecondsSinceEpoch(
              newMessageResponse['ts'],
              isUtc: true,
            ),
            metadata: originalMetadata,
          );
          await _chatController.updateMessage(currentMessage2, nextMessage2);
        }
      }
    } catch (error) {
      debugPrint('Error uploading/sending image message: $error');
    }
  }

  void _removeItem(Message item) async {
    await _chatController.removeMessage(item);
    if (_chatController.messages.length == 1) {
      await _chatController.removeMessage(_chatController.messages[0]);
    }
  }

  void _removeItem1(
    BuildContext context,
    Message item, {
    int? index,
    TapUpDetails? details,
  }) async {
    await _chatController.removeMessage(item);

    try {
      await _apiService.delete(item);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _showInfo(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
