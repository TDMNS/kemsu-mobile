import 'package:json_annotation/json_annotation.dart';

part 'auditor_list_model.g.dart';

@JsonSerializable()
class AuditorList {
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "auditorList")
  final List<AuditorListElement> auditorList;

  AuditorList({
    required this.success,
    required this.auditorList,
  });

  factory AuditorList.fromJson(Map<String, dynamic> json) => _$AuditorListFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorListToJson(this);
}

@JsonSerializable()
class AuditorListElement {
  @JsonKey(name: "auditoryId")
  final int auditoryId;
  @JsonKey(name: "auditoryName")
  final String auditoryName;
  @JsonKey(name: "auditoryType")
  final String auditoryType;
  @JsonKey(name: "auditoryBuild")
  final String auditoryBuild;
  @JsonKey(name: "auditoryBuildNumber")
  final int auditoryBuildNumber;

  AuditorListElement({
    required this.auditoryId,
    required this.auditoryName,
    required this.auditoryType,
    required this.auditoryBuild,
    required this.auditoryBuildNumber,
  });

  factory AuditorListElement.fromJson(Map<String, dynamic> json) => _$AuditorListElementFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorListElementToJson(this);
}
