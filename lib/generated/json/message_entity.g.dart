import 'package:qqai/generated/json/base/json_convert_content.dart';
import 'package:qqai/app/data/models/message_entity.dart';

MessageEntity $MessageEntityFromJson(Map<String, dynamic> json) {
  final MessageEntity messageEntity = MessageEntity();
  final MessageAuthor? author = jsonConvert.convert<MessageAuthor>(
      json['author']);
  if (author != null) {
    messageEntity.author = author;
  }
  final int? createdAt = jsonConvert.convert<int>(json['createdAt']);
  if (createdAt != null) {
    messageEntity.createdAt = createdAt;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    messageEntity.id = id;
  }
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    messageEntity.status = status;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    messageEntity.text = text;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    messageEntity.type = type;
  }
  return messageEntity;
}

Map<String, dynamic> $MessageEntityToJson(MessageEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['author'] = entity.author.toJson();
  data['createdAt'] = entity.createdAt;
  data['id'] = entity.id;
  data['status'] = entity.status;
  data['text'] = entity.text;
  data['type'] = entity.type;
  return data;
}

extension MessageEntityExtension on MessageEntity {
  MessageEntity copyWith({
    MessageAuthor? author,
    int? createdAt,
    String? id,
    String? status,
    String? text,
    String? type,
  }) {
    return MessageEntity()
      ..author = author ?? this.author
      ..createdAt = createdAt ?? this.createdAt
      ..id = id ?? this.id
      ..status = status ?? this.status
      ..text = text ?? this.text
      ..type = type ?? this.type;
  }
}

MessageAuthor $MessageAuthorFromJson(Map<String, dynamic> json) {
  final MessageAuthor messageAuthor = MessageAuthor();
  final String? firstName = jsonConvert.convert<String>(json['firstName']);
  if (firstName != null) {
    messageAuthor.firstName = firstName;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    messageAuthor.id = id;
  }
  final String? lastName = jsonConvert.convert<String>(json['lastName']);
  if (lastName != null) {
    messageAuthor.lastName = lastName;
  }
  return messageAuthor;
}

Map<String, dynamic> $MessageAuthorToJson(MessageAuthor entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['firstName'] = entity.firstName;
  data['id'] = entity.id;
  data['lastName'] = entity.lastName;
  return data;
}

extension MessageAuthorExtension on MessageAuthor {
  MessageAuthor copyWith({
    String? firstName,
    String? id,
    String? lastName,
  }) {
    return MessageAuthor()
      ..firstName = firstName ?? this.firstName
      ..id = id ?? this.id
      ..lastName = lastName ?? this.lastName;
  }
}