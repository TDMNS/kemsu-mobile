import 'package:json_annotation/json_annotation.dart';
import 'package:kemsu_app/domain/models/schedule/get_full_couple.dart';

part 'auditor_schedule_model.g.dart';

@JsonSerializable()
class AuditorSchedule {
  @JsonKey(name: "success")
  final bool? success;
  @JsonKey(name: "weekDayList")
  final List<AuditorWeekDayList>? weekDayList;
  @JsonKey(name: "coupleList")
  final List<AuditorCoupleList>? coupleList;
  @JsonKey(name: "weekTypeList")
  final List<AuditorWeekTypeList>? weekTypeList;
  @JsonKey(name: "table")
  final List<List<AuditorTable>>? table;

  AuditorSchedule({
    required this.success,
    required this.weekDayList,
    required this.coupleList,
    required this.weekTypeList,
    required this.table,
  });

  factory AuditorSchedule.fromJson(Map<String, dynamic> json) => _$AuditorScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorScheduleToJson(this);
}

@JsonSerializable()
class AuditorCoupleList {
  @JsonKey(name: "Id")
  final int? id;
  @JsonKey(name: "Num")
  final int? num;
  @JsonKey(name: "Description")
  final String? description;

  AuditorCoupleList({
    required this.id,
    required this.num,
    required this.description,
  });

  factory AuditorCoupleList.fromJson(Map<String, dynamic> json) => _$AuditorCoupleListFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorCoupleListToJson(this);
}

@JsonSerializable()
class AuditorTable {
  @JsonKey(name: "coupleAll")
  final List<AuditorCouple>? coupleAll;
  @JsonKey(name: "coupleEven")
  final List<AuditorCouple>? coupleEven;
  @JsonKey(name: "coupleOdd")
  final List<AuditorCouple>? coupleOdd;
  @JsonKey(name: "coupleId")
  final int? coupleId;
  @JsonKey(name: "weekDayId")
  final int? weekDayId;

  AuditorTable({
    required this.coupleAll,
    required this.coupleEven,
    required this.coupleOdd,
    required this.coupleId,
    required this.weekDayId,
  });

  String get allCouple => coupleAll!.map((e) => e.fullCouple).join(', \n\n');
  String get evenCouple => coupleEven!.map((e) => e.fullCouple).join(', \n\n');
  String get oddCouple => coupleOdd!.map((e) => e.fullCouple).join(', \n\n');

  String get oddAllCouple => getOddCoupleStr(allCouple, oddCouple);
  String get evenAllCouple => getEvenCoupleStr(allCouple, evenCouple);

  factory AuditorTable.fromJson(Map<String, dynamic> json) => _$AuditorTableFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorTableToJson(this);
}

@JsonSerializable()
class AuditorCouple {
  @JsonKey(name: "discName", defaultValue: '')
  final String? discName;
  @JsonKey(name: "prepName", defaultValue: '')
  final String? prepName;
  @JsonKey(name: "lessonType", defaultValue: '')
  final String? lessonType;
  @JsonKey(name: "loadDiscipId", defaultValue: 0)
  final int? loadDiscipId;
  @JsonKey(name: "groupName", defaultValue: '')
  final String? groupName;
  @JsonKey(name: "startWeekNum", defaultValue: 0)
  final int? startWeekNum;
  @JsonKey(name: "endWeekNum", defaultValue: 0)
  final int? endWeekNum;
  @JsonKey(name: "selectFlag", defaultValue: 0)
  final int? selectFlag;
  @JsonKey(name: "weekDayId", defaultValue: 0)
  final int? weekDayId;
  @JsonKey(name: "coupleId", defaultValue: 0)
  final int? coupleId;

  AuditorCouple({
    required this.discName,
    required this.prepName,
    required this.lessonType,
    required this.loadDiscipId,
    required this.groupName,
    required this.startWeekNum,
    required this.endWeekNum,
    required this.selectFlag,
    required this.weekDayId,
    required this.coupleId,
  });

  String get fullCouple => '$discName, $lessonType, $prepName, $groupName, нед с $startWeekNum по $endWeekNum';

  factory AuditorCouple.fromJson(Map<String, dynamic> json) => _$AuditorCoupleFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorCoupleToJson(this);
}

@JsonSerializable()
class AuditorWeekDayList {
  @JsonKey(name: "Id")
  final int? id;
  @JsonKey(name: "DayNum")
  final int? dayNum;
  @JsonKey(name: "DayName")
  final String? dayName;
  @JsonKey(name: "DayNameShort")
  final String? dayNameShort;

  AuditorWeekDayList({
    required this.id,
    required this.dayNum,
    required this.dayName,
    required this.dayNameShort,
  });

  factory AuditorWeekDayList.fromJson(Map<String, dynamic> json) => _$AuditorWeekDayListFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorWeekDayListToJson(this);
}

@JsonSerializable()
class AuditorWeekTypeList {
  @JsonKey(name: "Id")
  final int? id;
  @JsonKey(name: "Name")
  final String? name;

  AuditorWeekTypeList({
    required this.id,
    required this.name,
  });

  factory AuditorWeekTypeList.fromJson(Map<String, dynamic> json) => _$AuditorWeekTypeListFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorWeekTypeListToJson(this);
}
