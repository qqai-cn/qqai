// 个人中心接口 VO（与 OpenAPI 字段对齐）

import '../../../blog/data/blog_page_parse.dart';
import '../../../blog/data/models/blog_page_model.dart';

class BlogMyPageResp {
  const BlogMyPageResp({
    this.id,
    this.nickname,
    this.avatar,
    this.backgroundUrl,
    this.intro,
    this.address,
    this.areaId,
    this.age,
    this.likeReceivedCount,
    this.mutualFollowCount,
    this.followingCount,
    this.followerCount,
    this.sex,
    this.birthday,
  });

  final int? id;
  final String? nickname;
  final String? avatar;
  final String? backgroundUrl;
  final String? intro;
  final String? address;
  final int? areaId;
  final int? age;
  final int? likeReceivedCount;
  final int? mutualFollowCount;
  final int? followingCount;
  final int? followerCount;
  final int? sex;
  final String? birthday;

  factory BlogMyPageResp.fromJson(Map<String, dynamic> json) {
    return BlogMyPageResp(
      id: (json['id'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      backgroundUrl: json['backgroundUrl'] as String?,
      intro: json['intro'] as String?,
      address: json['address'] as String?,
      areaId: (json['areaId'] as num?)?.toInt(),
      age: (json['age'] as num?)?.toInt(),
      likeReceivedCount: (json['likeReceivedCount'] as num?)?.toInt(),
      mutualFollowCount: (json['mutualFollowCount'] as num?)?.toInt(),
      followingCount: (json['followingCount'] as num?)?.toInt(),
      followerCount: (json['followerCount'] as num?)?.toInt(),
      sex: (json['sex'] as num?)?.toInt(),
      birthday: json['birthday'] as String?,
    );
  }
}

class BlogShopSaveReq {
  const BlogShopSaveReq({
    this.name,
    this.intro,
    this.coverUrl,
    required this.status,
  });

  final String? name;
  final String? intro;
  final String? coverUrl;
  final int status;

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (intro != null) 'intro': intro,
    if (coverUrl != null) 'coverUrl': coverUrl,
    'status': status,
  };
}

class MemberUserUpdateReq {
  const MemberUserUpdateReq({
    this.nickname,
    this.avatar,
    this.sex,
    this.birthday,
    this.areaId,
  });

  final String? nickname;
  final String? avatar;
  final int? sex;
  final String? birthday;
  final int? areaId;

  Map<String, dynamic> toJson() => {
    if (nickname != null) 'nickname': nickname,
    if (avatar != null) 'avatar': avatar,
    if (sex != null) 'sex': sex,
    if (birthday != null) 'birthday': birthday,
    if (areaId != null) 'areaId': areaId,
  };
}

class BlogShopResp {
  const BlogShopResp({
    this.id,
    this.userId,
    this.name,
    this.intro,
    this.coverUrl,
    this.status,
    this.productCount,
    this.createTime,
  });

  final int? id;
  final int? userId;
  final String? name;
  final String? intro;
  final String? coverUrl;

  /// 营业状态等业务含义由后端定义
  final int? status;
  final int? productCount;
  final String? createTime;

