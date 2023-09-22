// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../semester_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SemesterListModel _$SemesterListModelFromJson(Map<String, dynamic> json) =>
    SemesterListModel(
      success: json['success'] as bool,
      result: (json['result'] as List<dynamic>)
          .map((e) => SemesterResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SemesterListModelToJson(SemesterListModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'result': instance.result,
    };

SemesterResult _$SemesterResultFromJson(Map<String, dynamic> json) =>
    SemesterResult(
      id: json['Id'] as int,
      studyYear: json['StudyYear'] as String,
      semesterType: json['SemesterType'] as int,
      weekNum: json['WeekNum'] as int,
      title: json['Title'] as String,
    );

Map<String, dynamic> _$SemesterResultToJson(SemesterResult instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'StudyYear': instance.studyYear,
      'SemesterType': instance.semesterType,
      'WeekNum': instance.weekNum,
      'Title': instance.title,
    };
