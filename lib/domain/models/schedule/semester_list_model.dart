import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/semester_list_model.g.dart';

@JsonSerializable()
class SemesterListModel extends Equatable {
  final bool success;
  final List<SemesterResult> result;

  const SemesterListModel({required this.success, required this.result});

  factory SemesterListModel.fromJson(Map<String, dynamic> json) => _$SemesterListModelFromJson(json);
  Map<String, dynamic> toJson() => _$SemesterListModelToJson(this);

  @override
  List<Object?> get props => [success, result];
}

@JsonSerializable()
class SemesterResult extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'StudyYear')
  final String studyYear;
  @JsonKey(name: 'SemesterType')
  final int semesterType;
  @JsonKey(name: 'WeekNum')
  final int weekNum;
  @JsonKey(name: 'Title')
  final String title;

  const SemesterResult({required this.id, required this.studyYear, required this.semesterType, required this.weekNum, required this.title});

  factory SemesterResult.fromJson(Map<String, dynamic> json) => _$SemesterResultFromJson(json);
  Map<String, dynamic> toJson() => _$SemesterResultToJson(this);

  @override
  List<Object?> get props => [id, studyYear, semesterType, weekNum, title];
}
