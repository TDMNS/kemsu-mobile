// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleTeacherModel _$ScheduleTeacherModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleTeacherModel(
      success: json['success'] as bool,
      teacherList: (json['teacherList'] as List<dynamic>)
          .map((e) => TeacherList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleTeacherModelToJson(
        ScheduleTeacherModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'teacherList': instance.teacherList,
    };

TeacherList _$TeacherListFromJson(Map<String, dynamic> json) => TeacherList(
      prepId: json['prepId'] as int,
      fio: json['fio'] as String,
    );

Map<String, dynamic> _$TeacherListToJson(TeacherList instance) =>
    <String, dynamic>{
      'prepId': instance.prepId,
      'fio': instance.fio,
    };

TeacherScheduleModel _$TeacherScheduleModelFromJson(
        Map<String, dynamic> json) =>
    TeacherScheduleModel(
      success: json['success'] as bool,
      result: TeacherResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeacherScheduleModelToJson(
        TeacherScheduleModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'result': instance.result,
    };

TeacherResult _$TeacherResultFromJson(Map<String, dynamic> json) =>
    TeacherResult(
      weekList: (json['weekList'] as List<dynamic>)
          .map((e) => TeacherWeek.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleList: (json['coupleList'] as List<dynamic>)
          .map((e) => TeacherCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      prepScheduleTable: (json['prepScheduleTable'] as List<dynamic>)
          .map((e) => PrepScheduleTable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeacherResultToJson(TeacherResult instance) =>
    <String, dynamic>{
      'weekList': instance.weekList,
      'coupleList': instance.coupleList,
      'prepScheduleTable': instance.prepScheduleTable,
    };

TeacherCouple _$TeacherCoupleFromJson(Map<String, dynamic> json) =>
    TeacherCouple(
      id: json['Id'] as int,
      num: json['Num'] as int,
      description: json['Description'] as String,
    );

Map<String, dynamic> _$TeacherCoupleToJson(TeacherCouple instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Num': instance.num,
      'Description': instance.description,
    };

PrepScheduleTable _$PrepScheduleTableFromJson(Map<String, dynamic> json) =>
    PrepScheduleTable(
      weekDay: TeacherWeek.fromJson(json['weekDay'] as Map<String, dynamic>),
      ceilList: (json['ceilList'] as List<dynamic>)
          .map((e) => TeacherCeilList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrepScheduleTableToJson(PrepScheduleTable instance) =>
    <String, dynamic>{
      'weekDay': instance.weekDay,
      'ceilList': instance.ceilList,
    };

TeacherCeilList _$TeacherCeilListFromJson(Map<String, dynamic> json) =>
    TeacherCeilList(
      couple: TeacherCouple.fromJson(json['couple'] as Map<String, dynamic>),
      ceil: PrepCeil.fromJson(json['ceil'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeacherCeilListToJson(TeacherCeilList instance) =>
    <String, dynamic>{
      'couple': instance.couple,
      'ceil': instance.ceil,
    };

PrepCeil _$PrepCeilFromJson(Map<String, dynamic> json) => PrepCeil(
      uneven: (json['uneven'] as List<dynamic>)
          .map((e) => TeacherCeil.fromJson(e as Map<String, dynamic>))
          .toList(),
      even: (json['even'] as List<dynamic>)
          .map((e) => TeacherCeil.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrepCeilToJson(PrepCeil instance) => <String, dynamic>{
      'uneven': instance.uneven,
      'even': instance.even,
    };

TeacherCeil _$TeacherCeilFromJson(Map<String, dynamic> json) => TeacherCeil(
      discName: json['discName'] as String,
      auditoryName: json['auditoryName'] as String,
      lessonType: json['lessonType'] as String,
      loadDiscipId: json['loadDiscipId'] as int,
      groupName: json['groupName'] as String,
      startWeekNum: json['startWeekNum'] as int,
      endWeekNum: json['endWeekNum'] as int,
      selectFlag: json['selectFlag'] as int,
    );

Map<String, dynamic> _$TeacherCeilToJson(TeacherCeil instance) =>
    <String, dynamic>{
      'discName': instance.discName,
      'auditoryName': instance.auditoryName,
      'lessonType': instance.lessonType,
      'loadDiscipId': instance.loadDiscipId,
      'groupName': instance.groupName,
      'startWeekNum': instance.startWeekNum,
      'endWeekNum': instance.endWeekNum,
      'selectFlag': instance.selectFlag,
    };

TeacherWeek _$TeacherWeekFromJson(Map<String, dynamic> json) => TeacherWeek(
      id: json['Id'] as int,
      dayNum: json['DayNum'] as int,
      dayName: json['DayName'] as String,
      dayNameShort: json['DayNameShort'] as String,
    );

Map<String, dynamic> _$TeacherWeekToJson(TeacherWeek instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'DayNum': instance.dayNum,
      'DayName': instance.dayName,
      'DayNameShort': instance.dayNameShort,
    };
