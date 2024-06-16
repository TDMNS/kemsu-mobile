// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stud_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudCardModel _$StudCardModelFromJson(Map<String, dynamic> json) =>
    StudCardModel(
      groupName: json['GROUP_NAME'] as String?,
      faculty: json['FACULTY'] as String?,
      speciality: json['SPECIALITY'] as String?,
      learnForm: json['LEARN_FORM'] as String?,
      finform: json['FINFORM'] as String?,
    );

Map<String, dynamic> _$StudCardModelToJson(StudCardModel instance) =>
    <String, dynamic>{
      'GROUP_NAME': instance.groupName,
      'FACULTY': instance.faculty,
      'SPECIALITY': instance.speciality,
      'LEARN_FORM': instance.learnForm,
      'FINFORM': instance.finform,
    };
