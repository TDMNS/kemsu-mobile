import 'package:kemsu_app/domain/models/features/courses_model.dart';

abstract class AbstractFeaturesRepository {
  Future<List<CoursesModel>> getCoursesData();
}
