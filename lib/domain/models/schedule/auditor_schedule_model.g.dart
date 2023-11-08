// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditorSchedule _$AuditorScheduleFromJson(Map<String, dynamic> json) =>
    AuditorSchedule(
      success: json['success'] as bool?,
      weekDayList: (json['weekDayList'] as List<dynamic>?)
          ?.map((e) => AuditorWeekDayList.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleList: (json['coupleList'] as List<dynamic>?)
          ?.map((e) => AuditorCoupleList.fromJson(e as Map<String, dynamic>))
          .toList(),
      weekTypeList: (json['weekTypeList'] as List<dynamic>?)
          ?.map((e) => AuditorWeekTypeList.fromJson(e as Map<String, dynamic>))
          .toList(),
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>)
              .map((e) => AuditorTable.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$AuditorScheduleToJson(AuditorSchedule instance) =>
    <String, dynamic>{
      'success': instance.success,
      'weekDayList': instance.weekDayList,
      'coupleList': instance.coupleList,
      'weekTypeList': instance.weekTypeList,
      'table': instance.table,
    };

AuditorCoupleList _$AuditorCoupleListFromJson(Map<String, dynamic> json) =>
    AuditorCoupleList(
      id: json['Id'] as int?,
      num: json['Num'] as int?,
      description: json['Description'] as String?,
    );

Map<String, dynamic> _$AuditorCoupleListToJson(AuditorCoupleList instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Num': instance.num,
      'Description': instance.description,
    };

AuditorTable _$AuditorTableFromJson(Map<String, dynamic> json) => AuditorTable(
      coupleAll: (json['coupleAll'] as List<dynamic>?)
          ?.map((e) => AuditorCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleEven: (json['coupleEven'] as List<dynamic>?)
          ?.map((e) => AuditorCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleOdd: (json['coupleOdd'] as List<dynamic>?)
          ?.map((e) => AuditorCouple.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupleId: json['coupleId'] as int?,
      weekDayId: json['weekDayId'] as int?,
    );

Map<String, dynamic> _$AuditorTableToJson(AuditorTable instance) =>
    <String, dynamic>{
      'coupleAll': instance.coupleAll,
      'coupleEven': instance.coupleEven,
      'coupleOdd': instance.coupleOdd,
      'coupleId': instance.coupleId,
      'weekDayId': instance.weekDayId,
    };

AuditorCouple _$AuditorCoupleFromJson(Map<String, dynamic> json) =>
    AuditorCouple(
      discName: json['discName'] as String? ?? '',
      prepName: json['prepName'] as String? ?? '',
      lessonType: json['lessonType'] as String? ?? '',
      loadDiscipId: json['loadDiscipId'] as int? ?? 0,
      groupName: json['groupName'] as String? ?? '',
      startWeekNum: json['startWeekNum'] as int? ?? 0,
      endWeekNum: json['endWeekNum'] as int? ?? 0,
      selectFlag: json['selectFlag'] as int? ?? 0,
      weekDayId: json['weekDayId'] as int? ?? 0,
      coupleId: json['coupleId'] as int? ?? 0,
    );

Map<String, dynamic> _$AuditorCoupleToJson(AuditorCouple instance) =>
    <String, dynamic>{
      'discName': instance.discName,
      'prepName': instance.prepName,
      'lessonType': instance.lessonType,
      'loadDiscipId': instance.loadDiscipId,
      'groupName': instance.groupName,
      'startWeekNum': instance.startWeekNum,
      'endWeekNum': instance.endWeekNum,
      'selectFlag': instance.selectFlag,
      'weekDayId': instance.weekDayId,
      'coupleId': instance.coupleId,
    };

AuditorWeekDayList _$AuditorWeekDayListFromJson(Map<String, dynamic> json) =>
    AuditorWeekDayList(
      id: json['Id'] as int?,
      dayNum: json['DayNum'] as int?,
      dayName: json['DayName'] as String?,
      dayNameShort: json['DayNameShort'] as String?,
    );

Map<String, dynamic> _$AuditorWeekDayListToJson(AuditorWeekDayList instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'DayNum': instance.dayNum,
      'DayName': instance.dayName,
      'DayNameShort': instance.dayNameShort,
    };

AuditorWeekTypeList _$AuditorWeekTypeListFromJson(Map<String, dynamic> json) =>
    AuditorWeekTypeList(
      id: json['Id'] as int?,
      name: json['Name'] as String?,
    );

Map<String, dynamic> _$AuditorWeekTypeListToJson(
        AuditorWeekTypeList instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
    };
