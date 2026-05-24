import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/skuu_blog_save_entity.g.dart';
import 'dart:convert';
export 'package:qqai/generated/json/skuu_blog_save_entity.g.dart';

@JsonSerializable()
class SkuuBlogSaveEntity {
	late int addressId;
	late int blogType;
	late int categary;
	String title = '';
	late String content;
	late String resources;
	late int shareType;
	late int squareId;
	late String topicIds;

	SkuuBlogSaveEntity();

	factory SkuuBlogSaveEntity.fromJson(Map<String, dynamic> json) => $SkuuBlogSaveEntityFromJson(json);

	Map<String, dynamic> toJson() => $SkuuBlogSaveEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}