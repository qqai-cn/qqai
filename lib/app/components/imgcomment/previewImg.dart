/// id : 1
/// url : "url"
/// index : 2

class PreviewImg {
  PreviewImg({
      num? id, 
      String? url, 
      String? heroTag,
      num? index,}){
    _id = id;
    _url = url;
    _heroTag = heroTag;
    _index = index;
}

  PreviewImg.fromJson(dynamic json) {
    _id = json['id'];
    _url = json['url'];
    _index = json['index'];
    _heroTag = json['heroTag'];
  }
  num? _id;
  String? _url;
  String? _heroTag;
  num? _index;
PreviewImg copyWith({  num? id,
  String? url,
  String? heroTag,
  num? index,
}) => PreviewImg(  id: id ?? _id,
  url: url ?? _url,
  index: index ?? _index,
  heroTag: heroTag ?? _heroTag,
);
  num? get id => _id;
  String? get url => _url;
  String? get heroTag => _heroTag;
  num? get index => _index;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['url'] = _url;
    map['heroTag'] = _heroTag;
    map['index'] = _index;
    return map;
  }

}