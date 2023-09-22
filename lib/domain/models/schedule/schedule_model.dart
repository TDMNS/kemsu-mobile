import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel extends Equatable {
  final bool success;
  final Result result;

  const ScheduleModel({
    required this.success,
    required this.result,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => _$ScheduleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  @override
  List<Object?> get props => [
        success,
        result,
      ];
}

@JsonSerializable()
class Result extends Equatable {
  @JsonKey(name: 'WeekList')
  final List<WeekList> weekList;
  @JsonKey(name: 'CoupleList')
  final List<CoupleList> coupleList;
  @JsonKey(name: 'WeekTypeList')
  final List<WeekTypeList> weekTypeList;
  @JsonKey(name: 'Table')
  final Table table;

  const Result({
    required this.weekList,
    required this.coupleList,
    required this.weekTypeList,
    required this.table,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);

  @override
  List<Object?> get props => [
        weekList,
        coupleList,
        weekTypeList,
        table,
      ];
}

@JsonSerializable()
class CoupleList extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'Num')
  final int num;
  @JsonKey(name: 'Description')
  final String description;

  const CoupleList({
    required this.id,
    required this.num,
    required this.description,
  });

  factory CoupleList.fromJson(Map<String, dynamic> json) => _$CoupleListFromJson(json);
  Map<String, dynamic> toJson() => _$CoupleListToJson(this);

  @override
  List<Object?> get props => [
        id,
        num,
        description,
      ];
}

@JsonSerializable()
class Table extends Equatable {
  final WeekDay weekDay1;
  final WeekDay weekDay2;
  final WeekDay weekDay3;
  final WeekDay weekDay4;
  final WeekDay weekDay5;
  final WeekDay weekDay6;

  const Table({
    required this.weekDay1,
    required this.weekDay2,
    required this.weekDay3,
    required this.weekDay4,
    required this.weekDay5,
    required this.weekDay6,
  });

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);
  Map<String, dynamic> toJson() => _$TableToJson(this);

  @override
  List<Object?> get props => [
        weekDay1,
        weekDay2,
        weekDay3,
        weekDay4,
        weekDay5,
        weekDay6,
      ];
}

@JsonSerializable()
class WeekDay extends Equatable {
  final List<dynamic> coupleAll1;
  @JsonKey(name: 'coupleAll1_str')
  final String coupleAll1Str;
  final List<dynamic> coupleEven1;
  @JsonKey(name: 'coupleEven1_str')
  final String coupleEven1Str;
  final List<dynamic> coupleOdd1;
  @JsonKey(name: 'coupleOdd1_str')
  final String coupleOdd1Str;
  final List<dynamic> coupleAll2;
  @JsonKey(name: 'coupleAll2_str')
  final String coupleAll2Str;
  final List<dynamic> coupleEven2;
  @JsonKey(name: 'coupleEven2_str')
  final String coupleEven2Str;
  final List<dynamic> coupleOdd2;
  @JsonKey(name: 'coupleOdd2_str')
  final String coupleOdd2Str;
  final List<dynamic> coupleAll3;
  @JsonKey(name: 'coupleAll3_str')
  final String coupleAll3Str;
  final List<dynamic> coupleEven3;
  @JsonKey(name: 'coupleEven3_str')
  final String coupleEven3Str;
  final List<dynamic> coupleOdd3;
  @JsonKey(name: 'coupleOdd3_str')
  final String coupleOdd3Str;
  final List<dynamic> coupleAll4;
  @JsonKey(name: 'coupleAll4_str')
  final String coupleAll4Str;
  final List<dynamic> coupleEven4;
  @JsonKey(name: 'coupleEven4_str')
  final String coupleEven4Str;
  final List<dynamic> coupleOdd4;
  @JsonKey(name: 'coupleOdd4_str')
  final String coupleOdd4Str;
  final List<dynamic> coupleAll5;
  @JsonKey(name: 'coupleAll5_str')
  final String coupleAll5Str;
  final List<Couple> coupleEven5;
  @JsonKey(name: 'coupleEven5_str')
  final String coupleEven5Str;
  final List<Couple> coupleOdd5;
  @JsonKey(name: 'coupleOdd5_str')
  final String coupleOdd5Str;
  final List<dynamic> coupleAll6;
  @JsonKey(name: 'coupleAll6_str')
  final String coupleAll6Str;
  final List<Couple> coupleEven6;
  @JsonKey(name: 'coupleEven6_str')
  final String coupleEven6Str;
  final List<Couple> coupleOdd6;
  @JsonKey(name: 'coupleOdd6_str')
  final String coupleOdd6Str;
  final List<dynamic> coupleAll7;
  @JsonKey(name: 'coupleAll7_str')
  final String coupleAll7Str;
  final List<Couple> coupleEven7;
  @JsonKey(name: 'coupleEven7_str')
  final String coupleEven7Str;
  final List<Couple> coupleOdd7;
  @JsonKey(name: 'coupleOdd7_str')
  final String coupleOdd7Str;

