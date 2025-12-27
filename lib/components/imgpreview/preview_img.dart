import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_img.freezed.dart';
part 'preview_img.g.dart';

@freezed
sealed class PreviewImg with _$PreviewImg {
  const factory PreviewImg({
    int? id,
    String? url,
    String? heroTag,
    int? index,
    @Default([]) List<String> allUris,
  }) = _PreviewImg;

  factory PreviewImg.fromJson(Map<String, dynamic> json) => _$PreviewImgFromJson(json);
}