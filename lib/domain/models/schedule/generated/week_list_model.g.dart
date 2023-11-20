// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../week_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekListModel _$WeekListModelFromJson(Map<String, dynamic> json) => WeekListModel(
      success: json['success'] as bool,
      result: (json['result'] as List<dynamic>).map((e) => WeekResult.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$WeekListModelToJson(WeekListModel instance) => <String, dynamic>{
      'success': instance.success,
      'result': instance.result,
    };

WeekResult _$WeekResultFromJson(Map<String, dynamic> json) => WeekResult(
      id: json['Id'] as int,
      num: json['Num'] as int,
    );

Map<String, dynamic> _$WeekResultToJson(WeekResult instance) => <String, dynamic>{
      'Id': instance.id,
      'Num': instance.num,
    };
