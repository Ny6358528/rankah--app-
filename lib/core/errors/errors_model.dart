import 'package:json_annotation/json_annotation.dart';
part 'errors_model.g.dart';
@JsonSerializable()
class ErrorModel {
  final ErrorDes error;
  ErrorModel({required this.error});
  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);
}
@JsonSerializable()
class ErrorDes {
  final String description;
  ErrorDes({required this.description});
  factory ErrorDes.fromJson(Map<String, dynamic> json) =>
      _$ErrorDesFromJson(json);
}


