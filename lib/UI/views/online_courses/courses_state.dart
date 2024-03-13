part of 'courses_bloc.dart';

class CoursesState extends Equatable {
  final Lce<List<CoursesModel>> courses;
  const CoursesState({
    this.courses = const Lce.loading(),
  });

  CoursesState copyWith({
    Lce<List<CoursesModel>>? courses,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
    );
  }

  @override
  List<Object?> get props => [courses];
}