  const WeekDay({
    required this.coupleAll1,
    required this.coupleAll1Str,
    required this.coupleEven1,
    required this.coupleEven1Str,
    required this.coupleOdd1,
    required this.coupleOdd1Str,
    required this.coupleAll2,
    required this.coupleAll2Str,
    required this.coupleEven2,
    required this.coupleEven2Str,
    required this.coupleOdd2,
    required this.coupleOdd2Str,
    required this.coupleAll3,
    required this.coupleAll3Str,
    required this.coupleEven3,
    required this.coupleEven3Str,
    required this.coupleOdd3,
    required this.coupleOdd3Str,
    required this.coupleAll4,
    required this.coupleAll4Str,
    required this.coupleEven4,
    required this.coupleEven4Str,
    required this.coupleOdd4,
    required this.coupleOdd4Str,
    required this.coupleAll5,
    required this.coupleAll5Str,
    required this.coupleEven5,
    required this.coupleEven5Str,
    required this.coupleOdd5,
    required this.coupleOdd5Str,
    required this.coupleAll6,
    required this.coupleAll6Str,
    required this.coupleEven6,
    required this.coupleEven6Str,
    required this.coupleOdd6,
    required this.coupleOdd6Str,
    required this.coupleAll7,
    required this.coupleAll7Str,
    required this.coupleEven7,
    required this.coupleEven7Str,
    required this.coupleOdd7,
    required this.coupleOdd7Str,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) => _$WeekDayFromJson(json);
  Map<String, dynamic> toJson() => _$WeekDayToJson(this);

  @override
  List<Object?> get props => [
        coupleAll1,
        coupleAll1Str,
        coupleEven1,
        coupleEven1Str,
        coupleOdd1,
        coupleOdd1Str,
        coupleAll2,
        coupleAll2Str,
        coupleEven2,
        coupleEven2Str,
        coupleOdd2,
        coupleOdd2Str,
        coupleAll3,
        coupleAll3Str,
        coupleEven3,
        coupleEven3Str,
        coupleOdd3,
        coupleOdd3Str,
        coupleAll4,
        coupleAll4Str,
        coupleEven4,
        coupleEven4Str,
        coupleOdd4,
        coupleOdd4Str,
        coupleAll5,
        coupleAll5Str,
        coupleEven5,
        coupleEven5Str,
        coupleOdd5,
        coupleOdd5Str,
        coupleAll6,
        coupleAll6Str,
        coupleEven6,
        coupleEven6Str,
        coupleOdd6,
        coupleOdd6Str,
        coupleAll7,
        coupleAll7Str,
        coupleEven7,
        coupleEven7Str,
        coupleOdd7,
        coupleOdd7Str,
      ];
}

@JsonSerializable()
class Couple extends Equatable {
  @JsonKey(name: 'DiscName')
  final String discName;
  @JsonKey(name: 'PrepName')
  final String prepName;
  @JsonKey(name: 'AuditoryName')
  final String auditoryName;
  final String lessonType;
  final int loadDiscipId;
  final String periodTypeName;
  @JsonKey(name: 'PeriodTypeId')
  final int periodTypeId;
  final int maxWeekNum;
  final int minWeekNum;
  final int selectFlag;
  final String periodTypePref;
  final int loadFlag;
  final int scheduleId;

  const Couple({
    required this.discName,
    required this.prepName,
    required this.auditoryName,
    required this.lessonType,
    required this.loadDiscipId,
    required this.periodTypeName,
    required this.periodTypeId,
    required this.maxWeekNum,
    required this.minWeekNum,
    required this.selectFlag,
    required this.periodTypePref,
    required this.loadFlag,
    required this.scheduleId,
  });

  factory Couple.fromJson(Map<String, dynamic> json) => _$CoupleFromJson(json);
  Map<String, dynamic> toJson() => _$CoupleToJson(this);

