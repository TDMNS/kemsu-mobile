import 'package:json_annotation/json_annotation.dart';

part 'emp_card_model.g.dart';

@JsonSerializable()
class EmpCardModel {
  @JsonKey(name: "success")
  final bool? success;
  @JsonKey(name: "empList")
  final List<EmpList>? empList;

  EmpCardModel({
    this.success,
    this.empList,
  });

  factory EmpCardModel.fromJson(Map<String, dynamic> json) => _$EmpCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmpCardModelToJson(this);
}

@JsonSerializable()
class EmpList {
  @JsonKey(name: "DEP")
  final String? dep;

  EmpList({
    this.dep,
  });

  factory EmpList.fromJson(Map<String, dynamic> json) => _$EmpListFromJson(json);
  Map<String, dynamic> toJson() => _$EmpListToJson(this);
}
