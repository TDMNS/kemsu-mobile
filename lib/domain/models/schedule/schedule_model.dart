import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kemsu_app/domain/models/schedule/get_full_couple.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel extends Equatable {
  final bool success;
  final ScheduleResult result;

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
class ScheduleResult extends Equatable {
  @JsonKey(name: 'WeekList')
  final List<ScheduleWeekList> weekList;
  @JsonKey(name: 'CoupleList')
  final List<ScheduleCoupleList> coupleList;
  @JsonKey(name: 'WeekTypeList')
  final List<ScheduleWeekTypeList> weekTypeList;
  @JsonKey(name: 'Table')
  final ScheduleTable table;

  const ScheduleResult({
    required this.weekList,
    required this.coupleList,
    required this.weekTypeList,
    required this.table,
  });

  factory ScheduleResult.fromJson(Map<String, dynamic> json) => _$ScheduleResultFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleResultToJson(this);

  @override
  List<Object?> get props => [
        weekList,
        coupleList,
        weekTypeList,
        table,
      ];
}

@JsonSerializable()
class ScheduleCoupleList extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'Num')
  final int num;
  @JsonKey(name: 'Description')
  final String description;

  const ScheduleCoupleList({
    required this.id,
    required this.num,
    required this.description,
  });

  factory ScheduleCoupleList.fromJson(Map<String, dynamic> json) => _$ScheduleCoupleListFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleCoupleListToJson(this);

  @override
  List<Object?> get props => [
        id,
        num,
        description,
      ];
}

@JsonSerializable()
class ScheduleTable extends Equatable {
  final ScheduleWeekDay weekDay1;
  final ScheduleWeekDay weekDay2;
  final ScheduleWeekDay weekDay3;
  final ScheduleWeekDay weekDay4;
  final ScheduleWeekDay weekDay5;
  final ScheduleWeekDay weekDay6;

  List<ScheduleWeekDay> get weekDays => [weekDay1, weekDay2, weekDay3, weekDay4, weekDay5, weekDay6];

  const ScheduleTable({
    required this.weekDay1,
    required this.weekDay2,
    required this.weekDay3,
    required this.weekDay4,
    required this.weekDay5,
    required this.weekDay6,
  });

  factory ScheduleTable.fromJson(Map<String, dynamic> json) => _$ScheduleTableFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleTableToJson(this);

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
class ScheduleWeekDay extends Equatable {
  final List<ScheduleCouple> coupleAll1;
  @JsonKey(name: 'coupleAll1_str')
  final String coupleAll1Str;
  final List<ScheduleCouple> coupleEven1;
  @JsonKey(name: 'coupleEven1_str')
  final String coupleEven1Str;
  final List<ScheduleCouple> coupleOdd1;
  @JsonKey(name: 'coupleOdd1_str')
  final String coupleOdd1Str;
  final List<ScheduleCouple> coupleAll2;
  @JsonKey(name: 'coupleAll2_str')
  final String coupleAll2Str;
  final List<ScheduleCouple> coupleEven2;
  @JsonKey(name: 'coupleEven2_str')
  final String coupleEven2Str;
  final List<ScheduleCouple> coupleOdd2;
  @JsonKey(name: 'coupleOdd2_str')
  final String coupleOdd2Str;
  final List<ScheduleCouple> coupleAll3;
  @JsonKey(name: 'coupleAll3_str')
  final String coupleAll3Str;
  final List<ScheduleCouple> coupleEven3;
  @JsonKey(name: 'coupleEven3_str')
  final String coupleEven3Str;
  final List<ScheduleCouple> coupleOdd3;
  @JsonKey(name: 'coupleOdd3_str')
  final String coupleOdd3Str;
  final List<ScheduleCouple> coupleAll4;
  @JsonKey(name: 'coupleAll4_str')
  final String coupleAll4Str;
  final List<ScheduleCouple> coupleEven4;
  @JsonKey(name: 'coupleEven4_str')
  final String coupleEven4Str;
  final List<ScheduleCouple> coupleOdd4;
  @JsonKey(name: 'coupleOdd4_str')
  final String coupleOdd4Str;
  final List<ScheduleCouple> coupleAll5;
  @JsonKey(name: 'coupleAll5_str')
  final String coupleAll5Str;
  final List<ScheduleCouple> coupleEven5;
  @JsonKey(name: 'coupleEven5_str')
  final String coupleEven5Str;
  final List<ScheduleCouple> coupleOdd5;
  @JsonKey(name: 'coupleOdd5_str')
  final String coupleOdd5Str;
  final List<ScheduleCouple> coupleAll6;
  @JsonKey(name: 'coupleAll6_str')
  final String coupleAll6Str;
  final List<ScheduleCouple> coupleEven6;
  @JsonKey(name: 'coupleEven6_str')
  final String coupleEven6Str;
  final List<ScheduleCouple> coupleOdd6;
  @JsonKey(name: 'coupleOdd6_str')
  final String coupleOdd6Str;
  final List<ScheduleCouple> coupleAll7;
  @JsonKey(name: 'coupleAll7_str')
  final String coupleAll7Str;
  final List<ScheduleCouple> coupleEven7;
  @JsonKey(name: 'coupleEven7_str')
  final String coupleEven7Str;
  final List<ScheduleCouple> coupleOdd7;
  @JsonKey(name: 'coupleOdd7_str')
  final String coupleOdd7Str;

