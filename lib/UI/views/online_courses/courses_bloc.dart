import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/domain/models/features/courses_model.dart';
import 'package:kemsu_app/domain/repositories/features/abstract_features_repository.dart';

part 'courses_events.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc(super.initialState, {required this.featuresRepository}) {
    on<LoadCourses>(_loadCourses);
  }

  final AbstractFeaturesRepository featuresRepository;

  Future<void> _loadCourses(LoadCourses event, Emitter<CoursesState> emit) async {
    var courses = await featuresRepository.getCoursesData();
    print('TEST BLOC:: $courses');
    emit(state.copyWith(courses: Lce.content(courses)));
  }
}
