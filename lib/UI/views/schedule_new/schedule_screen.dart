import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/schedule_new/schedule_bloc.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/UI/widgets.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: customAppBar(context, Localizable.pageSchedule),
        body: BlocBuilder<ScheduleBloc, ScheduleState>(
          bloc: _scheduleBloc,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            final scheduleTable = state.scheduleTableData.result.table;
            final List<WeekDay> weekDays = [
              scheduleTable.weekDay1,
              scheduleTable.weekDay2,
              scheduleTable.weekDay3,
              scheduleTable.weekDay4,
              scheduleTable.weekDay5,
              scheduleTable.weekDay6,
            ];
            final List<CoupleList> times = state.scheduleTableData.result.coupleList;

            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: InkWell(
                    onTap: () {
                      bool isSearch = false;
                      state.isTeacherSearching == true ? isSearch = false : isSearch = true;
                      _scheduleBloc.add(TeacherSearch(isTeacherSearching: isSearch));
                      _scheduleBloc.add(GetTeacherList());
                    },
                    child: _teacherSearchBar(state.isTeacherSearching),
                  ),
                ),
                state.isTeacherSearching
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 16,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.separated(
                                itemCount: state.teacherList!.teacherList.length,
                                itemBuilder: (context, index) {
                                  final teacher = state.teacherList!.teacherList[index];
                                  return InkWell(
                                    child: Text(
                                      teacher.fio,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 4.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 32.0,
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
                              child: ScheduleListPages(
                                controller: controller,
                                weekDays: weekDays,
                                times: times,
                                weekType: state.weekType,
                              ),
                            )
                          ],
                        ),
                      )
              ],
            );
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _teacherSearchBar(bool isSearching) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(26.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.6),
            ),
            const SizedBox(width: 12.0),
            Text(
              'Поиск преподавателя',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }

  _weekTypeButton(String title, WeekType weekType, state) {
    return GestureDetector(
      onTap: () => _scheduleBloc.add(ChangeWeekType(weekType: weekType)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(
          title,
          style: TextStyle(color: state.weekType == weekType ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        decoration: BoxDecoration(
          color: state.weekType == weekType ? Colors.black : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
