import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stud_card_model.g.dart';

@JsonSerializable()
class StudCardModel extends Equatable {
  @JsonKey(name: "ID")
  final int id;
  @JsonKey(name: "FACULTY_ID")
  final int facultyId;
  @JsonKey(name: "SPECIALITY_ID")
  final int specialityId;
  @JsonKey(name: "PERSON_ID")
  final int personId;
  @JsonKey(name: "COURS")
  final int cours;
  @JsonKey(name: "GROUP_ID")
  final int groupId;
  @JsonKey(name: "GROUP_NAME")
  final String groupName;
  @JsonKey(name: "FACULTY")
  final String faculty;
  @JsonKey(name: "SPECIALITY")
  final String speciality;
  @JsonKey(name: "SPECIALIZATION")
  final dynamic specialization;
  @JsonKey(name: "QUALIFICATION")
  final String qualification;
  @JsonKey(name: "LEARN_FORM")
  final String learnForm;
  @JsonKey(name: "STATUS_STR")
  final String statusStr;
  @JsonKey(name: "FINFORM")
  final String finform;
  @JsonKey(name: "BEP")
  final String bep;
  @JsonKey(name: "START_YEAR")
  final int startYear;
  @JsonKey(name: "ADMISSION_DATE")
  final String admissionDate;

  const StudCardModel({
    required this.id,
    required this.facultyId,
    required this.specialityId,
    required this.personId,
    required this.cours,
    required this.groupId,
    required this.groupName,
    required this.faculty,
    required this.speciality,
    required this.specialization,
    required this.qualification,
    required this.learnForm,
    required this.statusStr,
    required this.finform,
    required this.bep,
    required this.startYear,
    required this.admissionDate,
  });

  factory StudCardModel.fromJson(Map<String, dynamic> json) => _$StudCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudCardModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        facultyId,
        specialityId,
        personId,
        cours,
        groupId,
        groupName,
        faculty,
        speciality,
        specialization,
        qualification,
        learnForm,
        statusStr,
        finform,
        bep,
        startYear,
        admissionDate,
      ];
}
