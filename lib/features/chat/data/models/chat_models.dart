// DTOs for `/app-api/infra/chat/*` responses (aligned with OpenAPI VO names).

class ChatMessageDto {
  ChatMessageDto({
    this.id,
    this.conversationId,
    this.senderId,
    this.type,
    this.content,
    this.extra,
    this.createTime,
  });

  final int? id;
  final int? conversationId;
  final int? senderId;
  final int? type;
  final String? content;
  final String? extra;
  final String? createTime;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    return ChatMessageDto(
      id: (json['id'] as num?)?.toInt(),
      conversationId: (json['conversationId'] as num?)?.toInt(),
      senderId: (json['senderId'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      content: json['content'] as String?,
      extra: json['extra'] as String?,
      createTime: json['createTime'] as String?,
    );
  }

  DateTime? get createTimeParsed {
    final raw = createTime;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}

class ChatConversationSourceType {
  static const int normal = 0;
  static const int square = 1;
  static const int product = 2;
}

class ChatConversationDto {
  ChatConversationDto({
    this.id,
    this.type,
    this.name,
    this.avatar,
    this.peerUserId,
    this.lastMessageSummary,
    this.lastMessageTime,
    this.unreadCount,
    this.muted,
    this.pinned,
    this.memberCount,
    this.creatorId,
    this.joinMode,
    this.sourceType,
    this.updateTime,
    this.isAi = false,
  });

  /// IM 单聊
  static const int typeSingle = 1;

  /// IM 群聊
  static const int typeGroup = 2;

  /// AI 助手会话（App 消息列表合成项，非 infra chat）
  static const int typeAi = 3;

  final int? id;
  final int? type;
  final String? name;
  final String? avatar;
  final int? peerUserId;
  final String? lastMessageSummary;
  final String? lastMessageTime;
  final int? unreadCount;
  final bool? muted;
  final bool? pinned;
  final int? memberCount;
  final int? creatorId;
  final int? joinMode;
  final int? sourceType;
  final String? updateTime;
  final bool isAi;

  factory ChatConversationDto.fromJson(Map<String, dynamic> json) {
    return ChatConversationDto(
      id: (json['id'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      peerUserId: (json['peerUserId'] as num?)?.toInt(),
      lastMessageSummary: json['lastMessageSummary'] as String?,
      lastMessageTime: json['lastMessageTime'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      muted: json['muted'] as bool?,
      pinned: json['pinned'] as bool?,
      memberCount: (json['memberCount'] as num?)?.toInt(),
      creatorId: (json['creatorId'] as num?)?.toInt(),
      joinMode: (json['joinMode'] as num?)?.toInt(),
      sourceType: (json['sourceType'] as num?)?.toInt(),
      updateTime: json['updateTime'] as String?,
      isAi: false,
    );
  }

  /// 将 AI 助手会话映射为消息列表项
  factory ChatConversationDto.fromAiAssistant({
    required int id,
    required String title,
    bool? pinned,
    String? model,
    String? createTime,
  }) {
    return ChatConversationDto(
      id: id,
      type: typeAi,
      name: title,
      pinned: pinned,
      lastMessageSummary: model == null || model.isEmpty ? 'AI 助手' : model,
      lastMessageTime: createTime,
      updateTime: createTime,
      unreadCount: 0,
      muted: false,
      isAi: true,
    );
  }

  ChatConversationDto copyWith({
    String? name,
    String? avatar,
    int? unreadCount,
    bool? muted,
    bool? pinned,
    int? memberCount,
    bool? isAi,
  }) {
    return ChatConversationDto(
      id: id,
      type: type,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      peerUserId: peerUserId,
      lastMessageSummary: lastMessageSummary,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      muted: muted ?? this.muted,
      pinned: pinned ?? this.pinned,
      memberCount: memberCount ?? this.memberCount,
      creatorId: creatorId,
      joinMode: joinMode,
      sourceType: sourceType,
      updateTime: updateTime,
      isAi: isAi ?? this.isAi,
    );
  }

  bool get isGroup => type == typeGroup;

  bool get isSingle => type == typeSingle;

  String get displayTitle =>
      (name != null && name!.isNotEmpty) ? name! : '会话 ${id ?? ''}';

  /// 消息列表左上角来源标记文案（广场 / 商品 / AI）。
  String? get listSourceBadge {
    if (isAi) return 'AI';
    if (sourceType == ChatConversationSourceType.product) return '商品';
    if (sourceType == ChatConversationSourceType.square ||
        (isGroup && joinMode == 2)) {
      return '广场';
    }
    return null;
  }
}

class GroupInvitationPendingDto {
  GroupInvitationPendingDto({
    this.id,
    this.conversationId,
    this.groupName,
    this.groupAvatar,
    this.inviterUserId,
    this.inviterNickname,
    this.inviterAvatar,
    this.inviteeUserId,
    this.inviteeNickname,
    this.inviteeAvatar,
    this.createTime,
  });

  final int? id;
  final int? conversationId;
  final String? groupName;
  final String? groupAvatar;
  final int? inviterUserId;
  final String? inviterNickname;
  final String? inviterAvatar;
  final int? inviteeUserId;
  final String? inviteeNickname;
  final String? inviteeAvatar;
  final String? createTime;

  factory GroupInvitationPendingDto.fromJson(Map<String, dynamic> json) {
    return GroupInvitationPendingDto(
      id: (json['id'] as num?)?.toInt(),
      conversationId: (json['conversationId'] as num?)?.toInt(),
      groupName: json['groupName'] as String?,
      groupAvatar: json['groupAvatar'] as String?,
      inviterUserId: (json['inviterUserId'] as num?)?.toInt(),
      inviterNickname: json['inviterNickname'] as String?,
      inviterAvatar: json['inviterAvatar'] as String?,
      inviteeUserId: (json['inviteeUserId'] as num?)?.toInt(),
      inviteeNickname: json['inviteeNickname'] as String?,
      inviteeAvatar: json['inviteeAvatar'] as String?,
      createTime: json['createTime'] as String?,
    );
  }

  String get inviterDisplayName =>
      (inviterNickname != null && inviterNickname!.trim().isNotEmpty)
          ? inviterNickname!.trim()
          : '用户 ${inviterUserId ?? ''}';

  String get inviteeDisplayName =>
      (inviteeNickname != null && inviteeNickname!.trim().isNotEmpty)
          ? inviteeNickname!.trim()
          : '用户 ${inviteeUserId ?? ''}';

  String get groupDisplayName =>
      (groupName != null && groupName!.trim().isNotEmpty)
          ? groupName!.trim()
          : '群聊';
}

class ChatGroupMemberDto {
  ChatGroupMemberDto({
    this.userId,
    this.displayName,
    this.nickname,
    this.avatar,
  });

  final int? userId;
  final String? displayName;
  final String? nickname;
  final String? avatar;

  factory ChatGroupMemberDto.fromJson(Map<String, dynamic> json) {
    return ChatGroupMemberDto(
      userId: (json['userId'] as num?)?.toInt(),
      displayName: json['displayName'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  String get label {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final nick = nickname?.trim();
    if (nick != null && nick.isNotEmpty) return nick;
    return '用户 ${userId ?? ''}';
  }
}

class ChatMessagePageData {
  ChatMessagePageData({this.list, this.total});

  final List<ChatMessageDto>? list;
  final int? total;

  factory ChatMessagePageData.fromJson(Map<String, dynamic> json) {
    final rawList = json['list'] as List<dynamic>?;
    return ChatMessagePageData(
      list: rawList
          ?.map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );
  }
}
