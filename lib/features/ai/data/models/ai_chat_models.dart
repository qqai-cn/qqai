/// DTOs for `/app-api/ai/chat/**`（对齐后管 / LangChain4j VO）。

class AiChatConversationDto {
  AiChatConversationDto({
    this.id,
    this.userId,
    this.title,
    this.pinned,
    this.roleId,
    this.modelId,
    this.model,
    this.systemMessage,
    this.temperature,
    this.maxTokens,
    this.maxContexts,
    this.assistant,
    this.defaultAssistant,
    this.avatar,
    this.createTime,
  });

  final int? id;
  final int? userId;
  final String? title;
  final bool? pinned;
  final int? roleId;
  final int? modelId;
  final String? model;
  final String? systemMessage;
  final double? temperature;
  final int? maxTokens;
  final int? maxContexts;
  final bool? assistant;
  final bool? defaultAssistant;
  final String? avatar;
  final String? createTime;

  bool get isDefaultAssistant =>
      defaultAssistant == true || title == kDefaultAiAssistantTitle;

  factory AiChatConversationDto.fromJson(Map<String, dynamic> json) {
    return AiChatConversationDto(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      title: json['title'] as String?,
      pinned: json['pinned'] as bool?,
      roleId: (json['roleId'] as num?)?.toInt(),
      modelId: (json['modelId'] as num?)?.toInt(),
      model: json['model'] as String?,
      systemMessage: json['systemMessage'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxTokens: (json['maxTokens'] as num?)?.toInt(),
      maxContexts: (json['maxContexts'] as num?)?.toInt(),
      assistant: json['assistant'] as bool?,
      defaultAssistant: json['defaultAssistant'] as bool?,
      avatar: json['avatar'] as String?,
      createTime: json['createTime']?.toString(),
    );
  }

  DateTime? get createTimeParsed {
    final raw = createTime;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}

class AiChatMessageDto {
  AiChatMessageDto({
    this.id,
    this.conversationId,
    this.replyId,
    this.type,
    this.userId,
    this.roleId,
    this.model,
    this.modelId,
    this.content,
    this.reasoningContent,
    this.useContext,
    this.createTime,
  });

  final int? id;
  final int? conversationId;
  final int? replyId;
  final String? type;
  final int? userId;
  final int? roleId;
  final String? model;
  final int? modelId;
  final String? content;
  final String? reasoningContent;
  final bool? useContext;
  final String? createTime;

  static const String typeUser = 'user';
  static const String typeAssistant = 'assistant';
  static const String typeSystem = 'system';

  bool get isUser => type == typeUser;
  bool get isAssistant => type == typeAssistant;

  AiChatMessageDto copyWith({
    int? id,
    int? conversationId,
    int? replyId,
    String? type,
    int? userId,
    int? roleId,
    String? model,
    int? modelId,
    String? content,
    String? reasoningContent,
    bool? useContext,
    String? createTime,
  }) {
    return AiChatMessageDto(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      replyId: replyId ?? this.replyId,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      model: model ?? this.model,
      modelId: modelId ?? this.modelId,
      content: content ?? this.content,
      reasoningContent: reasoningContent ?? this.reasoningContent,
      useContext: useContext ?? this.useContext,
      createTime: createTime ?? this.createTime,
    );
  }

  factory AiChatMessageDto.fromJson(Map<String, dynamic> json) {
    return AiChatMessageDto(
      id: (json['id'] as num?)?.toInt(),
      conversationId: (json['conversationId'] as num?)?.toInt(),
      replyId: (json['replyId'] as num?)?.toInt(),
      type: json['type'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      roleId: (json['roleId'] as num?)?.toInt(),
      model: json['model'] as String?,
      modelId: (json['modelId'] as num?)?.toInt(),
      content: json['content'] as String?,
      reasoningContent: json['reasoningContent'] as String?,
      useContext: json['useContext'] as bool?,
      createTime: json['createTime']?.toString(),
    );
  }
}

class AiChatSendChunk {
  AiChatSendChunk({this.send, this.receive, this.code, this.msg});

  final AiChatMessageDto? send;
  final AiChatMessageDto? receive;
  final int? code;
  final String? msg;

  bool get isOk => code == null || code == 0;

  factory AiChatSendChunk.fromEnvelope(Map<String, dynamic> root) {
    final code = (root['code'] as num?)?.toInt();
    final msg = root['msg']?.toString();
    final data = root['data'];
    if (data is! Map) {
      return AiChatSendChunk(code: code, msg: msg);
    }
    final map = Map<String, dynamic>.from(data);
    return AiChatSendChunk(
      code: code,
      msg: msg,
      send: map['send'] is Map
          ? AiChatMessageDto.fromJson(Map<String, dynamic>.from(map['send'] as Map))
          : null,
      receive: map['receive'] is Map
          ? AiChatMessageDto.fromJson(
              Map<String, dynamic>.from(map['receive'] as Map),
            )
          : null,
    );
  }
}

class AiModelSimpleDto {
  AiModelSimpleDto({
    this.id,
    this.name,
    this.model,
    this.platform,
    this.type,
    this.temperature,
    this.maxTokens,
    this.maxContexts,
  });

  final int? id;
  final String? name;
  final String? model;
  final String? platform;
  final int? type;
  final double? temperature;
  final int? maxTokens;
  final int? maxContexts;

  factory AiModelSimpleDto.fromJson(Map<String, dynamic> json) {
    return AiModelSimpleDto(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      model: json['model'] as String?,
      platform: json['platform'] as String?,
      type: (json['type'] as num?)?.toInt(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxTokens: (json['maxTokens'] as num?)?.toInt(),
      maxContexts: (json['maxContexts'] as num?)?.toInt(),
    );
  }
}

/// 默认 AI 好友名称（与后端一致）
const String kDefaultAiAssistantTitle = '千千AI助手';