  @override
  List<Object?> get props => [
        discName,
        prepName,
        auditoryName,
        lessonType,
        loadDiscipId,
        periodTypeName,
        periodTypeId,
        maxWeekNum,
        minWeekNum,
        selectFlag,
        periodTypePref,
        loadFlag,
        scheduleId,
      ];
}

@JsonSerializable()
class WeekList extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'DayNum')
  final int dayNum;
  @JsonKey(name: 'DayName')
  final String dayName;
  @JsonKey(name: 'DayNameShort')
  final String dayNameShort;

  const WeekList({
    required this.id,
    required this.dayNum,
    required this.dayName,
    required this.dayNameShort,
  });

  factory WeekList.fromJson(Map<String, dynamic> json) => _$WeekListFromJson(json);
  Map<String, dynamic> toJson() => _$WeekListToJson(this);

  @override
  List<Object?> get props => [id, dayNum, dayName, dayNameShort];
}

@JsonSerializable()
class WeekTypeList extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'Name')
  final String name;

  const WeekTypeList({
    required this.id,
    required this.name,
  });

  factory WeekTypeList.fromJson(Map<String, dynamic> json) => _$WeekTypeListFromJson(json);
  Map<String, dynamic> toJson() => _$WeekTypeListToJson(this);

  @override
  List<Object?> get props => [id, name];
}

