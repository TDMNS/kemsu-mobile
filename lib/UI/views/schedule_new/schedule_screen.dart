import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/UI/views/schedule_new/schedule_bloc.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_day_card.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _scheduleBloc = ScheduleBloc(
    const ScheduleState(),
    scheduleRepository: GetIt.I<AbstractScheduleRepository>(),
  );

  @override
  void initState() {
    _scheduleBloc.add(CurrentGroupLoadedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday - 1);
    return Scaffold(
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        bloc: _scheduleBloc,
        builder: (context, state) {
          if (state is CurrentGroupLoaded) {
            final scheduleTable = state.currentGroup?.result.table;
            final List<WeekDay> weekDays = [
              scheduleTable!.weekDay1,
              scheduleTable.weekDay2,
              scheduleTable.weekDay3,
              scheduleTable.weekDay4,
              scheduleTable.weekDay5,
              scheduleTable.weekDay6,
            ];
            final List<CoupleList> times = state.currentGroup!.result.coupleList;
            return Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0).copyWith(top: 80.0),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(26.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12.0),
                                Text(
                                  'Поиск преподавателя',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _weekTypeButton('Четная', WeekType.even, state),
                    const SizedBox(width: 12.0),
                    _weekTypeButton('Нечетная', WeekType.odd, state),
                  ],
                ),
                const Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blue.shade900],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      topLeft: Radius.circular(16.0),
                    ),
                  ),
                  child: ScheduleListPages(controller: controller, weekDays: weekDays, times: times),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  _weekTypeButton(String title, WeekType weekType, state) {
    return InkWell(
      onTap: () => _scheduleBloc.add(ChangeWeekType(weekType: weekType)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(
          title,
          style: TextStyle(color: state.weekType == WeekType.even ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        decoration: BoxDecoration(
          color: state.weekType == WeekType.even ? Colors.black : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
