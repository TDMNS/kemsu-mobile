import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/current_group_model.g.dart';

@JsonSerializable()
class CurrentGroupModel extends Equatable {
  final bool success;
  final List<CurrentGroupData> currentGroupList;

  const CurrentGroupModel({required this.success, required this.currentGroupList});

  factory CurrentGroupModel.fromJson(Map<String, dynamic> json) => _$CurrentGroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentGroupModelToJson(this);

  @override
  List<Object?> get props => [success, currentGroupList];
}

@JsonSerializable()
class CurrentGroupData extends Equatable {
  final int facultyId;
  final String facultyName;
  final int groupId;
  final String groupName;
  final String studyYear;
  final int semesterId;

  const CurrentGroupData({
    required this.facultyId,
    required this.facultyName,
    required this.groupId,
    required this.groupName,
    required this.studyYear,
    required this.semesterId,
  });

  factory CurrentGroupData.fromJson(Map<String, dynamic> json) => _$CurrentGroupDataFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentGroupDataToJson(this);

  @override
  List<Object?> get props => [
        facultyId,
        facultyName,
        groupId,
        groupName,
        studyYear,
        semesterId,
      ];
}
