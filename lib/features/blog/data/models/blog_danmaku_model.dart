class BlogDanmakuItem {
  const BlogDanmakuItem({
    required this.id,
    required this.blogId,
    required this.content,
    required this.positionMillis,
    this.userId,
    this.nickname,
    this.avatar,
    this.createTime,
  });

  final int id;
  final int blogId;
  final int? userId;
  final String? nickname;
  final String? avatar;
  final String content;
  final int positionMillis;
  final String? createTime;

  factory BlogDanmakuItem.fromJson(Map<String, dynamic> json) {
    return BlogDanmakuItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      blogId: (json['blogId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      content: (json['content'] ?? '').toString(),
      positionMillis: (json['positionMillis'] as num?)?.toInt() ?? 0,
      createTime: json['createTime'] as String?,
    );
  }
}
