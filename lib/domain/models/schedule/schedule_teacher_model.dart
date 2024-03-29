import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_teacher_model.g.dart';

@JsonSerializable()
class ScheduleTeacherModel extends Equatable {
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "teacherList")
  final List<TeacherList> teacherList;

  const ScheduleTeacherModel({
    required this.success,
    required this.teacherList,
  });

  factory ScheduleTeacherModel.fromJson(Map<String, dynamic> json) => _$ScheduleTeacherModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleTeacherModelToJson(this);

  @override
  List<Object?> get props => [
        success,
        teacherList,
      ];
}

@JsonSerializable()
class TeacherList extends Equatable {
  @JsonKey(name: "prepId")
  final int prepId;
  @JsonKey(name: "fio")
  final String fio;

  const TeacherList({
    required this.prepId,
    required this.fio,
  });

  factory TeacherList.fromJson(Map<String, dynamic> json) => _$TeacherListFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherListToJson(this);

  @override
  List<Object?> get props => [
        prepId,
        fio,
      ];
}

@JsonSerializable()
class TeacherScheduleModel {
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "result")
  final TeacherResult result;

  TeacherScheduleModel({
    required this.success,
    required this.result,
  });

  factory TeacherScheduleModel.fromJson(Map<String, dynamic> json) => _$TeacherScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherScheduleModelToJson(this);
}

@JsonSerializable()
class TeacherResult {
  @JsonKey(name: "weekList")
  final List<TeacherWeek> weekList;
  @JsonKey(name: "coupleList")
  final List<TeacherCouple> coupleList;
  @JsonKey(name: "prepScheduleTable")
  final List<PrepScheduleTable> prepScheduleTable;

  TeacherResult({
    required this.weekList,
    required this.coupleList,
    required this.prepScheduleTable,
  });

  factory TeacherResult.fromJson(Map<String, dynamic> json) => _$TeacherResultFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherResultToJson(this);
}

@JsonSerializable()
class TeacherCouple {
  @JsonKey(name: "Id")
  final int id;
  @JsonKey(name: "Num")
  final int num;
  @JsonKey(name: "Description")
  final String description;

  TeacherCouple({
    required this.id,
    required this.num,
    required this.description,
  });

  factory TeacherCouple.fromJson(Map<String, dynamic> json) => _$TeacherCoupleFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherCoupleToJson(this);
}

@JsonSerializable()
class PrepScheduleTable {
  @JsonKey(name: "weekDay")
  final TeacherWeek weekDay;
  @JsonKey(name: "ceilList")
  final List<TeacherCeilList> ceilList;

  PrepScheduleTable({
    required this.weekDay,
    required this.ceilList,
  });

  factory PrepScheduleTable.fromJson(Map<String, dynamic> json) => _$PrepScheduleTableFromJson(json);

  Map<String, dynamic> toJson() => _$PrepScheduleTableToJson(this);
}

@JsonSerializable()
class TeacherCeilList {
  @JsonKey(name: "couple")
  final TeacherCouple couple;
  @JsonKey(name: "ceil")
  final PrepCeil ceil;

  TeacherCeilList({
    required this.couple,
    required this.ceil,
  });

  factory TeacherCeilList.fromJson(Map<String, dynamic> json) => _$TeacherCeilListFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherCeilListToJson(this);
}

@JsonSerializable()
class PrepCeil {
  @JsonKey(name: "uneven")
  final List<TeacherCeil> uneven;
  @JsonKey(name: "even")
  final List<TeacherCeil> even;

  String get unevenCeil => uneven.map((e) => e.fullCeil).join(', \n\n');
  String get evenCeil => even.map((e) => e.fullCeil).join(', \n\n');

  PrepCeil({
    required this.uneven,
    required this.even,
  });

  factory PrepCeil.fromJson(Map<String, dynamic> json) => _$PrepCeilFromJson(json);
  Map<String, dynamic> toJson() => _$PrepCeilToJson(this);
}

@JsonSerializable()
class TeacherCeil {
  @JsonKey(name: "discName")
  final String discName;
  @JsonKey(name: "auditoryName")
  final String auditoryName;
  @JsonKey(name: "lessonType")
  final String lessonType;
  @JsonKey(name: "loadDiscipId")
  final int loadDiscipId;
  @JsonKey(name: "groupName")
  final String groupName;
  @JsonKey(name: "startWeekNum")
  final int startWeekNum;
  @JsonKey(name: "endWeekNum")
  final int endWeekNum;
  @JsonKey(name: "selectFlag")
  final int selectFlag;

  String get fullCeil => '$discName, $groupName, $lessonType, $auditoryName, с $startWeekNum по $endWeekNum нед.';

  TeacherCeil({
    required this.discName,
    required this.auditoryName,
    required this.lessonType,
    required this.loadDiscipId,
    required this.groupName,
    required this.startWeekNum,
    required this.endWeekNum,
    required this.selectFlag,
  });

  factory TeacherCeil.fromJson(Map<String, dynamic> json) => _$TeacherCeilFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherCeilToJson(this);
}

@JsonSerializable()
class TeacherWeek {
  @JsonKey(name: "Id")
  final int id;
  @JsonKey(name: "DayNum")
  final int dayNum;
  @JsonKey(name: "DayName")
  final String dayName;
  @JsonKey(name: "DayNameShort")
  final String dayNameShort;

  TeacherWeek({
    required this.id,
    required this.dayNum,
    required this.dayName,
    required this.dayNameShort,
  });

  factory TeacherWeek.fromJson(Map<String, dynamic> json) => _$TeacherWeekFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherWeekToJson(this);
}
