// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emp_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmpCardModel _$EmpCardModelFromJson(Map<String, dynamic> json) => EmpCardModel(
      success: json['success'] as bool,
      empList: (json['empList'] as List<dynamic>)
          .map((e) => EmpList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmpCardModelToJson(EmpCardModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'empList': instance.empList,
    };

EmpList _$EmpListFromJson(Map<String, dynamic> json) => EmpList(
      login: json['LOGIN'] as String,
      lastName: json['LAST_NAME'] as String,
      firstName: json['FIRST_NAME'] as String,
      middleName: json['MIDDLE_NAME'] as String,
      postName: json['POST_NAME'],
      dep: json['DEP'] as String,
      status: json['STATUS'] as String,
    );

Map<String, dynamic> _$EmpListToJson(EmpList instance) => <String, dynamic>{
      'LOGIN': instance.login,
      'LAST_NAME': instance.lastName,
      'FIRST_NAME': instance.firstName,
      'MIDDLE_NAME': instance.middleName,
      'POST_NAME': instance.postName,
      'DEP': instance.dep,
      'STATUS': instance.status,
    };
