/// 收到的好友申请（待处理）
class FriendPendingDto {
  FriendPendingDto({
    this.id,
    this.relatedUserId,
    this.nickname,
    this.avatar,
    this.applyMessage,
    this.createTime,
  });

  final int? id;
  final int? relatedUserId;
  final String? nickname;
  final String? avatar;
  final String? applyMessage;
  final String? createTime;

  factory FriendPendingDto.fromJson(Map<String, dynamic> json) {
    return FriendPendingDto(
      id: (json['id'] as num?)?.toInt(),
      relatedUserId: (json['relatedUserId'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      applyMessage: json['applyMessage'] as String?,
      createTime: json['createTime'] as String?,
    );
  }

  String get displayName =>
      (nickname != null && nickname!.trim().isNotEmpty) ? nickname!.trim() : '用户 ${relatedUserId ?? ''}';
}

/// 通讯录分组（按首字母）
class FriendLetterGroupDto {
  FriendLetterGroupDto({this.letter, this.friends});

  final String? letter;
  final List<FriendGroupedUserDto>? friends;

  factory FriendLetterGroupDto.fromJson(Map<String, dynamic> json) {
    final raw = json['friends'];
    List<FriendGroupedUserDto>? list;
    if (raw is List) {
      list = raw
          .map(
            (e) => FriendGroupedUserDto.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    }
    return FriendLetterGroupDto(
      letter: json['letter'] as String?,
      friends: list,
    );
  }
}

/// 分组内好友
class FriendGroupedUserDto {
  FriendGroupedUserDto({
    this.id,
    this.friendUserId,
    this.displayName,
    this.nickname,
    this.avatar,
    this.remark,
    this.sortLetter,
  });

  final int? id;
  final int? friendUserId;
  final String? displayName;
  final String? nickname;
  final String? avatar;
  final String? remark;
  final String? sortLetter;

  factory FriendGroupedUserDto.fromJson(Map<String, dynamic> json) {
    return FriendGroupedUserDto(
      id: (json['id'] as num?)?.toInt(),
      friendUserId: (json['friendUserId'] as num?)?.toInt(),
      displayName: json['displayName'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      remark: json['remark'] as String?,
      sortLetter: json['sortLetter'] as String?,
    );
  }
}