  factory BlogShopResp.fromJson(Map<String, dynamic> json) {
    return BlogShopResp(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String?,
      intro: json['intro'] as String?,
      coverUrl: json['coverUrl'] as String?,
      status: (json['status'] as num?)?.toInt(),
      productCount: (json['productCount'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
    );
  }
}

class BlogShopProductResp {
  const BlogShopProductResp({
    this.id,
    this.shopId,
    this.name,
    this.coverUrl,
    this.price,
    this.externalUrl,
    this.sort,
    this.status,
    this.createTime,
  });

  final int? id;
  final int? shopId;
  final String? name;
  final String? coverUrl;

  /// 售价（分）
  final int? price;
  final String? externalUrl;
  final int? sort;

  /// 1 上架 0 下架
  final int? status;
  final String? createTime;

  factory BlogShopProductResp.fromJson(Map<String, dynamic> json) {
    return BlogShopProductResp(
      id: (json['id'] as num?)?.toInt(),
      shopId: (json['shopId'] as num?)?.toInt(),
      name: json['name'] as String?,
      coverUrl: json['coverUrl'] as String?,
      price: (json['price'] as num?)?.toInt(),
      externalUrl: json['externalUrl'] as String?,
      sort: (json['sort'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
    );
  }
}

class BlogShopProductPageData {
  const BlogShopProductPageData({this.list, this.total});

  final List<BlogShopProductResp>? list;
  final int? total;

  factory BlogShopProductPageData.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>?;
    return BlogShopProductPageData(
      total: (json['total'] as num?)?.toInt(),
      list: raw
          ?.map((e) => BlogShopProductResp.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BlogCollectionResp {
  const BlogCollectionResp({
    this.id,
    this.userId,
    this.name,
    this.coverUrl,
    this.intro,
    this.visible,
    this.sort,
    this.itemCount,
    this.createTime,
  });

  final int? id;
  final int? userId;
  final String? name;
  final String? coverUrl;
  final String? intro;
  final int? visible;
  final int? sort;
  final int? itemCount;
  final String? createTime;

  factory BlogCollectionResp.fromJson(Map<String, dynamic> json) {
    return BlogCollectionResp(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String?,
      coverUrl: json['coverUrl'] as String?,
      intro: json['intro'] as String?,
      visible: (json['visible'] as num?)?.toInt(),
      sort: (json['sort'] as num?)?.toInt(),
      itemCount: (json['itemCount'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
    );
  }
}

class BlogCollectionPageData {
  const BlogCollectionPageData({this.list, this.total});

  final List<BlogCollectionResp>? list;
  final int? total;

  factory BlogCollectionPageData.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>?;
    return BlogCollectionPageData(
      total: (json['total'] as num?)?.toInt(),
      list: raw
          ?.map((e) => BlogCollectionResp.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BlogCollectionDetailResp extends BlogCollectionResp {
  const BlogCollectionDetailResp({
    super.id,
    super.userId,
    super.name,
    super.coverUrl,
    super.intro,
    super.visible,
    super.sort,
    super.itemCount,
    super.createTime,
    this.blogs,
  });

  final List<BlogItem>? blogs;

  factory BlogCollectionDetailResp.fromJson(Map<String, dynamic> json) {
    final rawBlogs = json['blogs'] as List<dynamic>?;
    return BlogCollectionDetailResp(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String?,
      coverUrl: json['coverUrl'] as String?,
      intro: json['intro'] as String?,
      visible: (json['visible'] as num?)?.toInt(),
      sort: (json['sort'] as num?)?.toInt(),
      itemCount: (json['itemCount'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
      blogs: rawBlogs
          ?.whereType<Map>()
          .map(
            (e) => BlogItem.fromJson(
              normalizeBlogItemJson(Map<String, dynamic>.from(e)),
            ),
          )
          .toList(),
    );
  }
}

/// 我关注的会员 / 我的粉丝
class BlogFollowMember {
  const BlogFollowMember({
    this.userId,
    this.followedUserId,
    this.nickname,
    this.avatar,
    this.followerCount,
    this.memberLevel,
    this.followTime,
    this.followedByMe,
  });

  final int? userId;
  final int? followedUserId;
  final String? nickname;
  final String? avatar;
  final int? followerCount;
  final int? memberLevel;
  final String? followTime;
  final int? followedByMe;

  int? get memberUserId => userId ?? followedUserId;

  bool get isFollowedByMe => followedByMe == 1;

  factory BlogFollowMember.fromJson(Map<String, dynamic> json) {
    final uid =
        (json['userId'] as num?)?.toInt() ??
        (json['followedUserId'] as num?)?.toInt();
    return BlogFollowMember(
      userId: uid,
      followedUserId: uid,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      followerCount: (json['followerCount'] as num?)?.toInt(),
      memberLevel: (json['memberLevel'] as num?)?.toInt(),
      followTime: json['followTime'] as String?,
      followedByMe: (json['followedByMe'] as num?)?.toInt(),
    );
  }
}

class BlogFollowMemberPageData {
  const BlogFollowMemberPageData({this.list, this.total});

  final List<BlogFollowMember>? list;
  final int? total;

  factory BlogFollowMemberPageData.fromJson(Map<String, dynamic> json) {
    final raw = json['list'] as List<dynamic>?;
    return BlogFollowMemberPageData(
      total: (json['total'] as num?)?.toInt(),
      list: raw
          ?.map((e) => BlogFollowMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BlogCollectionSaveReq {
  const BlogCollectionSaveReq({
    required this.name,
    required this.visible,
    this.coverUrl,
    this.intro,
    this.sort,
  });

  final String name;
  final int visible;
  final String? coverUrl;
  final String? intro;
  final int? sort;

  Map<String, dynamic> toJson() => {
    'name': name,
    'visible': visible,
    if (coverUrl != null) 'coverUrl': coverUrl,
    if (intro != null) 'intro': intro,
    if (sort != null) 'sort': sort,
  };
}

class BlogShopProductSaveReq {
  const BlogShopProductSaveReq({
    required this.name,
    required this.price,
    required this.status,
    this.coverUrl,
    this.externalUrl,
    this.sort,
  });

  final String name;
  final int price;
  final int status;
  final String? coverUrl;
  final String? externalUrl;
  final int? sort;

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'status': status,
    if (coverUrl != null) 'coverUrl': coverUrl,
    if (externalUrl != null) 'externalUrl': externalUrl,
    if (sort != null) 'sort': sort,
  };
}
