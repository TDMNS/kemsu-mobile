import 'package:json_annotation/json_annotation.dart';

part 'courses_model.g.dart';

@JsonSerializable()
class CoursesModel {
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "lectures")
  final List<Lecture> lectures;

  CoursesModel({
    required this.title,
    this.description,
    required this.lectures,
  });

  factory CoursesModel.fromJson(Map<String, dynamic> json) => _$CoursesModelFromJson(json);
  Map<String, dynamic> toJson() => _$CoursesModelToJson(this);
}

@JsonSerializable()
class Lecture {
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "url")
  final String url;

  Lecture({
    required this.title,
    required this.url,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => _$LectureFromJson(json);
  Map<String, dynamic> toJson() => _$LectureToJson(this);
}
