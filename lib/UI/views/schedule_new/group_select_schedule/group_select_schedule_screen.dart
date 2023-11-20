import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/schedule_new/group_select_schedule/group_select_schedule_bloc.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/search_bar.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_num_title.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_type_radio.dart';
import 'package:kemsu_app/UI/widgets.dart';
import 'package:kemsu_app/domain/models/schedule/faculty_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/group_list_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSelectScheduleScreen extends StatefulWidget {
  const GroupSelectScheduleScreen({super.key});

  @override
  State<GroupSelectScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<GroupSelectScheduleScreen> {
  final _groupSelectSchedule = GroupSelectScheduleBloc(
    const GroupSelectScheduleState(),
    scheduleRepository: GetIt.I<AbstractScheduleRepository>(),
  );

  @override
  void initState() {
    _groupSelectSchedule.add(GetFacultyList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: false,
        appBar: customAppBar(context, Localizable.groupSchedule),
        body: BlocBuilder<GroupSelectScheduleBloc, GroupSelectScheduleState>(
          bloc: _groupSelectSchedule,
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
                state.isGroupSelected
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                state.selectedGroup!.groupName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _groupSelectSchedule.add(FacultyUnselect()),
                              icon: const Icon(Icons.close),
                            )
                          ],
                        ),
                      )
                    : ScheduleSearchBar(
                        title: state.isFacultySelected ? Localizable.groupSearch : Localizable.facultySearch,
                        onChanged: (value) => _groupSelectSchedule.add(GroupSearchQuery(searchQuery: value)),
                        onSubmitted: (value) => _groupSelectSchedule.add(GroupSearchQuery(searchQuery: value)),
                      ),
                const SizedBox(
                  height: 12.0,
                ),
                if (state.isGroupSelected) ...[
                  WeekNum(
                    title: '${state.currentDayData?.currentDay?.weekNum}',
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WeekTypeRadio(
                        title: 'Четная',
                        weekType: WeekType.even,
                        currentWeekType: state.weekType,
                        onTap: () => _groupSelectSchedule.add(ChangeWeekType(weekType: WeekType.even)),
                      ),
                      const SizedBox(width: 12.0),
                      WeekTypeRadio(
                        title: 'Нечетная',
                        weekType: WeekType.odd,
                        currentWeekType: state.weekType,
                        onTap: () => _groupSelectSchedule.add(ChangeWeekType(weekType: WeekType.odd)),
                      ),
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
                    child: state.isGroupSelected
                        ? ScheduleListPages(
                            weekDays: state.scheduleTableData.result.table.weekDays,
                            times: state.scheduleTableData.result.coupleList,
                            weekType: state.weekType,
                            // auditorSchedule: state.auditorSchedule,
                            scheduleType: ScheduleType.current,
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
                            itemBuilder: (context, index) {
                              if (!state.isFacultySelected) {
                                final faculty = state.searchFacultyResult[index];
                                return ItemCard(
                                  faculty: faculty,
                                  onFacultyTap: (value) => _groupSelectSchedule.add(FacultyChoice(faculty: value)),
                                );
                              }

                              if (state.isFacultySelected) {
                                final group = state.searchGroupResult[index];
                                return ItemCard(
                                  group: group,
                                  isGroup: true,
                                  onGroupTap: (value) => _groupSelectSchedule.add(GroupChoice(group: value)),
                                );
                              }
                              return null;
                            },
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 6.0,
                            ),
                            itemCount: !state.isFacultySelected ? state.searchFacultyResult.length : state.searchGroupResult.length,
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    this.faculty,
    this.group,
    this.onFacultyTap,
    this.onGroupTap,
    this.isGroup = false,
  });

  final FacultyResult? faculty;
  final GroupResult? group;
  final ValueSetter<FacultyResult>? onFacultyTap;
  final ValueSetter<GroupResult>? onGroupTap;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => isGroup ? onGroupTap!(group!) : onFacultyTap!(faculty!),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            isGroup ? group!.groupName : faculty!.facultyName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ScheduleTypeButton extends StatelessWidget {
  const ScheduleTypeButton({
    super.key,
    required this.title,
    required this.icon,
    required this.myVoidCallback,
  });

  final String title;
  final String icon;
  final VoidCallback myVoidCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: myVoidCallback,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                color: Colors.black,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleChoice extends StatelessWidget {
  const ScheduleChoice({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title),
      ),
    );
  }
}
