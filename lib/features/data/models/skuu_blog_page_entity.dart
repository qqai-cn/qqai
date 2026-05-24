import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/skuu_blog_page_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/skuu_blog_page_entity.g.dart';

@JsonSerializable()
class SkuuBlogPageEntity {
	late int code;
	late String message;
	late SkuuBlogPageData data;

	SkuuBlogPageEntity();

	factory SkuuBlogPageEntity.fromJson(Map<String, dynamic> json) => $SkuuBlogPageEntityFromJson(json);

	Map<String, dynamic> toJson() => $SkuuBlogPageEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SkuuBlogPageData {
	late List<SkuuBlogPageDataRecords> list;
	late String total;
	late String size;
	late String current;
	late List<dynamic> orders;
	late bool optimizeCountSql;
	late bool searchCount;
	late String pages;

	SkuuBlogPageData();

	factory SkuuBlogPageData.fromJson(Map<String, dynamic> json) => $SkuuBlogPageDataFromJson(json);

	Map<String, dynamic> toJson() => $SkuuBlogPageDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SkuuBlogPageDataRecords {
	late String id;
	late String squareId;
	late int topicId;
	late int categary;
	late int blogType;
	String title = '';
	late String content;
	late String resources;
	late int shareType;
	late bool deleted;
	late bool care;
	late bool zan;
	late String creator;
	late String updater;
	late String createTime;
	late String updateTime;

	SkuuBlogPageDataRecords();

	factory SkuuBlogPageDataRecords.fromJson(Map<String, dynamic> json) => $SkuuBlogPageDataRecordsFromJson(json);

	Map<String, dynamic> toJson() => $SkuuBlogPageDataRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}