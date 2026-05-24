import '../../../util/api_exceptions.dart';
import 'models/blog_page_model.dart';

String? _firstNonEmptyString(dynamic value) {
  if (value is! String) return null;
  final s = value.trim();
  return s.isEmpty ? null : s;
}

int? _firstPositiveInt(Map<String, dynamic> m, List<String> keys) {
  for (final key in keys) {
    final value = m[key];
    if (value is num && value > 0) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null && parsed > 0) return parsed;
    }
  }
  return null;
}

String _formatYuanFromCents(int cents) {
  if (cents % 100 == 0) return (cents ~/ 100).toString();
  return (cents / 100).toStringAsFixed(2);
}

/// 从条目或嵌套用户信息中解析作者头像。
String? _pickCreatorAvatar(Map<String, dynamic> m) {
  final direct = _firstNonEmptyString(m['creatorAvatar']);
  if (direct != null) return direct;

  for (final key in [
    'avatar',
    'avatarUrl',
    'userAvatar',
    'creator_avatar',
    'headImg',
    'headImgUrl',
  ]) {
    final v = _firstNonEmptyString(m[key]);
    if (v != null) return v;
  }

  for (final nestedKey in ['creatorUser', 'user', 'author', 'memberUser']) {
    final nested = m[nestedKey];
    if (nested is Map<String, dynamic>) {
      final v = _pickCreatorAvatar(nested);
      if (v != null) return v;
    }
  }
  return null;
}

/// 兼容接口可能使用的字段名。
Map<String, dynamic> normalizeBlogItemJson(Map<String, dynamic> json) {
  final m = Map<String, dynamic>.from(json);
  if (m['liked'] == null) {
    for (final key in ['isZan', 'zanByMe', 'isLike']) {
      if (m[key] != null) {
        m['liked'] = m[key];
        break;
      }
    }
  }
  if (m['collect'] == null) {
    for (final key in ['collected', 'isCollect', 'isFavorite', 'favorited']) {
      if (m[key] != null) {
        m['collect'] = m[key];
        break;
      }
    }
  }
  final avatar = _pickCreatorAvatar(m);
  if (avatar != null) {
    m['creatorAvatar'] = avatar;
  }
  if (m['creatorLevel'] == null) {
    for (final key in ['userLevel', 'vipLevel', 'memberLevel', 'level']) {
      final v = m[key];
      if (v is num) {
        m['creatorLevel'] = v.toInt();
        break;
      }
    }
  }
  if (m['creatorLevelName'] == null) {
    for (final key in ['levelName', 'userLevelName', 'vipLevelName']) {
      final v = _firstNonEmptyString(m[key]);
      if (v != null) {
        m['creatorLevelName'] = v;
        break;
      }
    }
  }
  if (m['collectCount'] == null) {
    for (final key in ['collectionCount', 'favoriteCount', 'starCount']) {
      final v = m[key];
      if (v is num) {
        m['collectCount'] = v.toInt();
        break;
      }
    }
  }
  if (m['shareCount'] == null) {
    for (final key in ['forwardCount', 'repostCount', 'shareNum']) {
      final v = m[key];
      if (v is num) {
        m['shareCount'] = v.toInt();
        break;
      }
    }
  }
  final rewardAmount = _firstPositiveInt(m, [
    'rewardAmount',
    'reward_amount',
    'bountyAmount',
    'helpRewardAmount',
  ]);
  if (rewardAmount != null) {
    final content = _firstNonEmptyString(m['content']) ?? '';
    if (!content.contains('悬赏金额：')) {
      final rewardLine = '悬赏金额：${_formatYuanFromCents(rewardAmount)}元';
      m['content'] = content.isEmpty ? rewardLine : '$content\n$rewardLine';
    }
  }
  return m;
}

BlogPageModelData parseBlogPageEnvelope(
  dynamic raw, {
  String errorMessage = '博客分页返回格式错误',
}) {
  if (raw is! Map<String, dynamic>) {
    throw errorMessage;
  }
  final code = raw['code'];
  if (code != null && code != 0 && code != '0') {
    final message = raw['msg']?.toString() ?? '请求失败';
    final codeInt = code is int ? code : int.tryParse(code.toString());
    if (codeInt == 401) {
      throw ApiBusinessException(code: 401, message: message);
    }
    throw message;
  }
  final inner = raw['data'];
  if (inner is! Map<String, dynamic>) {
    return const BlogPageModelData(list: [], total: 0);
  }
  final list = inner['list'];
  if (list is List) {
    final normalized = list.map((e) {
      if (e is Map<String, dynamic>) {
        return normalizeBlogItemJson(e);
      }
      return e;
    }).toList();
    return BlogPageModelData.fromJson({...inner, 'list': normalized});
  }
  return BlogPageModelData.fromJson(inner);
}