// import 'package:equatable/equatable.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// part 'generated/schedule_model.g.dart';
//
// @JsonSerializable()
// class ScheduleModel extends Equatable {
//   final bool success;
//   final ScheduleResult result;
//
//   const ScheduleModel({required this.success, required this.result});
//
//   factory ScheduleModel.fromJson(Map<String, dynamic> json) => _$ScheduleModelFromJson(json);
//   Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);
//
//   @override
//   List<Object?> get props => [success, result];
// }
//
// @JsonSerializable()
// class ScheduleResult extends Equatable {
//   @JsonKey(name: 'WeekList')
//   final List<WeekData> weekList;
//   @JsonKey(name: 'CoupleList')
//   final List<CoupleTime> coupleList;
//   @JsonKey(name: 'WeekTypeList')
//   final List<WeekType> weekTypeList;
//   @JsonKey(name: 'Table')
//   final ScheduleTable table;
//
//   const ScheduleResult({required this.weekList, required this.coupleList, required this.weekTypeList, required this.table});
//
//   factory ScheduleResult.fromJson(Map<String, dynamic> json) => _$ScheduleResultFromJson(json);
//   Map<String, dynamic> toJson() => _$ScheduleResultToJson(this);
//
//   @override
//   List<Object?> get props => [
//         weekList,
//         coupleList,
//         weekTypeList,
//         table,
//       ];
// }
//
// @JsonSerializable()
// class WeekData extends Equatable {
//   @JsonKey(name: 'Id')
//   final int id;
//   @JsonKey(name: 'DayNum')
//   final int dayNum;
//   @JsonKey(name: 'DayName')
//   final String dayName;
//   @JsonKey(name: 'DayNameShort')
//   final String dayNameShort;
//
//   const WeekData({required this.id, required this.dayNum, required this.dayName, required this.dayNameShort});
//
//   factory WeekData.fromJson(Map<String, dynamic> json) => _$WeekDataFromJson(json);
//   Map<String, dynamic> toJson() => _$WeekDataToJson(this);
//
//   @override
//   List<Object?> get props => [id, dayNum, dayName, dayNameShort];
// }
//
// @JsonSerializable()
// class CoupleTime extends Equatable {
//   @JsonKey(name: 'Id')
//   final int id;
//   @JsonKey(name: 'Num')
//   final int num;
//   @JsonKey(name: 'Description')
//   final String description;
//
//   const CoupleTime({required this.id, required this.num, required this.description});
//
//   factory CoupleTime.fromJson(Map<String, dynamic> json) => _$CoupleTimeFromJson(json);
//   Map<String, dynamic> toJson() => _$CoupleTimeToJson(this);
//
//   @override
//   List<Object?> get props => [id, num, description];
// }
//
// @JsonSerializable()
// class WeekType extends Equatable {
//   @JsonKey(name: 'Id')
//   final int id;
//   @JsonKey(name: 'Name')
//   final String name;
//
//   const WeekType({
//     required this.id,
//     required this.name,
//   });
//
//   factory WeekType.fromJson(Map<String, dynamic> json) => _$WeekTypeFromJson(json);
//   Map<String, dynamic> toJson() => _$WeekTypeToJson(this);
//
//   @override
//   List<Object?> get props => [id, name];
// }
//
// @JsonSerializable()
// class ScheduleTable extends Equatable {
//   @JsonKey(name: 'weekDay1')
//   final WeekDayData monday;
//   @JsonKey(name: 'weekDay2')
//   final WeekDayData tuesday;
//   @JsonKey(name: 'weekDay3')
//   final WeekDayData wednesday;
//   @JsonKey(name: 'weekDay4')
//   final WeekDayData thursday;
//   @JsonKey(name: 'weekDay5')
//   final WeekDayData friday;
//   @JsonKey(name: 'weekDay6')
//   final WeekDayData saturday;
//
//   const ScheduleTable({required this.monday, required this.tuesday, required this.wednesday, required this.thursday, required this.friday, required this.saturday});
//
//   factory ScheduleTable.fromJson(Map<String, dynamic> json) => _$ScheduleTableFromJson(json);
//   Map<String, dynamic> toJson() => _$ScheduleTableToJson(this);
//
//   @override
//   List<Object?> get props => [monday, tuesday, wednesday, thursday, friday, saturday];
// }
//
// @JsonSerializable()
// class WeekDayData extends Equatable {
//   final List<CoupleData> coupleAll1;
//   @JsonKey(name: 'coupleAll1_str')
//   final String coupleAll1Str;
//   final List<CoupleData> coupleEven1;
//   @JsonKey(name: 'coupleEven1_str')
//   final String coupleEven1Str;
//   final List<CoupleData> coupleOdd1;
//   @JsonKey(name: 'coupleOdd1_str')
//   final String coupleOdd1Str;
//   final List<CoupleData> coupleAll2;
//   @JsonKey(name: 'coupleAll2_str')
//   final String coupleAll2Str;
//   final List<CoupleData> coupleEven2;
//   @JsonKey(name: 'coupleEven2_str')
//   final String coupleEven2Str;
//   final List<CoupleData> coupleOdd2;
//   @JsonKey(name: 'coupleOdd2_str')
//   final String coupleOdd2Str;
//   final List<CoupleData> coupleAll3;
//   @JsonKey(name: 'coupleAll3_str')
//   final String coupleAll3Str;
//   final List<CoupleData> coupleEven3;
//   @JsonKey(name: 'coupleEven3_str')
//   final String coupleEven3Str;
//   final List<CoupleData> coupleOdd3;
//   @JsonKey(name: 'coupleOdd3_str')
//   final String coupleOdd3Str;
//   final List<CoupleData> coupleAll4;
//   @JsonKey(name: 'coupleAll4_str')
//   final String coupleAll4Str;
//   final List<CoupleData> coupleEven4;
//   @JsonKey(name: 'coupleEven4_str')
//   final String coupleEven4Str;
//   final List<CoupleData> coupleOdd4;
//   @JsonKey(name: 'coupleOdd4_str')
//   final String coupleOdd4Str;
//   final List<CoupleData> coupleAll5;
//   @JsonKey(name: 'coupleAll5_str')
//   final String coupleAll5Str;
//   final List<CoupleData> coupleEven5;
//   @JsonKey(name: 'coupleEven5_str')
//   final String coupleEven5Str;
//   final List<CoupleData> coupleOdd5;
//   @JsonKey(name: 'coupleOdd5_str')
//   final String coupleOdd5Str;
//   final List<CoupleData> coupleAll6;
//   @JsonKey(name: 'coupleAll6_str')
//   final String coupleAll6Str;
//   final List<CoupleData> coupleEven6;
//   @JsonKey(name: 'coupleEven6_str')
//   final String coupleEven6Str;
//   final List<CoupleData> coupleOdd6;
//   @JsonKey(name: 'coupleOdd6_str')
//   final String coupleOdd6Str;
//   final List<CoupleData> coupleAll7;
//   @JsonKey(name: 'coupleAll7_str')
//   final String coupleAll7Str;
//   final List<CoupleData> coupleEven7;
//   @JsonKey(name: 'coupleEven7_str')
//   final String coupleEven7Str;
//   final List<CoupleData> coupleOdd7;
//   @JsonKey(name: 'coupleOdd7_str')
//   final String coupleOdd7Str;
//
//   const WeekDayData({
//     required this.coupleAll1,
//     required this.coupleAll1Str,
//     required this.coupleEven1,
//     required this.coupleEven1Str,
//     required this.coupleOdd1,
//     required this.coupleOdd1Str,
//     required this.coupleAll2,
//     required this.coupleAll2Str,
//     required this.coupleEven2,
//     required this.coupleEven2Str,
//     required this.coupleOdd2,
//     required this.coupleOdd2Str,
//     required this.coupleAll3,
//     required this.coupleAll3Str,
//     required this.coupleEven3,
//     required this.coupleEven3Str,
//     required this.coupleOdd3,
//     required this.coupleOdd3Str,
//     required this.coupleAll4,
//     required this.coupleAll4Str,
//     required this.coupleEven4,
//     required this.coupleEven4Str,
//     required this.coupleOdd4,
//     required this.coupleOdd4Str,
//     required this.coupleAll5,
//     required this.coupleAll5Str,
//     required this.coupleEven5,
//     required this.coupleEven5Str,
//     required this.coupleOdd5,
//     required this.coupleOdd5Str,
//     required this.coupleAll6,
//     required this.coupleAll6Str,
//     required this.coupleEven6,
//     required this.coupleEven6Str,
//     required this.coupleOdd6,
//     required this.coupleOdd6Str,
//     required this.coupleAll7,
//     required this.coupleAll7Str,
//     required this.coupleEven7,
//     required this.coupleEven7Str,
//     required this.coupleOdd7,
//     required this.coupleOdd7Str,
//   });
//
//   factory WeekDayData.fromJson(Map<String, dynamic> json) => _$WeekDayDataFromJson(json);
//   Map<String, dynamic> toJson() => _$WeekDayDataToJson(this);
//
//   @override
//   List<Object?> get props => [
//         coupleAll1,
//         coupleAll1Str,
//         coupleEven1,
//         coupleEven1Str,
//         coupleOdd1,
//         coupleOdd1Str,
//         coupleAll2,
//         coupleAll2Str,
//         coupleEven2,
//         coupleEven2Str,
//         coupleOdd2,
//         coupleOdd2Str,
//         coupleAll3,
//         coupleAll3Str,
//         coupleEven3,
//         coupleEven3Str,
//         coupleOdd3,
//         coupleOdd3Str,
//         coupleAll4,
//         coupleAll4Str,
//         coupleEven4,
//         coupleEven4Str,
//         coupleOdd4,
//         coupleOdd4Str,
//         coupleAll5,
//         coupleAll5Str,
//         coupleEven5,
//         coupleEven5Str,
//         coupleOdd5,
//         coupleOdd5Str,
//         coupleAll6,
//         coupleAll6Str,
//         coupleEven6,
//         coupleEven6Str,
//         coupleOdd6,
//         coupleOdd6Str,
//         coupleAll7,
//         coupleAll7Str,
//         coupleEven7,
//         coupleEven7Str,
//         coupleOdd7,
//         coupleOdd7Str,
//       ];
// }
//
// @JsonSerializable()
// class CoupleData extends Equatable {
//   @JsonKey(name: 'DiscName')
//   final String discName;
//   @JsonKey(name: 'PrepName')
//   final String prepName;
//   @JsonKey(name: 'AuditoryName')
//   final String auditoryName;
//   final String lessonType;
//   final String periodTypeName;
//   @JsonKey(name: 'PeriodTypeId')
//   final String periodTypeId;
//   final int maxWeekNum;
//   final int minWeekNum;
//   final String periodTypePref;
//
//   const CoupleData({
//     required this.discName,
//     required this.prepName,
//     required this.auditoryName,
//     required this.lessonType,
//     required this.periodTypeName,
//     required this.periodTypeId,
//     required this.maxWeekNum,
//     required this.minWeekNum,
//     required this.periodTypePref,
//   });
//
//   factory CoupleData.fromJson(Map<String, dynamic> json) => _$CoupleDataFromJson(json);
//   Map<String, dynamic> toJson() => _$CoupleDataToJson(this);
//
//   @override
//   List<Object?> get props => [
//         discName,
//         prepName,
//         auditoryName,
//         lessonType,
//         periodTypeName,
//         periodTypeId,
//         maxWeekNum,
//         minWeekNum,
//         periodTypePref,
//       ];
// }
