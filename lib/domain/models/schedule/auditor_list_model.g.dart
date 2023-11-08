// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditorList _$AuditorListFromJson(Map<String, dynamic> json) => AuditorList(
      success: json['success'] as bool,
      auditorList: (json['auditorList'] as List<dynamic>)
          .map((e) => AuditorListElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AuditorListToJson(AuditorList instance) =>
    <String, dynamic>{
      'success': instance.success,
      'auditorList': instance.auditorList,
    };

AuditorListElement _$AuditorListElementFromJson(Map<String, dynamic> json) =>
    AuditorListElement(
      auditoryId: json['auditoryId'] as int,
      auditoryName: json['auditoryName'] as String,
      auditoryType: json['auditoryType'] as String,
      auditoryBuild: json['auditoryBuild'] as String,
      auditoryBuildNumber: json['auditoryBuildNumber'] as int,
    );

Map<String, dynamic> _$AuditorListElementToJson(AuditorListElement instance) =>
    <String, dynamic>{
      'auditoryId': instance.auditoryId,
      'auditoryName': instance.auditoryName,
      'auditoryType': instance.auditoryType,
      'auditoryBuild': instance.auditoryBuild,
      'auditoryBuildNumber': instance.auditoryBuildNumber,
    };
