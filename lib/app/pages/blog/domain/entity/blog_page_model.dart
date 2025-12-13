import 'dart:core';

/// code : 0
/// data : {"list":[{"id":1,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":null,"updater":null,"createTime":null,"updateTime":"2025-08-19T23:06:48","deleted":false},{"id":2,"squareId":1,"topicIds":"1","categary":1,"blogType":2,"content":"1一寸光阴一寸金，寸金难买寸光阴。","resources":"http://file.qqai.cn/blog/20200607/11/1.mp4","addressId":null,"shareType":1,"creator":null,"updater":null,"createTime":null,"updateTime":"2025-08-19T23:06:42","deleted":false},{"id":3,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-04-06T11:34:06","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":4,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":null,"updateTime":"2025-08-19T23:06:42","deleted":false},{"id":5,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:56:19","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":6,"squareId":1,"topicIds":"1","categary":1,"blogType":2,"content":"1一寸光阴一寸金，寸金难买寸光阴。","resources":"https://file.qqai.cn/blog/20200607/11/1.mp4","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:56:39","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":7,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:58:28","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":8,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:58:28","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":9,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:58:28","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":10,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:58:29","updateTime":"2025-08-19T23:06:42","deleted":false}],"total":21}

class BlogPageModel {
  BlogPageModel({
    num? code,
    Data? data,
    String? msg,
  }) {
    _code = code;
    _data = data;
    _msg = msg;
  }

  BlogPageModel.fromJson(dynamic json) {
    _code = json['code'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _msg = json['msg'];
  }

  num? _code;
  Data? _data;
  String? _msg;

  BlogPageModel copyWith({
    num? code,
    Data? data,
    String? msg,
  }) =>
      BlogPageModel(
        code: code ?? _code,
        data: data ?? _data,
        msg: msg ?? _msg,
      );

  num? get code => _code;

  Data? get data => _data;

  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['msg'] = _msg;
    return map;
  }
}

/// list : [{"id":1,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":null,"updater":null,"createTime":null,"updateTime":"2025-08-19T23:06:48","deleted":false},{"id":2,"squareId":1,"topicIds":"1","categary":1,"blogType":2,"content":"1一寸光阴一寸金，寸金难买寸光阴。","resources":"http://file.qqai.cn/blog/20200607/11/1.mp4","addressId":null,"shareType":1,"creator":null,"updater":null,"createTime":null,"updateTime":"2025-08-19T23:06:42","deleted":false},{"id":3,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-04-06T11:34:06","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":4,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":null,"updateTime":"2025-08-19T23:06:42","deleted":false},{"id":5,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:56:19","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":6,"squareId":1,"topicIds":"1","categary":1,"blogType":2,"content":"1一寸光阴一寸金，寸金难买寸光阴。","resources":"https://file.qqai.cn/blog/20200607/11/1.mp4","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:56:39","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":7,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:58:28","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":8,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:58:28","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":9,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:58:28","updateTime":"2025-08-19T23:06:42","deleted":false},{"id":10,"squareId":1,"topicIds":"1","categary":1,"blogType":1,"content":"长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。","resources":"http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png","addressId":null,"shareType":1,"creator":"1","updater":"1","createTime":"2025-06-07T18:58:29","updateTime":"2025-08-19T23:06:42","deleted":false}]
/// total : 21

class Data {
  Data({
    List<BlogItem>? list,
    num? total,
  }) {
    _list = list;
    _total = total;
  }

  Data.fromJson(dynamic json) {
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(BlogItem.fromJson(v));
      });
    }
    _total = json['total'];
  }

  List<BlogItem>? _list;
  num? _total;

  Data copyWith({
    List<BlogItem>? list,
    num? total,
  }) =>
      Data(
        list: list ?? _list,
        total: total ?? _total,
      );

  List<BlogItem>? get list => _list;

  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_list != null) {
      map['list'] = _list?.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    return map;
  }
}

