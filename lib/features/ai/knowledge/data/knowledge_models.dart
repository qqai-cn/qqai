/// DTOs for `/app-api/ai/knowledge/**`（对齐 LangChain4j / CMS 知识库）。

class KnowledgePageResult<T> {
  const KnowledgePageResult({required this.list, required this.total});

  final List<T> list;
  final int total;
}

class KnowledgeDto {
  KnowledgeDto({
    this.id,
    this.name,
    this.description,
    this.embeddingModelId,
    this.embeddingModel,
    this.topK,
    this.similarityThreshold,
    this.status,
    this.createTime,
  });

  final int? id;
  final String? name;
  final String? description;
  final int? embeddingModelId;
  final String? embeddingModel;
  final int? topK;
  final double? similarityThreshold;
  final int? status;
  final String? createTime;

  bool get enabled => status == 0;

  factory KnowledgeDto.fromJson(Map<String, dynamic> json) {
    return KnowledgeDto(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      embeddingModelId: (json['embeddingModelId'] as num?)?.toInt(),
      embeddingModel: json['embeddingModel'] as String?,
      topK: (json['topK'] as num?)?.toInt(),
      similarityThreshold: (json['similarityThreshold'] as num?)?.toDouble(),
      status: (json['status'] as num?)?.toInt(),
      createTime: json['createTime']?.toString(),
    );
  }
}

class KnowledgeDocumentDto {
  KnowledgeDocumentDto({
    this.id,
    this.knowledgeId,
    this.name,
    this.url,
    this.contentLength,
    this.tokens,
    this.segmentMaxTokens,
    this.retrievalCount,
    this.status,
    this.createTime,
  });

  final int? id;
  final int? knowledgeId;
  final String? name;
  final String? url;
  final int? contentLength;
  final int? tokens;
  final int? segmentMaxTokens;
  final int? retrievalCount;
  final int? status;
  final String? createTime;

  bool get enabled => status == 0;

  factory KnowledgeDocumentDto.fromJson(Map<String, dynamic> json) {
    return KnowledgeDocumentDto(
      id: (json['id'] as num?)?.toInt(),
      knowledgeId: (json['knowledgeId'] as num?)?.toInt(),
      name: json['name'] as String?,
      url: json['url'] as String?,
      contentLength: (json['contentLength'] as num?)?.toInt(),
      tokens: (json['tokens'] as num?)?.toInt(),
      segmentMaxTokens: (json['segmentMaxTokens'] as num?)?.toInt(),
      retrievalCount: (json['retrievalCount'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      createTime: json['createTime']?.toString(),
    );
  }
}

class KnowledgeSegmentDto {
  KnowledgeSegmentDto({
    this.id,
    this.documentId,
    this.knowledgeId,
    this.content,
    this.contentLength,
    this.tokens,
    this.retrievalCount,
    this.status,
    this.createTime,
  });

  final int? id;
  final int? documentId;
  final int? knowledgeId;
  final String? content;
  final int? contentLength;
  final int? tokens;
  final int? retrievalCount;
  final int? status;
  final String? createTime;

  bool get enabled => status == 0;

  factory KnowledgeSegmentDto.fromJson(Map<String, dynamic> json) {
    return KnowledgeSegmentDto(
      id: (json['id'] as num?)?.toInt(),
      documentId: (json['documentId'] as num?)?.toInt(),
      knowledgeId: (json['knowledgeId'] as num?)?.toInt(),
      content: json['content'] as String?,
      contentLength: (json['contentLength'] as num?)?.toInt(),
      tokens: (json['tokens'] as num?)?.toInt(),
      retrievalCount: (json['retrievalCount'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      createTime: json['createTime']?.toString(),
    );
  }
}

class KnowledgeSearchHitDto {
  KnowledgeSearchHitDto({
    this.id,
    this.knowledgeId,
    this.documentId,
    this.content,
  });

  final int? id;
  final int? knowledgeId;
  final int? documentId;
  final String? content;

  factory KnowledgeSearchHitDto.fromJson(Map<String, dynamic> json) {
    return KnowledgeSearchHitDto(
      id: (json['id'] as num?)?.toInt(),
      knowledgeId: (json['knowledgeId'] as num?)?.toInt(),
      documentId: (json['documentId'] as num?)?.toInt(),
      content: json['content'] as String?,
    );
  }
}
