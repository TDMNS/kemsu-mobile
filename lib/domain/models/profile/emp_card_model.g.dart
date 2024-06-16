// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emp_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmpCardModel _$EmpCardModelFromJson(Map<String, dynamic> json) => EmpCardModel(
      success: json['success'] as bool?,
      empList: (json['empList'] as List<dynamic>?)
          ?.map((e) => EmpList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmpCardModelToJson(EmpCardModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'empList': instance.empList,
    };

EmpList _$EmpListFromJson(Map<String, dynamic> json) => EmpList(
      dep: json['DEP'] as String?,
    );

Map<String, dynamic> _$EmpListToJson(EmpList instance) => <String, dynamic>{
      'DEP': instance.dep,
    };
