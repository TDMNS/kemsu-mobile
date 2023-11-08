// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      success: json['success'] as bool,
      result: ScheduleResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'result': instance.result,
    };

ScheduleResult _$ScheduleResultFromJson(Map<String, dynamic> json) =>
    ScheduleResult(
      weekList: (json['WeekList'] as List<dynamic>)
          .map((e) => ScheduleWeekList.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleList: (json['CoupleList'] as List<dynamic>)
          .map((e) => ScheduleCoupleList.fromJson(e as Map<String, dynamic>))
          .toList(),
      weekTypeList: (json['WeekTypeList'] as List<dynamic>)
          .map((e) => ScheduleWeekTypeList.fromJson(e as Map<String, dynamic>))
          .toList(),
      table: ScheduleTable.fromJson(json['Table'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleResultToJson(ScheduleResult instance) =>
    <String, dynamic>{
      'WeekList': instance.weekList,
      'CoupleList': instance.coupleList,
      'WeekTypeList': instance.weekTypeList,
      'Table': instance.table,
    };

ScheduleCoupleList _$ScheduleCoupleListFromJson(Map<String, dynamic> json) =>
    ScheduleCoupleList(
      id: json['Id'] as int,
      num: json['Num'] as int,
      description: json['Description'] as String,
    );

Map<String, dynamic> _$ScheduleCoupleListToJson(ScheduleCoupleList instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Num': instance.num,
      'Description': instance.description,
    };

ScheduleTable _$ScheduleTableFromJson(Map<String, dynamic> json) =>
    ScheduleTable(
      weekDay1:
          ScheduleWeekDay.fromJson(json['weekDay1'] as Map<String, dynamic>),
      weekDay2:
          ScheduleWeekDay.fromJson(json['weekDay2'] as Map<String, dynamic>),
      weekDay3:
          ScheduleWeekDay.fromJson(json['weekDay3'] as Map<String, dynamic>),
      weekDay4:
          ScheduleWeekDay.fromJson(json['weekDay4'] as Map<String, dynamic>),
      weekDay5:
          ScheduleWeekDay.fromJson(json['weekDay5'] as Map<String, dynamic>),
      weekDay6:
          ScheduleWeekDay.fromJson(json['weekDay6'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleTableToJson(ScheduleTable instance) =>
    <String, dynamic>{
      'weekDay1': instance.weekDay1,
      'weekDay2': instance.weekDay2,
      'weekDay3': instance.weekDay3,
      'weekDay4': instance.weekDay4,
      'weekDay5': instance.weekDay5,
      'weekDay6': instance.weekDay6,
    };

ScheduleWeekDay _$ScheduleWeekDayFromJson(Map<String, dynamic> json) =>
    ScheduleWeekDay(
      coupleAll1: (json['coupleAll1'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleAll1Str: json['coupleAll1_str'] as String,
      coupleEven1: (json['coupleEven1'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleEven1Str: json['coupleEven1_str'] as String,
      coupleOdd1: (json['coupleOdd1'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleOdd1Str: json['coupleOdd1_str'] as String,
      coupleAll2: (json['coupleAll2'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleAll2Str: json['coupleAll2_str'] as String,
      coupleEven2: (json['coupleEven2'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleEven2Str: json['coupleEven2_str'] as String,
      coupleOdd2: (json['coupleOdd2'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleOdd2Str: json['coupleOdd2_str'] as String,
      coupleAll3: (json['coupleAll3'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleAll3Str: json['coupleAll3_str'] as String,
      coupleEven3: (json['coupleEven3'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleEven3Str: json['coupleEven3_str'] as String,
      coupleOdd3: (json['coupleOdd3'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleOdd3Str: json['coupleOdd3_str'] as String,
      coupleAll4: (json['coupleAll4'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleAll4Str: json['coupleAll4_str'] as String,
      coupleEven4: (json['coupleEven4'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleEven4Str: json['coupleEven4_str'] as String,
      coupleOdd4: (json['coupleOdd4'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleOdd4Str: json['coupleOdd4_str'] as String,
      coupleAll5: (json['coupleAll5'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleAll5Str: json['coupleAll5_str'] as String,
      coupleEven5: (json['coupleEven5'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleEven5Str: json['coupleEven5_str'] as String,
      coupleOdd5: (json['coupleOdd5'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleOdd5Str: json['coupleOdd5_str'] as String,
      coupleAll6: (json['coupleAll6'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleAll6Str: json['coupleAll6_str'] as String,
      coupleEven6: (json['coupleEven6'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleEven6Str: json['coupleEven6_str'] as String,
      coupleOdd6: (json['coupleOdd6'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleOdd6Str: json['coupleOdd6_str'] as String,
      coupleAll7: (json['coupleAll7'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleAll7Str: json['coupleAll7_str'] as String,
      coupleEven7: (json['coupleEven7'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleEven7Str: json['coupleEven7_str'] as String,
      coupleOdd7: (json['coupleOdd7'] as List<dynamic>)
          .map((e) => ScheduleCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleOdd7Str: json['coupleOdd7_str'] as String,
    );

Map<String, dynamic> _$ScheduleWeekDayToJson(ScheduleWeekDay instance) =>
    <String, dynamic>{
      'coupleAll1': instance.coupleAll1,
      'coupleAll1_str': instance.coupleAll1Str,
      'coupleEven1': instance.coupleEven1,
      'coupleEven1_str': instance.coupleEven1Str,
      'coupleOdd1': instance.coupleOdd1,
      'coupleOdd1_str': instance.coupleOdd1Str,
      'coupleAll2': instance.coupleAll2,
      'coupleAll2_str': instance.coupleAll2Str,
      'coupleEven2': instance.coupleEven2,
      'coupleEven2_str': instance.coupleEven2Str,
      'coupleOdd2': instance.coupleOdd2,
      'coupleOdd2_str': instance.coupleOdd2Str,
      'coupleAll3': instance.coupleAll3,
      'coupleAll3_str': instance.coupleAll3Str,
      'coupleEven3': instance.coupleEven3,
      'coupleEven3_str': instance.coupleEven3Str,
      'coupleOdd3': instance.coupleOdd3,
      'coupleOdd3_str': instance.coupleOdd3Str,
      'coupleAll4': instance.coupleAll4,
      'coupleAll4_str': instance.coupleAll4Str,
      'coupleEven4': instance.coupleEven4,
      'coupleEven4_str': instance.coupleEven4Str,
      'coupleOdd4': instance.coupleOdd4,
      'coupleOdd4_str': instance.coupleOdd4Str,
      'coupleAll5': instance.coupleAll5,
      'coupleAll5_str': instance.coupleAll5Str,
      'coupleEven5': instance.coupleEven5,
      'coupleEven5_str': instance.coupleEven5Str,
      'coupleOdd5': instance.coupleOdd5,
      'coupleOdd5_str': instance.coupleOdd5Str,
      'coupleAll6': instance.coupleAll6,
      'coupleAll6_str': instance.coupleAll6Str,
      'coupleEven6': instance.coupleEven6,
      'coupleEven6_str': instance.coupleEven6Str,
      'coupleOdd6': instance.coupleOdd6,
      'coupleOdd6_str': instance.coupleOdd6Str,
      'coupleAll7': instance.coupleAll7,
      'coupleAll7_str': instance.coupleAll7Str,
      'coupleEven7': instance.coupleEven7,
      'coupleEven7_str': instance.coupleEven7Str,
      'coupleOdd7': instance.coupleOdd7,
      'coupleOdd7_str': instance.coupleOdd7Str,
    };

ScheduleCouple _$ScheduleCoupleFromJson(Map<String, dynamic> json) =>
    ScheduleCouple(
      discName: json['DiscName'] as String? ?? '',
      prepName: json['PrepName'] as String? ?? '',
      auditoryName: json['AuditoryName'] as String? ?? '',
      lessonType: json['lessonType'] as String? ?? '',
      loadDiscipId: json['loadDiscipId'] as int? ?? 0,
      periodTypeName: json['periodTypeName'] as String? ?? '',
      periodTypeId: json['PeriodTypeId'] as int? ?? 0,
      maxWeekNum: json['maxWeekNum'] as int? ?? 0,
      minWeekNum: json['minWeekNum'] as int? ?? 0,
      selectFlag: json['selectFlag'] as int? ?? 0,
      periodTypePref: json['periodTypePref'] as String? ?? '',
      loadFlag: json['loadFlag'] as int? ?? 0,
      scheduleId: json['scheduleId'] as int? ?? 0,
    );

Map<String, dynamic> _$ScheduleCoupleToJson(ScheduleCouple instance) =>
    <String, dynamic>{
      'DiscName': instance.discName,
      'PrepName': instance.prepName,
      'AuditoryName': instance.auditoryName,
      'lessonType': instance.lessonType,
      'loadDiscipId': instance.loadDiscipId,
      'periodTypeName': instance.periodTypeName,
      'PeriodTypeId': instance.periodTypeId,
      'maxWeekNum': instance.maxWeekNum,
      'minWeekNum': instance.minWeekNum,
      'selectFlag': instance.selectFlag,
      'periodTypePref': instance.periodTypePref,
      'loadFlag': instance.loadFlag,
      'scheduleId': instance.scheduleId,
    };

ScheduleWeekList _$ScheduleWeekListFromJson(Map<String, dynamic> json) =>
    ScheduleWeekList(
      id: json['Id'] as int,
      dayNum: json['DayNum'] as int,
      dayName: json['DayName'] as String,
      dayNameShort: json['DayNameShort'] as String,
    );

Map<String, dynamic> _$ScheduleWeekListToJson(ScheduleWeekList instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'DayNum': instance.dayNum,
      'DayName': instance.dayName,
      'DayNameShort': instance.dayNameShort,
    };

ScheduleWeekTypeList _$ScheduleWeekTypeListFromJson(
        Map<String, dynamic> json) =>
    ScheduleWeekTypeList(
      id: json['Id'] as int,
      name: json['Name'] as String,
    );

Map<String, dynamic> _$ScheduleWeekTypeListToJson(
        ScheduleWeekTypeList instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
    };
