import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import 'knowledge_models.dart';

final knowledgeRepoProvider = Provider<KnowledgeRepo>((ref) => KnowledgeRepo());

class KnowledgeRepo {
  Future<KnowledgePageResult<KnowledgeDto>> page({
    String? name,
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_PAGE,
      RequestType.get,
      queryParameters: {
        'pageNo': pageNo,
        'pageSize': pageSize,
        if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      },
    );
    return _page(root, KnowledgeDto.fromJson);
  }

  Future<KnowledgeDto> get(int id) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_GET,
      RequestType.get,
      queryParameters: {'id': id},
    );
    return KnowledgeDto.fromJson(_asMap(root['data']));
  }

  Future<int> create({
    required String name,
    String? description,
    int? topK,
    double? similarityThreshold,
    int? status,
  }) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_CREATE,
      RequestType.post,
      data: _saveBody(
        name: name,
        description: description,
        topK: topK,
        similarityThreshold: similarityThreshold,
        status: status,
      ),
    );
    return _id(root);
  }

  Future<void> update({
    required int id,
    required String name,
    String? description,
    int? topK,
    double? similarityThreshold,
    int? status,
  }) async {
    await _envelope(
      ApiConstant.AI_KNOWLEDGE_UPDATE,
      RequestType.put,
      data: _saveBody(
        id: id,
        name: name,
        description: description,
        topK: topK,
        similarityThreshold: similarityThreshold,
        status: status,
      ),
    );
  }

  Future<void> delete(int id) async {
    await _envelope(
      ApiConstant.AI_KNOWLEDGE_DELETE,
      RequestType.delete,
      queryParameters: {'id': id},
    );
  }

  Future<int> createChat(int knowledgeId) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_CREATE_CHAT,
      RequestType.post,
      queryParameters: {'id': knowledgeId},
    );
    return _id(root);
  }

  Future<KnowledgePageResult<KnowledgeDocumentDto>> documentPage({
    required int knowledgeId,
    String? name,
    int pageNo = 1,
    int pageSize = 50,
  }) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_DOCUMENT_PAGE,
      RequestType.get,
      queryParameters: {
        'knowledgeId': knowledgeId,
        'pageNo': pageNo,
        'pageSize': pageSize,
        if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      },
    );
    return _page(root, KnowledgeDocumentDto.fromJson);
  }

  Future<int> createDocument({
    required int knowledgeId,
    required String name,
    required String url,
    int? segmentMaxTokens,
  }) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_DOCUMENT_CREATE,
      RequestType.post,
      data: {
        'knowledgeId': knowledgeId,
        'name': name,
        'url': url,
        if (segmentMaxTokens != null) 'segmentMaxTokens': segmentMaxTokens,
      },
    );
    return _id(root);
  }

  Future<void> updateDocument({
    required int id,
    String? name,
    int? segmentMaxTokens,
  }) async {
    await _envelope(
      ApiConstant.AI_KNOWLEDGE_DOCUMENT_UPDATE,
      RequestType.put,
      data: {
        'id': id,
        if (name != null) 'name': name,
        if (segmentMaxTokens != null) 'segmentMaxTokens': segmentMaxTokens,
      },
    );
  }

  Future<void> updateDocumentStatus({required int id, required int status}) async {
    await _envelope(
      ApiConstant.AI_KNOWLEDGE_DOCUMENT_UPDATE_STATUS,
      RequestType.put,
      data: {'id': id, 'status': status},
    );
  }

  Future<void> deleteDocument(int id) async {
    await _envelope(
      ApiConstant.AI_KNOWLEDGE_DOCUMENT_DELETE,
      RequestType.delete,
      queryParameters: {'id': id},
    );
  }

  Future<KnowledgePageResult<KnowledgeSegmentDto>> segmentPage({
    required int documentId,
    String? content,
    int pageNo = 1,
    int pageSize = 50,
  }) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_SEGMENT_PAGE,
      RequestType.get,
      queryParameters: {
        'documentId': documentId,
        'pageNo': pageNo,
        'pageSize': pageSize,
        if (content != null && content.trim().isNotEmpty) 'content': content.trim(),
      },
    );
    return _page(root, KnowledgeSegmentDto.fromJson);
  }

  Future<int> createSegment({
    required int documentId,
    required String content,
  }) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_SEGMENT_CREATE,
      RequestType.post,
      data: {'documentId': documentId, 'content': content},
    );
    return _id(root);
  }

  Future<void> updateSegment({required int id, required String content}) async {
    await _envelope(
      ApiConstant.AI_KNOWLEDGE_SEGMENT_UPDATE,
      RequestType.put,
      data: {'id': id, 'content': content},
    );
  }

  Future<void> updateSegmentStatus({required int id, required int status}) async {
    await _envelope(
      ApiConstant.AI_KNOWLEDGE_SEGMENT_UPDATE_STATUS,
      RequestType.put,
      data: {'id': id, 'status': status},
    );
  }

  Future<void> deleteSegment(int id) async {
    await _envelope(
      ApiConstant.AI_KNOWLEDGE_SEGMENT_DELETE,
      RequestType.delete,
      queryParameters: {'id': id},
    );
  }

  Future<List<KnowledgeSearchHitDto>> search({
    required int knowledgeId,
    required String content,
    int? topK,
  }) async {
    final root = await _envelope(
      ApiConstant.AI_KNOWLEDGE_SEGMENT_SEARCH,
      RequestType.get,
      queryParameters: {
        'knowledgeId': knowledgeId,
        'content': content,
        if (topK != null) 'topK': topK,
      },
    );
    final data = root['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => KnowledgeSearchHitDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Map<String, dynamic> _saveBody({
    int? id,
    required String name,
    String? description,
    int? topK,
    double? similarityThreshold,
    int? status,
  }) {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (topK != null) 'topK': topK,
      if (similarityThreshold != null) 'similarityThreshold': similarityThreshold,
      if (status != null) 'status': status,
    };
  }

  static Future<Map<String, dynamic>> _envelope(
    String url,
    RequestType type, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      url,
      type,
      queryParameters: queryParameters,
      data: data,
    );
    final root = _asMap(response.data);
    final code = root['code'];
    if (code != null && code != 0) {
      throw Exception(root['msg']?.toString() ?? '业务错误');
    }
    return root;
  }

  static KnowledgePageResult<T> _page<T>(
    Map<String, dynamic> root,
    T Function(Map<String, dynamic>) parse,
  ) {
    final data = _asMap(root['data']);
    final rawList = data['list'];
    final list = rawList is List
        ? rawList
            .whereType<Map>()
            .map((e) => parse(Map<String, dynamic>.from(e)))
            .toList()
        : <T>[];
    return KnowledgePageResult(
      list: list,
      total: (data['total'] as num?)?.toInt() ?? list.length,
    );
  }

  static int _id(Map<String, dynamic> root) {
    final id = root['data'];
    if (id is num) return id.toInt();
    if (id is String) {
      final parsed = int.tryParse(id);
      if (parsed != null) return parsed;
    }
    if (id is Map) {
      final nested = id['id'];
      if (nested is num) return nested.toInt();
      if (nested is String) {
        final parsed = int.tryParse(nested);
        if (parsed != null) return parsed;
      }
    }
    throw Exception('操作失败');
  }

  static Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw Exception('响应格式错误');
  }
}
