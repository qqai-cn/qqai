import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_page_model.freezed.dart';
part 'help_page_model.g.dart';

@freezed
sealed class HelpItem with _$HelpItem {
  const factory HelpItem({
    int? blogType,
    int? care,
    int? categary,
    String? content,
    String? creatorName,
    int? id,
    String? resources,
    int? shareType,
    int? squareId,
    String? topicIds,
    String? updateTime,
    int? zan,
  }) = _HelpItem;

  factory HelpItem.fromJson(Map<String, dynamic> json) => _$HelpItemFromJson(json);
}

@freezed
sealed class HelpPageModelData with _$HelpPageModelData {
  const factory HelpPageModelData({
    List<HelpItem>? list,
    int? total,
  }) = _HelpPageModelData;

  factory HelpPageModelData.fromJson(Map<String, dynamic> json) => _$HelpPageModelDataFromJson(json);
}

@freezed
sealed class HelpPageModel with _$HelpPageModel {
  const factory HelpPageModel({
    int? code,
    HelpPageModelData? data,
    String? msg,
  }) = _HelpPageModel;

  factory HelpPageModel.fromJson(Map<String, dynamic> json) => _$HelpPageModelFromJson(json);
}

