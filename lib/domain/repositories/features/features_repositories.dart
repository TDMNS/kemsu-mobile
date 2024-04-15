import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kemsu_app/domain/models/features/courses_model.dart';
import 'package:kemsu_app/domain/repositories/features/abstract_features_repository.dart';

class FeatureRepository implements AbstractFeaturesRepository {
  @override
  Future<List<CoursesModel>> getCoursesData() async {
    var response = json.decode(await rootBundle.loadString('assets/preloaded/courses.json'));
    var list = response as Iterable;
    Iterable<CoursesModel> dto = list.map((e) => CoursesModel.fromJson(e));
    return dto.toList();
  }
}
