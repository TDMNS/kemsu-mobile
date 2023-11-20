// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../faculty_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacultyListModel _$FacultyListModelFromJson(Map<String, dynamic> json) =>
    FacultyListModel(
      success: json['success'] as bool,
      result: (json['result'] as List<dynamic>)
          .map((e) => FacultyResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FacultyListModelToJson(FacultyListModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'result': instance.result,
    };

FacultyResult _$FacultyResultFromJson(Map<String, dynamic> json) =>
    FacultyResult(
      id: json['Id'] as int,
      facultyName: json['Faculty'] as String,
    );

Map<String, dynamic> _$FacultyResultToJson(FacultyResult instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Faculty': instance.facultyName,
    };
