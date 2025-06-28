// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errors_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) => ErrorModel(
      error: ErrorDes.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{
      'error': instance.error,
    };

ErrorDes _$ErrorDesFromJson(Map<String, dynamic> json) => ErrorDes(
      description: json['description'] as String,
    );

Map<String, dynamic> _$ErrorDesToJson(ErrorDes instance) => <String, dynamic>{
      'description': instance.description,
    };
