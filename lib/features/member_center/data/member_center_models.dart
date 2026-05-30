class MemberCenterData {
  const MemberCenterData({
    required this.user,
    required this.levels,
    required this.signInSummary,
    required this.signInConfigs,
    required this.pointRecords,
    required this.experienceRecords,
  });

  final MemberUserInfo user;
  final List<MemberLevelInfo> levels;
  final MemberSignInSummary signInSummary;
  final List<MemberSignInConfig> signInConfigs;
  final List<MemberPointRecord> pointRecords;
  final List<MemberExperienceRecord> experienceRecords;

  MemberLevelInfo? get currentLevel {
    final userLevel = user.level?.level;
    if (userLevel == null) return null;
    for (final item in levels) {
      if (item.level == userLevel) return item;
    }
    return user.level;
  }

  MemberLevelInfo? get nextLevel {
    final current = currentLevel?.level ?? 0;
    final sorted = [...levels]..sort((a, b) => a.level.compareTo(b.level));
    for (final item in sorted) {
      if (item.level > current) return item;
    }
    return null;
  }

  double get levelProgress {
    final next = nextLevel;
    if (next == null || next.experience <= 0) return 1;
    return (user.experience / next.experience).clamp(0, 1).toDouble();
  }

  int get experienceToNext {
    final next = nextLevel;
    if (next == null) return 0;
    return (next.experience - user.experience).clamp(0, next.experience);
  }
}

class MemberUserInfo {
  const MemberUserInfo({
    this.id,
    this.nickname,
    this.avatar,
    this.mobile,
    this.point = 0,
    this.experience = 0,
    this.level,
    this.brokerageEnabled = false,
  });

  final int? id;
  final String? nickname;
  final String? avatar;
  final String? mobile;
  final int point;
  final int experience;
  final MemberLevelInfo? level;
  final bool brokerageEnabled;

  factory MemberUserInfo.fromJson(Map<String, dynamic> json) {
    final rawLevel = json['level'];
    return MemberUserInfo(
      id: (json['id'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      mobile: json['mobile'] as String?,
      point: (json['point'] as num?)?.toInt() ?? 0,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      level: rawLevel is Map<String, dynamic>
          ? MemberLevelInfo.fromJson(rawLevel)
          : null,
      brokerageEnabled: json['brokerageEnabled'] == true,
    );
  }
}

class MemberLevelInfo {
  const MemberLevelInfo({
    this.name,
    this.icon,
    this.backgroundUrl,
    this.discountPercent,
    this.experience = 0,
    this.level = 0,
  });

  final String? name;
  final String? icon;
  final String? backgroundUrl;
  final int? discountPercent;
  final int experience;
  final int level;

  factory MemberLevelInfo.fromJson(Map<String, dynamic> json) {
    return MemberLevelInfo(
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      backgroundUrl: json['backgroundUrl'] as String?,
      discountPercent: (json['discountPercent'] as num?)?.toInt(),
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 0,
    );
  }
}

class MemberSignInSummary {
  const MemberSignInSummary({
    this.totalDay = 0,
    this.continuousDay = 0,
    this.todaySignIn = false,
  });

  final int totalDay;
  final int continuousDay;
  final bool todaySignIn;

  factory MemberSignInSummary.fromJson(Map<String, dynamic> json) {
    return MemberSignInSummary(
      totalDay: (json['totalDay'] as num?)?.toInt() ?? 0,
      continuousDay: (json['continuousDay'] as num?)?.toInt() ?? 0,
      todaySignIn: json['todaySignIn'] == true,
    );
  }
}

class MemberSignInConfig {
  const MemberSignInConfig({required this.day, required this.point});

  final int day;
  final int point;

  factory MemberSignInConfig.fromJson(Map<String, dynamic> json) {
    return MemberSignInConfig(
      day: (json['day'] as num?)?.toInt() ?? 0,
      point: (json['point'] as num?)?.toInt() ?? 0,
    );
  }
}

class MemberPointRecord {
  const MemberPointRecord({
    this.title,
    this.description,
    this.createTime,
    this.point = 0,
  });

  final String? title;
  final String? description;
  final String? createTime;
  final int point;

  factory MemberPointRecord.fromJson(Map<String, dynamic> json) {
    return MemberPointRecord(
      title: json['title'] as String?,
      description: json['description'] as String?,
      createTime: json['createTime']?.toString(),
      point: (json['point'] as num?)?.toInt() ?? 0,
    );
  }
}

class MemberExperienceRecord {
  const MemberExperienceRecord({
    this.title,
    this.description,
    this.createTime,
    this.experience = 0,
  });

  final String? title;
  final String? description;
  final String? createTime;
  final int experience;

  factory MemberExperienceRecord.fromJson(Map<String, dynamic> json) {
    return MemberExperienceRecord(
      title: json['title'] as String?,
      description: json['description'] as String?,
      createTime: json['createTime']?.toString(),
      experience: (json['experience'] as num?)?.toInt() ?? 0,
    );
  }
}
