import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stud_card_model.g.dart';

@JsonSerializable()
class StudCardModel extends Equatable {
  @JsonKey(name: "GROUP_NAME")
  final String? groupName;
  @JsonKey(name: "FACULTY")
  final String? faculty;
  @JsonKey(name: "SPECIALITY")
  final String? speciality;
  @JsonKey(name: "LEARN_FORM")
  final String? learnForm;
  @JsonKey(name: "FINFORM")
  final String? finform;

  const StudCardModel({
    this.groupName,
    this.faculty,
    this.speciality,
    this.learnForm,
    this.finform,
  });

  factory StudCardModel.fromJson(Map<String, dynamic> json) => _$StudCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudCardModelToJson(this);

  @override
  List<Object?> get props => [
        groupName,
        faculty,
        speciality,
        learnForm,
        finform, 
      ];
}
