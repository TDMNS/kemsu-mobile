import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/faculty_list_model.g.dart';

@JsonSerializable()
class FacultyListModel extends Equatable {
  final bool success;
  final List<FacultyResult> result;

  const FacultyListModel({required this.success, required this.result});

  factory FacultyListModel.fromJson(Map<String, dynamic> json) => _$FacultyListModelFromJson(json);
  Map<String, dynamic> toJson() => _$FacultyListModelToJson(this);

  @override
  List<Object?> get props => [success, result];
}

@JsonSerializable()
class FacultyResult extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'Faculty')
  final String facultyName;

  const FacultyResult({required this.id, required this.facultyName});

  factory FacultyResult.fromJson(Map<String, dynamic> json) => _$FacultyResultFromJson(json);
  Map<String, dynamic> toJson() => _$FacultyResultToJson(this);

  @override
  List<Object?> get props => [id, facultyName];
}
