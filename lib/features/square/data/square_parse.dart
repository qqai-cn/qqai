import 'models/square_model.dart';

SquarePageData parseSquarePageEnvelope(
  dynamic raw, {
  String errorMessage = '广场分页返回格式错误',
}) {
  if (raw is! Map<String, dynamic>) {
    throw errorMessage;
  }
  final code = raw['code'];
  if (code != null && code != 0 && code != '0') {
    throw raw['msg']?.toString() ?? '请求失败';
  }
  final inner = raw['data'];
  if (inner is! Map<String, dynamic>) {
    return const SquarePageData(list: [], total: 0);
  }
  return SquarePageData.fromJson(inner);
}

SquareItem parseSquareDetailEnvelope(
  dynamic raw, {
  String errorMessage = '广场详情返回格式错误',
}) {
  if (raw is! Map<String, dynamic>) {
    throw errorMessage;
  }
  final code = raw['code'];
  if (code != null && code != 0 && code != '0') {
    throw raw['msg']?.toString() ?? '请求失败';
  }
  final inner = raw['data'];
  if (inner is! Map<String, dynamic>) {
    throw errorMessage;
  }
  return SquareItem.fromJson(inner);
}

SquareConversationJoinResult parseSquareJoinConversationEnvelope(
  dynamic raw, {
  String errorMessage = '加入群聊返回格式错误',
}) {
  if (raw is! Map<String, dynamic>) {
    throw errorMessage;
  }
  final code = raw['code'];
  if (code != null && code != 0 && code != '0') {
    throw raw['msg']?.toString() ?? '请求失败';
  }
  final inner = raw['data'];
  if (inner is! Map<String, dynamic>) {
    throw errorMessage;
  }
  return SquareConversationJoinResult.fromJson(inner);
}

bool parseSquareBooleanEnvelope(
  dynamic raw, {
  String errorMessage = '更新广场失败',
}) {
  if (raw is! Map<String, dynamic>) {
    throw errorMessage;
  }
  final code = raw['code'];
  if (code != null && code != 0 && code != '0') {
    throw raw['msg']?.toString() ?? errorMessage;
  }
  if (raw['data'] != true) {
    throw raw['msg']?.toString() ?? errorMessage;
  }
  return true;
}

List<SquareItem> parseSquareListEnvelope(
  dynamic raw, {
  String errorMessage = '广场列表返回格式错误',
}) {
  if (raw is! Map<String, dynamic>) {
    throw errorMessage;
  }
  final code = raw['code'];
  if (code != null && code != 0 && code != '0') {
    throw raw['msg']?.toString() ?? '请求失败';
  }
  final inner = raw['data'];
  if (inner is! List) {
    return const [];
  }
  return inner
      .whereType<Map<String, dynamic>>()
      .map(SquareItem.fromJson)
      .toList();
}
