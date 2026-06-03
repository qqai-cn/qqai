import 'dart:async';
import 'dart:convert';

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
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:flyer_chat_system_message/flyer_chat_system_message.dart';
import 'package:qqai/components/chat/global_chat_socket_service.dart';
import 'package:qqai/components/chat/qqai_chat_file_message.dart';
import 'package:qqai/components/chat/qqai_chat_video_message.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/chat/qqai_chat_text_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:qqai/features/chat/data/chat_message_mapper.dart';
import 'package:qqai/features/chat/data/chat_message_extra.dart';
import 'package:qqai/features/chat/data/models/chat_models.dart';
import 'package:qqai/features/chat/data/repos/chat_repo.dart';
import 'package:qqai/features/chat/providers/chat_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:uuid/uuid.dart';

import 'chat_file_download.dart';
import 'chat_media_helper.dart';
import 'create_message.dart';
import 'widgets/chat_emoji_panel.dart';
import 'widgets/composer_action_bar.dart';

class ChatWidget extends ConsumerStatefulWidget {
  final UserID currentUserId;

  /// 业务会话 ID（与接口 `conversationId` 一致）
  final int conversationId;
  final List<Message> initialMessages;
  final Dio dio;

  /// 登录 token，由全局 Socket 服务使用。保留参数兼容现有调用方。
  final String? token;

  /// 是否订阅全局 Socket 消息（连接由 App 登录态统一管理）
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

