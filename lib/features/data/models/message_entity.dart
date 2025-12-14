import 'dart:convert';

import 'package:qqai/generated/json/base/json_field.dart';
import 'package:qqai/generated/json/message_entity.g.dart';

export 'package:qqai/generated/json/message_entity.g.dart';

@JsonSerializable()
class MessageEntity {
	late MessageAuthor author;
	late int createdAt;
	late String id;
	late String status;
	late String text;
	late String type;

	MessageEntity();

	factory MessageEntity.fromJson(Map<String, dynamic> json) => $MessageEntityFromJson(json);

	Map<String, dynamic> toJson() => $MessageEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MessageAuthor {
	late String firstName;
	late String id;
	late String lastName;

	MessageAuthor();

	factory MessageAuthor.fromJson(Map<String, dynamic> json) => $MessageAuthorFromJson(json);

	Map<String, dynamic> toJson() => $MessageAuthorToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}