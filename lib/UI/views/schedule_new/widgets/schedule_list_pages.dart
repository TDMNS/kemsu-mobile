import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/schedule_new/schedule_bloc.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_day_card.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_teacher_model.dart';

class ScheduleListPages extends StatelessWidget {
  const ScheduleListPages({
    super.key,
    required this.controller,
    required this.weekDays,
    required this.times,
    required this.weekType,
    this.isTeacher = false,
    this.teacherSchedule,
  });

  final PageController controller;
  final List<WeekDay> weekDays;
  final List<CoupleList> times;
  final WeekType weekType;
  final bool isTeacher;
  final List<Ceil>? teacherSchedule;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: weekDays.length,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12.0),
              Text(
                weekDayTitle(index),
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              WeekDayCard(
                title: weekType == WeekType.odd
                    ? isTeacher
                        ? teacherSchedule![index].even[0].fullCeil
                        : weekDays[index].oddCouple1
                    : weekDays[index].evenCouple1,
                time: times[0].description,
              ),
              WeekDayCard(
                title: weekType == WeekType.odd ? weekDays[index].oddCouple2 : weekDays[index].evenCouple2,
                time: times[1].description,
              ),
              WeekDayCard(
                title: weekType == WeekType.odd ? weekDays[index].oddCouple3 : weekDays[index].evenCouple3,
                time: times[2].description,
              ),
              WeekDayCard(
                title: weekType == WeekType.odd ? weekDays[index].oddCouple4 : weekDays[index].evenCouple4,
                time: times[3].description,
              ),
              WeekDayCard(
                title: weekType == WeekType.odd ? weekDays[index].oddCouple5 : weekDays[index].evenCouple5,
                time: times[4].description,
              ),
              WeekDayCard(
                title: weekType == WeekType.odd ? weekDays[index].oddCouple6 : weekDays[index].evenCouple6,
                time: times[5].description,
              ),
              WeekDayCard(
                title: weekType == WeekType.odd ? weekDays[index].oddCouple7 : weekDays[index].evenCouple7,
                time: times[6].description,
              ),
            ],
          ),
        );
      },
    );
  }
}