  StreamSubscription<GlobalChatMessageEvent>? _socketMessageSubscription;
  late final ChatController _chatController;
  final _systemUser = const User(id: 'system');
  late final User _meUser;
  final _defaultAvatar = 'https://file.qqai.cn/qqai/2025/09/1.webp';
  final _composerController = TextEditingController();
  final _composerFocusNode = FocusNode();
  bool _showEmojiPanel = false;

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
    if (widget.enableSocket) {
      _connectToGlobalSocket();
    }
    _composerFocusNode.addListener(_onComposerFocusChange);
    Future.microtask(_loadInitialHistory);
  }

  void _onComposerFocusChange() {
    if (_composerFocusNode.hasFocus && _showEmojiPanel && mounted) {
      setState(() => _showEmojiPanel = false);
    }
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
      final page = await ref
          .read(chatRepoProvider)
          .getMessagePage(
            conversationId: widget.conversationId,
            pageNo: 1,
            pageSize: _historyPageSize,
          );
      final raw = [...?page.list];
      final messages = _messagesFromDtos(raw);
      if (mounted) {
        await _chatController.setMessages(messages);
        _hasMoreOlder = (page.list?.length ?? 0) >= _historyPageSize;
        await _markConversationRead(page.list);
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

  Future<void> _markConversationRead(List<ChatMessageDto>? messages) async {
    try {
      final latestId = messages
          ?.map((e) => e.id)
          .whereType<int>()
          .fold<int?>(
            null,
            (prev, id) => prev == null || id > prev ? id : prev,
          );
      await ref
          .read(chatRepoProvider)
          .markConversationRead(
            conversationId: widget.conversationId,
            messageId: latestId,
          );
      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      debugPrint('mark conversation read: $e');
    }
  }

  Future<void> _loadOlderHistory() async {
    if (!mounted || _loadingOlder || !_hasMoreOlder) return;
    _loadingOlder = true;
    try {
      final page = await ref
          .read(chatRepoProvider)
          .getMessagePage(
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
    _socketMessageSubscription?.cancel();
    _composerFocusNode.removeListener(_onComposerFocusChange);
    _composerController.dispose();
    _composerFocusNode.dispose();
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
                final list = ChatAnimatedList(
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
                if (!_showEmojiPanel) return list;
                return GestureDetector(
                  onTap: _exitEmojiPanel,
                  behavior: HitTestBehavior.translucent,
                  child: list,
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
                textEditingController: _composerController,
                focusNode: _composerFocusNode,
                hintText: '输入消息',
                // Web / 桌面键盘：Enter 发送，Shift+Enter 换行（库默认相反）
                sendOnEnter: kIsWeb,
                topWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showEmojiPanel)
                      ChatEmojiPanel(onEmojiSelected: _insertEmoji),
                    ComposerActionBar(
                      buttons: [
                        ComposerActionButton(
                          icon: _showEmojiPanel
                              ? Icons.keyboard_outlined
                              : Icons.emoji_emotions_outlined,
                          title: _showEmojiPanel ? '键盘' : '表情',
                          onPressed: _toggleEmojiPanel,
                        ),
                        ComposerActionButton(
                          icon: Icons.videocam_outlined,
                          title: '视频通话',
                          onPressed: _startVideoCall,
                        ),
                        ComposerActionButton(
                          icon: Icons.delete_sweep,
                          title: '清除',
                          onPressed: _confirmClearMessages,
                          destructive: true,
                        ),
                        ComposerActionButton(
                          icon: Icons.more_horiz,
                          title: '更多',
                          onPressed: () {
                            context.push(
                              '${Routes.chat}/${widget.conversationId}/settings',
                            );
                          },
                        ),
                      ],
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
                    BuildContext context,
                    FileMessage message,
                    int index, {
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) => QqaiChatFileMessage(message: message, index: index),
              videoMessageBuilder:
                  (
                    BuildContext context,
                    VideoMessage message,
                    int index, {
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) => QqaiChatVideoMessage(message: message, index: index),
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
            ),
            onAttachmentTap: _handleAttachmentTap,
            onMessageSend: _addItem,
            // onMessageTap: _removeItem1,
            onMessageLongPress: _handleMessageLongPress,
            resolveUser: (id) => Future.value(switch (id) {
              final same when same == _meUser.id => _meUser,
              'system' => _systemUser,
              _ => User(id: id, name: '用户 $id', imageSource: _defaultAvatar),
            }),
            theme: theme.brightness == Brightness.dark
                ? ChatTheme.dark()
                : ChatTheme.light(),
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
      if (message is FileMessage)
        PullDownMenuItem(
          title: '下载',
          icon: CupertinoIcons.arrow_down_circle,
          onTap: () async {
            try {
              await downloadChatFile(message);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已下载：${chatFileDisplayName(message)}')),
              );
            } catch (error) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('下载失败：$error')));
            }
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

  void _enterEmojiPanel() {
    setState(() => _showEmojiPanel = true);
    _composerFocusNode.unfocus();
  }

  void _exitEmojiPanel() {
    if (!_showEmojiPanel) return;
    setState(() => _showEmojiPanel = false);
    _composerFocusNode.requestFocus();
  }

  void _toggleEmojiPanel() {
    if (_showEmojiPanel) {
      _exitEmojiPanel();
    } else {
      _enterEmojiPanel();
    }
  }

  Future<void> _confirmClearMessages() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除消息'),
        content: const Text('确定要清空当前会话的所有消息吗？此操作仅影响本地展示。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('清除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _chatController.setMessages([]);
    }
  }

  void _insertEmoji(String emoji) {
    final controller = _composerController;
    final text = controller.text;
    final selection = controller.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final newText = text.replaceRange(start, end, emoji);
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + emoji.length),
      composing: TextRange.empty,
    );
  }

  void _connectToGlobalSocket() {
    final socket = ref.read(globalChatSocketServiceProvider);
    _socketMessageSubscription = socket.messageStream.listen((event) async {
      if (!mounted) return;
      if (event.dto.conversationId != widget.conversationId) return;
      final incoming = event.message;
      final serverTs =
          event.dto.createTimeParsed?.toUtc().millisecondsSinceEpoch ??
          DateTime.now().toUtc().millisecondsSinceEpoch;
      final incomingExtra = parseChatMessageExtra(event.dto.extra);
      final clientMessageId = incomingExtra?['clientMessageId']?.toString();
      if (event.dto.senderId?.toString() == widget.currentUserId &&
          clientMessageId != null &&
          clientMessageId.isNotEmpty) {
        final localMessage = _findMessageByClientMessageId(clientMessageId);
        if (localMessage != null) {
          await _chatController.updateMessage(
            localMessage,
            _withServerResponse(localMessage, {
              'id': event.dto.id?.toString() ?? incoming.id,
              'ts': serverTs,
            }, _cleanMetadata(localMessage.metadata)),
          );
          return;
        }
      }
      final exists = _chatController.messages.any((m) => m.id == incoming.id);
      if (!exists) {
        await _chatController.insertMessage(incoming);
      }
      if (event.dto.senderId?.toString() != widget.currentUserId) {
        unawaited(_markConversationRead([event.dto]));
      }
    });
  }

  Message? _findMessageByClientMessageId(String clientMessageId) {
    for (final message in _chatController.messages) {
      if (message.metadata?['clientMessageId']?.toString() == clientMessageId) {
        return message;
      }
    }
    return null;
  }

  Map<String, dynamic>? _cleanMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return null;
    final cleaned = Map<String, dynamic>.from(metadata)
      ..remove('sending')
      ..remove('clientMessageId');
    return cleaned.isEmpty ? null : cleaned;
  }

  int _messageType(Message message) {
    if (message is TextMessage) return 1;
    if (message is ImageMessage) return 2;
    if (message is FileMessage) return 4;
    if (message is VideoMessage) return 5;
    return 1;
  }

  String? _messageContent(Message message) {
    if (message is TextMessage) return message.text;
    if (message is ImageMessage) return message.source;
    if (message is FileMessage) return message.source;
    if (message is VideoMessage) return message.source;
    return null;
  }

  String _encodeSocketExtra(Message message, String clientMessageId) {
    final extra = parseChatMessageExtra(encodeMessageExtra(message));
    return jsonEncode({...?extra, 'clientMessageId': clientMessageId});
  }

  Future<void> _sendMessageBySocket(Message message) async {
    final clientMessageId =
        message.metadata?['clientMessageId']?.toString() ?? message.id;
    ref
        .read(globalChatSocketServiceProvider)
        .emitChatMessage(
          conversationId: widget.conversationId,
          type: _messageType(message),
          content: _messageContent(message),
          extra: _encodeSocketExtra(message, clientMessageId),
        );
  }

  void _addItem(String? text) async {
    final message = await createMessage(
      widget.currentUserId,
      widget.dio,
      text: text,
    );
    final clientMessageId = message.id;
    final originalMetadata = {
      ...?message.metadata,
      'clientMessageId': clientMessageId,
    };

    if (mounted) {
      await _chatController.insertMessage(
        message.copyWith(metadata: {...originalMetadata, 'sending': true}),
      );
    }

    try {
      await _sendMessageBySocket(message.copyWith(metadata: originalMetadata));
    } catch (error) {
      debugPrint('Error sending message: $error');
    }
  }

  Message _withServerResponse(
    Message message,
    Map<String, dynamic> response,
    Map<String, dynamic>? metadata,
  ) {
    final id = response['id']?.toString() ?? message.id;
    final sentAt = DateTime.fromMillisecondsSinceEpoch(
      (response['ts'] as num).toInt(),
      isUtc: true,
    );
    return switch (message) {
      TextMessage() => message.copyWith(
        id: id,
        createdAt: null,
        sentAt: sentAt,
        metadata: metadata,
      ),
      ImageMessage() => message.copyWith(
        id: id,
        createdAt: null,
        sentAt: sentAt,
        metadata: metadata,
      ),
      FileMessage() => message.copyWith(
        id: id,
        createdAt: null,
        sentAt: sentAt,
        metadata: metadata,
      ),
      VideoMessage() => message.copyWith(
        id: id,
        createdAt: null,
        sentAt: sentAt,
        metadata: metadata,
      ),
      _ => message.copyWith(
        id: id,
        createdAt: null,
        sentAt: sentAt,
        metadata: metadata,
      ),
    };
  }

  Future<void> _sendUploadedMessage({
    required Message localMessage,
    required Future<String> Function() upload,
    required Message Function(String url) onUploaded,
  }) async {
    final clientMessageId = localMessage.id;
    final originalMetadata = {
      ...?localMessage.metadata,
      'clientMessageId': clientMessageId,
      'sending': true,
    };
    await _chatController.insertMessage(
      localMessage.copyWith(metadata: originalMetadata),
    );
    try {
      final url = await upload();
      final uploadedMessage = onUploaded(url);
      final currentMessage = _chatController.messages.firstWhere(
        (element) => element.id == localMessage.id,
        orElse: () => localMessage,
      );
      await _chatController.updateMessage(currentMessage, uploadedMessage);
      await _sendMessageBySocket(
        uploadedMessage.copyWith(
          metadata: {
            ...?uploadedMessage.metadata,
            'clientMessageId': clientMessageId,
          },
        ),
      );
    } catch (error) {
      debugPrint('Error uploading/sending message: $error');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('发送失败: $error')));
      }
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
                title: const Text('图片'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image == null || !mounted) return;

                  final imageMessage = ImageMessage(
                    id: _uuid.v4(),
                    authorId: _meUser.id,
                    createdAt: DateTime.now().toUtc(),
                    source: image.path,
                  );
                  await _sendUploadedMessage(
                    localMessage: imageMessage,
                    upload: () => uploadChatFile(image),
                    onUploaded: (url) => imageMessage.copyWith(source: url),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('视频'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final video = await picker.pickVideo(
                    source: ImageSource.gallery,
                  );
                  if (video == null || !mounted) return;

                  final durationMs = await readVideoDurationMs(video);
                  final (width, height) = await readVideoSize(video);
                  final coverUrl = await generateAndUploadVideoCover(video);
                  final fileSize = await video.length();
                  final durationSec = durationMs > 0
                      ? (durationMs / 1000).round()
                      : null;
                  final metadata = <String, dynamic>{
                    ...durationSec != null
                        ? {'duration': durationSec}
                        : const <String, dynamic>{},
                    ...coverUrl != null
                        ? {'coverUrl': coverUrl}
                        : const <String, dynamic>{},
                  };

                  final videoMessage = VideoMessage(
                    id: _uuid.v4(),
                    authorId: _meUser.id,
                    createdAt: DateTime.now().toUtc(),
                    source: video.path,
                    width: width,
                    height: height,
                    size: fileSize,
                    name: video.name,
                    metadata: metadata,
                  );
                  await _sendUploadedMessage(
                    localMessage: videoMessage,
                    upload: () => uploadChatFile(video),
                    onUploaded: (url) => videoMessage.copyWith(source: url),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_present),
                title: const Text('文件'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await FilePicker.platform.pickFiles(
                    withData: false,
                    withReadStream: false,
                  );

                  if (result == null ||
                      result.files.isEmpty ||
                      result.files.first.path == null ||
                      !mounted) {
                    return;
                  }

                  final file = result.files.first;
                  final filePath = file.path!;
                  final fileName = file.name;
                  final fileSize = file.size;
                  final localFile = XFile(filePath, name: fileName);

                  final fileMessage = FileMessage(
                    id: _uuid.v4(),
                    authorId: _meUser.id,
                    createdAt: DateTime.now().toUtc(),
                    source: filePath,
                    name: fileName,
                    size: fileSize,
                    mimeType: file.extension != null
                        ? 'application/${file.extension}'
                        : null,
                  );
                  await _sendUploadedMessage(
                    localMessage: fileMessage,
                    upload: () => uploadChatFile(localFile),
                    onUploaded: (url) => fileMessage.copyWith(source: url),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startVideoCall() {
    _exitEmojiPanel();
    final callId =
        '${widget.conversationId}-${widget.currentUserId}-${DateTime.now().millisecondsSinceEpoch}';
    context.push(
      '${Routes.chat}/${widget.conversationId}/video-call'
      '?callId=$callId&caller=true',
    );
  }

  void _removeItem(Message item) async {
    await _chatController.removeMessage(item);
    if (_chatController.messages.length == 1) {
      await _chatController.removeMessage(_chatController.messages[0]);
    }
  }
}
