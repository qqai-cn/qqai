import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_model.freezed.dart';
part 'topic_model.g.dart';

@freezed
sealed class SkuuTopicResVO with _$SkuuTopicResVO {
  const factory SkuuTopicResVO({
    int? id,
    String? topicName,
    String? creator,
    String? updater,
    String? createTime,
    String? updateTime,
  }) = _SkuuTopicResVO;

  factory SkuuTopicResVO.fromJson(Map<String, dynamic> json) =>
      _$SkuuTopicResVOFromJson(json);
}

@freezed
sealed class TopicPageResult with _$TopicPageResult {
  const factory TopicPageResult({
    int? total,
    List<SkuuTopicResVO>? list,
  }) = _TopicPageResult;

  factory TopicPageResult.fromJson(Map<String, dynamic> json) =>
      _$TopicPageResultFromJson(json);
}

@freezed
sealed class TopicPageResponse with _$TopicPageResponse {
  const factory TopicPageResponse({
    int? code,
    String? msg,
    TopicPageResult? data,
  }) = _TopicPageResponse;

  factory TopicPageResponse.fromJson(Map<String, dynamic> json) =>
      _$TopicPageResponseFromJson(json);
}
