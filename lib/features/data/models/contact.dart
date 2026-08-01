import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../components/azlist/az_common.dart';

class ContactInfo extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;

  Color? bgColor;
  IconData? iconData;

  String? img;
  int? id;
  String? firstletter;

  /// AI 助手好友：为 true 时 [id] 为会话 id（正数），走 AI 对话而非 IM。
  bool isAi;

  /// 系统默认千千AI助手（头像固定网站 icon）
  bool isDefaultAi;

  ContactInfo({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.bgColor,
    this.iconData,
    this.img,
    this.id,
    this.firstletter,
    this.isAi = false,
    this.isDefaultAi = false,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img = json['img'],
        id = json['id'],
        firstletter = json['firstletter'],
        isAi = json['isAi'] == true,
        isDefaultAi = json['isDefaultAi'] == true;

  Map<String, dynamic> toJson() => {
        'name': name,
        'img': img,
        'isAi': isAi,
        'isDefaultAi': isDefaultAi,
      };

  @override
  String getSuspensionTag() => tagIndex!;

  /// 顶部固定行（新的朋友、群聊等）
  bool get isTopEntry => tagIndex == '↑';

  @override
  String toString() => json.encode(this);
}
