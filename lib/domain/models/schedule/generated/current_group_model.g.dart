// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../current_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentGroupModel _$CurrentGroupModelFromJson(Map<String, dynamic> json) =>
    CurrentGroupModel(
      success: json['success'] as bool,
      currentGroupList: (json['currentGroupList'] as List<dynamic>)
          .map((e) => CurrentGroupData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CurrentGroupModelToJson(CurrentGroupModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'currentGroupList': instance.currentGroupList,
    };

CurrentGroupData _$CurrentGroupDataFromJson(Map<String, dynamic> json) =>
    CurrentGroupData(
      facultyId: json['facultyId'] as int,
      facultyName: json['facultyName'] as String,
      groupId: json['groupId'] as int,
      groupName: json['groupName'] as String,
      studyYear: json['studyYear'] as String,
      semesterId: json['semesterId'] as int,
    );

Map<String, dynamic> _$CurrentGroupDataToJson(CurrentGroupData instance) =>
    <String, dynamic>{
      'facultyId': instance.facultyId,
      'facultyName': instance.facultyName,
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'studyYear': instance.studyYear,
      'semesterId': instance.semesterId,
    };
