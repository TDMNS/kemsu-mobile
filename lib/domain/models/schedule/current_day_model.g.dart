// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentDayModel _$CurrentDayModelFromJson(Map<String, dynamic> json) =>
    CurrentDayModel(
      success: json['success'] as bool?,
      currentDay: json['currentDay'] == null
          ? null
          : CurrentDay.fromJson(json['currentDay'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrentDayModelToJson(CurrentDayModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'currentDay': instance.currentDay,
    };

CurrentDay _$CurrentDayFromJson(Map<String, dynamic> json) => CurrentDay(
      weekNum: json['weekNum'] as int?,
      weekType: json['weekType'] as String?,
      currentDate: json['currentDate'] as String?,
      currentDay: json['currentDay'] as String?,
    );

Map<String, dynamic> _$CurrentDayToJson(CurrentDay instance) =>
    <String, dynamic>{
      'weekNum': instance.weekNum,
      'weekType': instance.weekType,
      'currentDate': instance.currentDate,
      'currentDay': instance.currentDay,
    };
