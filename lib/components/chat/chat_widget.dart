import 'dart:async';

import 'package:cross_cache/cross_cache.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flyer_chat_file_message/flyer_chat_file_message.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:flyer_chat_system_message/flyer_chat_system_message.dart';
import 'package:qqai/components/chat/qqai_chat_text_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:qqai/components/chat/socketio_service.dart';
import 'package:qqai/constant/api_constant.dart';
import 'package:qqai/features/chat/data/chat_message_mapper.dart';
import 'package:qqai/features/chat/data/models/chat_models.dart';
import 'package:qqai/features/chat/data/repos/chat_repo.dart';
import 'package:uuid/uuid.dart';

import 'chat_api_service.dart';
import 'connection_status.dart';
import 'create_message.dart';
import 'upload_file.dart';
import 'widgets/composer_action_bar.dart';

class ChatWidget extends ConsumerStatefulWidget {
  final UserID currentUserId;
  /// 业务会话 ID（与接口 `conversationId` 一致）
  final int conversationId;
  final List<Message> initialMessages;
  final Dio dio;
  /// 登录 token，用于 Socket.IO 连接鉴权
  final String? token;
  /// 是否连接 Socket.IO（默认关闭，仅走 HTTP 收发）
  final bool enableSocket;

  const ChatWidget({
    super.key,
    required this.currentUserId,
    required this.conversationId,
    required this.initialMessages,
    required this.dio,
    this.token,
    this.enableSocket = false,
  });

  @override
  ConsumerState<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends ConsumerState<ChatWidget> {
  final _crossCache = CrossCache();
  final _uuid = const Uuid();

  late final ChatApiService _apiService;
  SocketioService? _webSocketService;
  StreamSubscription<WebSocketEvent>? _webSocketSubscription;
  late final ChatController _chatController;
  final _systemUser = const User(id: 'system');
  late final User _meUser;
  final _defaultAvatar = 'https://file.qqai.cn/qqai/2025/09/1.webp';
  bool _isTyping = false;

  static const int _historyPageSize = 30;
  int _nextOlderPage = 2;
  bool _hasMoreOlder = true;
  bool _loadingOlder = false;
  bool _initialHistoryReady = false;

  @override
  void initState() {
    super.initState();
    _meUser = User(
      id: widget.currentUserId,
      imageSource: _defaultAvatar,
      name: '我',
    );
    _chatController = InMemoryChatController(messages: widget.initialMessages);
    final repo = ref.read(chatRepoProvider);
    _apiService = ChatApiService(
      repo: repo,
      conversationId: widget.conversationId,
    );
    if (widget.enableSocket) {
      _webSocketService = SocketioService(
        host: ApiConstant.BASE_URL,
        chatId: widget.conversationId.toString(),
        authorId: widget.currentUserId,
        token: widget.token,
      );
      _connectToWs();
    }
    Future.microtask(_loadInitialHistory);
  }

  @override
  void didUpdateWidget(covariant ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationId != widget.conversationId) {
      _nextOlderPage = 2;
      _hasMoreOlder = true;
      _loadingOlder = false;
      _initialHistoryReady = false;
      Future.microtask(_loadInitialHistory);
    }
  }

  List<Message> _messagesFromDtos(List<ChatMessageDto> dtos) {
    final messages = <Message>[];
    for (final dto in dtos) {
      final m = mapChatMessageDtoToMessage(dto);
      if (m != null) messages.add(m);
    }
    messages.sort(
      (a, b) => (a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .toUtc()
          .compareTo(
            (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)).toUtc(),
          ),
    );
    return messages;
  }

  List<Message> _mergeById(List<Message> a, List<Message> b) {
    final map = <String, Message>{};
    for (final m in a) {
      map[m.id] = m;
    }
    for (final m in b) {
      map[m.id] = m;
    }
    final out = map.values.toList();
    out.sort((x, y) {
      final tx = x.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final ty = y.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return tx.toUtc().compareTo(ty.toUtc());
    });
    return out;
  }

  Future<void> _loadInitialHistory() async {
    if (!mounted) return;
    _initialHistoryReady = false;
    _nextOlderPage = 2;
    _hasMoreOlder = true;
    try {
      final page = await ref.read(chatRepoProvider).getMessagePage(
            conversationId: widget.conversationId,
            pageNo: 1,
            pageSize: _historyPageSize,
          );
      final raw = [...?page.list];
      final messages = _messagesFromDtos(raw);
      if (mounted) {
        await _chatController.setMessages(messages);
        _hasMoreOlder = (page.list?.length ?? 0) >= _historyPageSize;
      }
    } catch (e) {
      debugPrint('chat history: $e');
    } finally {
      if (mounted) {
        _initialHistoryReady = true;
        setState(() {});
      }
    }
  }

  Future<void> _loadOlderHistory() async {
    if (!mounted || _loadingOlder || !_hasMoreOlder) return;
    _loadingOlder = true;
    try {
      final page = await ref.read(chatRepoProvider).getMessagePage(
            conversationId: widget.conversationId,
            pageNo: _nextOlderPage,
            pageSize: _historyPageSize,
          );
      final batch = [...?page.list];
      if (batch.isEmpty) {
        if (mounted) {
          _hasMoreOlder = false;
          setState(() {});
        }
        return;
      }
      final newMessages = _messagesFromDtos(batch);
      if (!mounted) return;
      final merged = _mergeById(_chatController.messages, newMessages);
      await _chatController.setMessages(merged);
      _nextOlderPage++;
      _hasMoreOlder = batch.length >= _historyPageSize;
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('chat older history: $e');
    } finally {
      if (mounted) _loadingOlder = false;
    }
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    _webSocketService?.dispose();
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
                  onEndReached: (_initialHistoryReady && _hasMoreOlder)
                      ? () async {
                          await _loadOlderHistory();
                        }
                      : null,
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
                // Web / 桌面键盘：Enter 发送，Shift+Enter 换行（库默认相反）
                sendOnEnter: kIsWeb,
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
                  }) => QqaiChatTextMessage(message: message, index: index),
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
                    final isCurrentUser = message.authorId == _meUser.id;
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
            currentUserId: _meUser.id,
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
              final same when same == _meUser.id => _meUser,
              'system' => _systemUser,
              _ => User(
                  id: id,
                  name: '用户 $id',
                  imageSource: _defaultAvatar,
                ),
            }),
            theme: theme.brightness == Brightness.dark
                ? ChatTheme.dark()
                : ChatTheme.light(),
          ),
          if (_webSocketService != null)
            Positioned(
              top: 16,
              left: 16,
              child: ConnectionStatus(webSocketService: _webSocketService!),
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
    final ws = _webSocketService;
    if (ws == null) return;
    _webSocketSubscription = ws.connect().listen((event) {
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
                      authorId: _meUser.id,
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
                      authorId: _meUser.id,
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
