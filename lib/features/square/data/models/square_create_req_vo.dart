import 'package:freezed_annotation/freezed_annotation.dart';

part 'square_create_req_vo.freezed.dart';
part 'square_create_req_vo.g.dart';

@freezed
sealed class SquareCreateReqVO with _$SquareCreateReqVO {
  const factory SquareCreateReqVO({
    required String squareName,
    String? squareImg,
    String? squareDesc,
    int? areaId,
  }) = _SquareCreateReqVO;

  factory SquareCreateReqVO.fromJson(Map<String, dynamic> json) =>
      _$SquareCreateReqVOFromJson(json);
}
