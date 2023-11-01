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
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeacherScheduleModelToJson(
        TeacherScheduleModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      weekList: (json['weekList'] as List<dynamic>)
          .map((e) => Week.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleList: (json['coupleList'] as List<dynamic>)
          .map((e) => Couple.fromJson(e as Map<String, dynamic>))
          .toList(),
      prepScheduleTable: (json['prepScheduleTable'] as List<dynamic>)
          .map((e) => PrepScheduleTable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'weekList': instance.weekList,
      'coupleList': instance.coupleList,
      'prepScheduleTable': instance.prepScheduleTable,
    };

Couple _$CoupleFromJson(Map<String, dynamic> json) => Couple(
      id: json['Id'] as int,
      num: json['Num'] as int,
      description: json['Description'] as String,
    );

Map<String, dynamic> _$CoupleToJson(Couple instance) => <String, dynamic>{
      'Id': instance.id,
      'Num': instance.num,
      'Description': instance.description,
    };

PrepScheduleTable _$PrepScheduleTableFromJson(Map<String, dynamic> json) =>
    PrepScheduleTable(
      weekDay: Week.fromJson(json['weekDay'] as Map<String, dynamic>),
      ceilList: (json['ceilList'] as List<dynamic>)
          .map((e) => CeilList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrepScheduleTableToJson(PrepScheduleTable instance) =>
    <String, dynamic>{
      'weekDay': instance.weekDay,
      'ceilList': instance.ceilList,
    };

CeilList _$CeilListFromJson(Map<String, dynamic> json) => CeilList(
      couple: Couple.fromJson(json['couple'] as Map<String, dynamic>),
      ceil: Ceil.fromJson(json['ceil'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CeilListToJson(CeilList instance) => <String, dynamic>{
      'couple': instance.couple,
      'ceil': instance.ceil,
    };

Ceil _$CeilFromJson(Map<String, dynamic> json) => Ceil(
      uneven: (json['uneven'] as List<dynamic>)
          .map((e) => TeacherCeil.fromJson(e as Map<String, dynamic>))
          .toList(),
      even: (json['even'] as List<dynamic>)
          .map((e) => TeacherCeil.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CeilToJson(Ceil instance) => <String, dynamic>{
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

Week _$WeekFromJson(Map<String, dynamic> json) => Week(
      id: json['Id'] as int,
      dayNum: json['DayNum'] as int,
      dayName: json['DayName'] as String,
      dayNameShort: json['DayNameShort'] as String,
    );

Map<String, dynamic> _$WeekToJson(Week instance) => <String, dynamic>{
      'Id': instance.id,
      'DayNum': instance.dayNum,
      'DayName': instance.dayName,
      'DayNameShort': instance.dayNameShort,
    };
