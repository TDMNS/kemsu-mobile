import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_day_card.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';

class ScheduleListPages extends StatelessWidget {
  const ScheduleListPages({
    super.key,
    required this.controller,
    required this.weekDays,
    required this.times,
  });

  final PageController controller;
  final List<WeekDay> weekDays;
  final List<CoupleList> times;

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
                title: weekDays[index].oddCouple1,
                time: times[0].description,
              ),
              WeekDayCard(
                title: weekDays[index].oddCouple2,
                time: times[1].description,
              ),
              WeekDayCard(
                title: weekDays[index].oddCouple3,
                time: times[2].description,
              ),
              WeekDayCard(
                title: weekDays[index].oddCouple4,
                time: times[3].description,
              ),
              WeekDayCard(
                title: weekDays[index].oddCouple5,
                time: times[4].description,
              ),
              WeekDayCard(
                title: weekDays[index].oddCouple6,
                time: times[5].description,
              ),
              WeekDayCard(
                title: weekDays[index].oddCouple7,
                time: times[6].description,
              ),
            ],
          ),
        );
      },
    );
  }
}
