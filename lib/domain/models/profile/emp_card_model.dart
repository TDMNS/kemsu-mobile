import 'package:json_annotation/json_annotation.dart';

part 'emp_card_model.g.dart';

@JsonSerializable()
class EmpCardModel {
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "empList")
  final List<EmpList> empList;

  EmpCardModel({
    required this.success,
    required this.empList,
  });

  factory EmpCardModel.fromJson(Map<String, dynamic> json) => _$EmpCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmpCardModelToJson(this);
}

@JsonSerializable()
class EmpList {
  @JsonKey(name: "LOGIN")
  final String login;
  @JsonKey(name: "LAST_NAME")
  final String lastName;
  @JsonKey(name: "FIRST_NAME")
  final String firstName;
  @JsonKey(name: "MIDDLE_NAME")
  final String middleName;
  @JsonKey(name: "POST_NAME")
  final dynamic postName;
  @JsonKey(name: "DEP")
  final String dep;
  @JsonKey(name: "STATUS")
  final String status;

  EmpList({
    required this.login,
    required this.lastName,
    required this.firstName,
    required this.middleName,
    required this.postName,
    required this.dep,
    required this.status,
  });

  factory EmpList.fromJson(Map<String, dynamic> json) => _$EmpListFromJson(json);
  Map<String, dynamic> toJson() => _$EmpListToJson(this);
}