/// id : 1
/// squareId : 1
/// topicIds : "1"
/// categary : 1
/// blogType : 1
/// content : "长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。"
/// resources : "http://file.qqai.cn/blog/20200607/11/1.png,http://file.qqai.cn/blog/20200607/11/1.png"
/// addressId : null
/// shareType : 1
/// creator : null
/// updater : null
/// createTime : null
/// updateTime : "2025-08-19T23:06:48"
/// deleted : false

class BlogItem {
  BlogItem({
    num? id,
    num? squareId,
    String? topicIds,
    num? categary,
    num? blogType,
    String? content,
    String? resources,
    dynamic addressId,
    num? shareType,
    dynamic creator,
    String? creatorName,
    dynamic updater,
    dynamic createTime,
    String? updateTime,
    num? zan,
    num? care,
  }) {
    _id = id;
    _squareId = squareId;
    _topicIds = topicIds;
    _categary = categary;
    _blogType = blogType;
    _content = content;
    _resources = resources;
    _addressId = addressId;
    _shareType = shareType;
    _creator = creator;
    _creatorName = creatorName;
    _updater = updater;
    _createTime = createTime;
    _updateTime = updateTime;
    _zan = zan;
    _care = care;
  }

  BlogItem.fromJson(dynamic json) {
    _id = json['id'];
    _squareId = json['squareId'];
    _topicIds = json['topicIds'];
    _categary = json['categary'];
    _blogType = json['blogType'];
    _content = json['content'];
    _resources = json['resources'];
    _addressId = json['addressId'];
    _shareType = json['shareType'];
    _creator = json['creator'];
    _creatorName = json['creatorName'];
    _updater = json['updater'];
    _createTime = json['createTime'];
    _updateTime = json['updateTime'];
    _zan = json['zan'];
    _care = json['care'];
  }

  num? _id;
  num? _squareId;
  String? _topicIds;
  num? _categary;
  num? _blogType;
  String? _content;
  String? _resources;
  dynamic _addressId;
  num? _shareType;
  dynamic _creator;
  String? _creatorName;
  dynamic _updater;
  dynamic _createTime;
  String? _updateTime;
  bool? _deleted;
  num? _zan;
  num? _care;

  BlogItem copyWith({
    num? id,
    num? squareId,
    String? topicIds,
    num? categary,
    num? blogType,
    String? content,
    String? resources,
    dynamic addressId,
    num? shareType,
    dynamic creator,
    String? creatorName,
    dynamic updater,
    dynamic createTime,
    String? updateTime,
    num? zan,
    num? care,
  }) =>
      BlogItem(
        id: id ?? _id,
        squareId: squareId ?? _squareId,
        topicIds: topicIds ?? _topicIds,
        categary: categary ?? _categary,
        blogType: blogType ?? _blogType,
        content: content ?? _content,
        resources: resources ?? _resources,
        addressId: addressId ?? _addressId,
        shareType: shareType ?? _shareType,
        creator: creator ?? _creator,
        creatorName: creatorName ?? _creatorName,
        updater: updater ?? _updater,
        createTime: createTime ?? _createTime,
        updateTime: updateTime ?? _updateTime,
        zan: zan ?? _zan,
        care: care ?? _care,
      );

  num? get id => _id;

  num? get squareId => _squareId;

  String? get topicIds => _topicIds;

  num? get categary => _categary;

  num? get blogType => _blogType;

  String? get content => _content;

  String? get resources => _resources;

  dynamic get addressId => _addressId;

  num? get shareType => _shareType;

  dynamic get creator => _creator;

  String? get creatorName => _creatorName;

  dynamic get updater => _updater;

  dynamic get createTime => _createTime;

  String? get updateTime => _updateTime;

  num? get zan => _zan;

  num? get care => _care;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['squareId'] = _squareId;
    map['topicIds'] = _topicIds;
    map['categary'] = _categary;
    map['blogType'] = _blogType;
    map['content'] = _content;
    map['resources'] = _resources;
    map['addressId'] = _addressId;
    map['shareType'] = _shareType;
    map['creator'] = _creator;
    map['creatorName'] = _creatorName;
    map['updater'] = _updater;
    map['createTime'] = _createTime;
    map['updateTime'] = _updateTime;
    map['deleted'] = _deleted;
    map['care'] = _care;
    return map;
  }
}
