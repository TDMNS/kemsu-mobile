// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../group_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupListModel _$GroupListModelFromJson(Map<String, dynamic> json) => GroupListModel(
      success: json['success'] as bool,
      result: (json['result'] as List<dynamic>).map((e) => GroupResult.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$GroupListModelToJson(GroupListModel instance) => <String, dynamic>{
      'success': instance.success,
      'result': instance.result,
    };

GroupResult _$GroupResultFromJson(Map<String, dynamic> json) => GroupResult(
      id: json['Id'] as int,
      groupName: json['GroupName'] as String,
      specName: json['specName'] as String,
      learnForm: json['learnForm'] as String,
    );

Map<String, dynamic> _$GroupResultToJson(GroupResult instance) => <String, dynamic>{
      'Id': instance.id,
      'GroupName': instance.groupName,
      'specName': instance.specName,
      'learnForm': instance.learnForm,
    };
