import 'package:freezed_annotation/freezed_annotation.dart';

part 'index.freezed.dart';
part 'index.g.dart';

@freezed
abstract class Index with _$Index {
  const factory Index({
    required String id,
    required String name,
    @Default('') String description,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Index;

  factory Index.fromJson(Map<String, dynamic> json) =>
      _$IndexFromJson(json);
}
