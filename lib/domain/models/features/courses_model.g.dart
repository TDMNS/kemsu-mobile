// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoursesModel _$CoursesModelFromJson(Map<String, dynamic> json) => CoursesModel(
      title: json['title'] as String,
      description: json['description'] as String?,
      lectures: (json['lectures'] as List<dynamic>)
          .map((e) => Lecture.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CoursesModelToJson(CoursesModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'lectures': instance.lectures,
    };

Lecture _$LectureFromJson(Map<String, dynamic> json) => Lecture(
      title: json['title'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$LectureToJson(Lecture instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
    };
