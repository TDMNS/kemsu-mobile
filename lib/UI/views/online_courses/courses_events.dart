part of 'courses_bloc.dart';

abstract class CoursesEvent extends Equatable {}

class LoadCourses extends CoursesEvent {
  LoadCourses();

  @override
  List<Object> get props => [];
}
