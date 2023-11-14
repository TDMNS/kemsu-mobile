import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/schedule_new/teacher_schedule/teacher_schedule_bloc.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/search_bar.dart';
import 'package:kemsu_app/UI/widgets.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

import '../../../../domain/models/schedule/schedule_teacher_model.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  final _teacherScheduleBloc = TeacherScheduleBloc(
    const TeacherScheduleState(),
    scheduleRepository: GetIt.I<AbstractScheduleRepository>(),
  );

  @override
  void initState() {
    _teacherScheduleBloc.add(GetTeacherList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: customAppBar(context, Localizable.prepScheduleTitle),
      body: BlocBuilder<TeacherScheduleBloc, TeacherScheduleState>(
        bloc: _teacherScheduleBloc,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 12.0,
              ),
              state.isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            state.selectedTeacher!.fio,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _teacherScheduleBloc.add(TeacherUnselect()),
                          icon: const Icon(Icons.close),
                        )
                      ],
                    )
                  : ScheduleSearchBar(
                      title: Localizable.prepScheduleSearch,
                      onChanged: (value) => _teacherScheduleBloc.add(TeacherSearchQuery(searchQuery: value)),
                      onSubmitted: (value) => _teacherScheduleBloc.add(TeacherSearchQuery(searchQuery: value)),
                    ),
              const SizedBox(
                height: 12.0,
              ),
              if (state.isSelected) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _weekTypeButton('Четная', WeekType.even, state),
                    const SizedBox(width: 12.0),
                    _weekTypeButton('Нечетная', WeekType.odd, state),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                )
              ],
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blue.shade900],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: state.isSelected
                      ? ScheduleListPages(
                          weekType: state.weekType,
                          teacherSchedule: state.teacherSchedule!.result.prepScheduleTable,
                          scheduleType: ScheduleType.teacher,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
                          itemBuilder: (context, index) {
                            final teacher = state.searchResult[index];
                            return TeacherCard(
                              teacher: teacher,
                              onTap: (value) => _teacherScheduleBloc.add(TeacherChoice(teacher: value)),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 6.0,
                          ),
                          itemCount: state.searchResult.length,
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _weekTypeButton(String title, WeekType weekType, state) {
    return GestureDetector(
      onTap: () => _teacherScheduleBloc.add(ChangeTypeWeek(weekType: weekType)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: state.weekType == weekType ? Colors.black : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          title,
          style: TextStyle(color: state.weekType == weekType ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  const TeacherCard({
    super.key,
    required this.teacher,
    required this.onTap,
  });

  final TeacherList teacher;
  final ValueSetter<TeacherList> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(teacher),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            teacher.fio,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