  List<String> get oddCouple => [oddCouple1, oddCouple2, oddCouple3, oddCouple4, oddCouple5, oddCouple6, oddCouple7];
  List<String> get evenCouple => [evenCouple1, evenCouple2, evenCouple3, evenCouple4, evenCouple5, evenCouple6, evenCouple7];

  // String get oddCouple => uneven.map((e) => e.fullCeil).join(', \n\n');
  // String get evenCouple => even.map((e) => e.fullCeil).join(', \n\n');

  String get oddCouple1 => getOddCoupleStr(coupleAll1Str, coupleOdd1Str);
  String get oddCouple2 => getOddCoupleStr(coupleAll2Str, coupleOdd2Str);
  String get oddCouple3 => getOddCoupleStr(coupleAll3Str, coupleOdd3Str);
  String get oddCouple4 => getOddCoupleStr(coupleAll4Str, coupleOdd4Str);
  String get oddCouple5 => getOddCoupleStr(coupleAll5Str, coupleOdd5Str);
  String get oddCouple6 => getOddCoupleStr(coupleAll6Str, coupleOdd6Str);
  String get oddCouple7 => getOddCoupleStr(coupleAll7Str, coupleOdd7Str);

  String get evenCouple1 => getEvenCoupleStr(coupleAll1Str, coupleEven1Str);
  String get evenCouple2 => getEvenCoupleStr(coupleAll2Str, coupleEven2Str);
  String get evenCouple3 => getEvenCoupleStr(coupleAll3Str, coupleEven3Str);
  String get evenCouple4 => getEvenCoupleStr(coupleAll4Str, coupleEven4Str);
  String get evenCouple5 => getEvenCoupleStr(coupleAll5Str, coupleEven5Str);
  String get evenCouple6 => getEvenCoupleStr(coupleAll6Str, coupleEven6Str);
  String get evenCouple7 => getEvenCoupleStr(coupleAll7Str, coupleEven7Str);

  const ScheduleWeekDay({
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

  factory ScheduleWeekDay.fromJson(Map<String, dynamic> json) => _$ScheduleWeekDayFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleWeekDayToJson(this);

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
class ScheduleCouple extends Equatable {
  @JsonKey(name: 'DiscName', defaultValue: '')
  final String discName;
  @JsonKey(name: 'PrepName', defaultValue: '')
  final String prepName;
  @JsonKey(name: 'AuditoryName', defaultValue: '')
  final String auditoryName;
  @JsonKey(defaultValue: '')
  final String lessonType;
  @JsonKey(defaultValue: 0)
  final int loadDiscipId;
  @JsonKey(defaultValue: '')
  final String periodTypeName;
  @JsonKey(name: 'PeriodTypeId', defaultValue: 0)
  final int periodTypeId;
  @JsonKey(defaultValue: 0)
  final int maxWeekNum;
  @JsonKey(defaultValue: 0)
  final int minWeekNum;
  @JsonKey(defaultValue: 0)
  final int selectFlag;
  @JsonKey(defaultValue: '')
  final String periodTypePref;
  @JsonKey(defaultValue: 0)
  final int loadFlag;
  @JsonKey(defaultValue: 0)
  final int scheduleId;

  const ScheduleCouple({
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

  factory ScheduleCouple.fromJson(Map<String, dynamic> json) => _$ScheduleCoupleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleCoupleToJson(this);

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
class ScheduleWeekList extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'DayNum')
  final int dayNum;
  @JsonKey(name: 'DayName')
  final String dayName;
  @JsonKey(name: 'DayNameShort')
  final String dayNameShort;

  const ScheduleWeekList({
    required this.id,
    required this.dayNum,
    required this.dayName,
    required this.dayNameShort,
  });

  factory ScheduleWeekList.fromJson(Map<String, dynamic> json) => _$ScheduleWeekListFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleWeekListToJson(this);

  @override
  List<Object?> get props => [id, dayNum, dayName, dayNameShort];
}

@JsonSerializable()
class ScheduleWeekTypeList extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'Name')
  final String name;

  const ScheduleWeekTypeList({
    required this.id,
    required this.name,
  });

  factory ScheduleWeekTypeList.fromJson(Map<String, dynamic> json) => _$ScheduleWeekTypeListFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleWeekTypeListToJson(this);

  @override
  List<Object?> get props => [id, name];
}
