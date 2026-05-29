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

class ChatConversationDto {
  ChatConversationDto({
    this.id,
    this.type,
    this.name,
    this.avatar,
    this.lastMessageSummary,
    this.lastMessageTime,
    this.unreadCount,
    this.muted,
    this.updateTime,
  });

  final int? id;
  final int? type;
  final String? name;
  final String? avatar;
  final String? lastMessageSummary;
  final String? lastMessageTime;
  final int? unreadCount;
  final bool? muted;
  final String? updateTime;

  factory ChatConversationDto.fromJson(Map<String, dynamic> json) {
    return ChatConversationDto(
      id: (json['id'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      lastMessageSummary: json['lastMessageSummary'] as String?,
      lastMessageTime: json['lastMessageTime'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      muted: json['muted'] as bool?,
      updateTime: json['updateTime'] as String?,
    );
  }

  ChatConversationDto copyWith({
    int? unreadCount,
    bool? muted,
  }) {
    return ChatConversationDto(
      id: id,
      type: type,
      name: name,
      avatar: avatar,
      lastMessageSummary: lastMessageSummary,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      muted: muted ?? this.muted,
      updateTime: updateTime,
    );
  }

  String get displayTitle =>
      (name != null && name!.isNotEmpty) ? name! : '会话 ${id ?? ''}';
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
