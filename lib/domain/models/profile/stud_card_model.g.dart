// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stud_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudCardModel _$StudCardModelFromJson(Map<String, dynamic> json) =>
    StudCardModel(
      id: json['ID'] as int,
      facultyId: json['FACULTY_ID'] as int,
      specialityId: json['SPECIALITY_ID'] as int,
      personId: json['PERSON_ID'] as int,
      cours: json['COURS'] as int,
      groupId: json['GROUP_ID'] as int,
      groupName: json['GROUP_NAME'] as String,
      faculty: json['FACULTY'] as String,
      speciality: json['SPECIALITY'] as String,
      specialization: json['SPECIALIZATION'],
      qualification: json['QUALIFICATION'] as String,
      learnForm: json['LEARN_FORM'] as String,
      statusStr: json['STATUS_STR'] as String,
      finform: json['FINFORM'] as String,
      bep: json['BEP'] as String,
      startYear: json['START_YEAR'] as int,
      admissionDate: json['ADMISSION_DATE'] as String,
    );

Map<String, dynamic> _$StudCardModelToJson(StudCardModel instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'FACULTY_ID': instance.facultyId,
      'SPECIALITY_ID': instance.specialityId,
      'PERSON_ID': instance.personId,
      'COURS': instance.cours,
      'GROUP_ID': instance.groupId,
      'GROUP_NAME': instance.groupName,
      'FACULTY': instance.faculty,
      'SPECIALITY': instance.speciality,
      'SPECIALIZATION': instance.specialization,
      'QUALIFICATION': instance.qualification,
      'LEARN_FORM': instance.learnForm,
      'STATUS_STR': instance.statusStr,
      'FINFORM': instance.finform,
      'BEP': instance.bep,
      'START_YEAR': instance.startYear,
      'ADMISSION_DATE': instance.admissionDate,
    };
