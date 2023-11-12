import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/schedule_new/auditor_schedule/auditor_schedule_screen.dart';
import 'package:kemsu_app/UI/views/schedule_new/group_select_schedule/group_select_schedule_screen.dart';
import 'package:kemsu_app/UI/views/schedule_new/schedule_bloc.dart';
import 'package:kemsu_app/UI/views/schedule_new/teacher_schedule/teacher_schedule_screen.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_type_radio.dart';
import 'package:kemsu_app/UI/widgets.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kemsu_app/generated/assets.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: false,
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

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 12.0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 8.0),
                      ScheduleTypeButton(
                        title: 'Преподаватель',
                        icon: Assets.iconsTeacherIcon,
                        myVoidCallback: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TeacherScheduleScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ScheduleTypeButton(
                        title: 'Аудитория',
                        icon: Assets.iconsCabinetIcon,
                        myVoidCallback: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AuditorScheduleScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ScheduleTypeButton(
                        title: 'Группа',
                        icon: Assets.iconsGroupIcon,
                        myVoidCallback: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GroupSelectScheduleScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 32.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WeekTypeRadio(
                            title: 'Четная',
                            weekType: WeekType.even,
                            currentWeekType: state.weekType,
                            onTap: () => _scheduleBloc.add(ChangeWeekType(weekType: WeekType.even)),
                          ),
                          const SizedBox(width: 12.0),
                          WeekTypeRadio(
                            title: 'Нечетная',
                            weekType: WeekType.odd,
                            currentWeekType: state.weekType,
                            onTap: () => _scheduleBloc.add(ChangeWeekType(weekType: WeekType.odd)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.lightBlue, Colors.blue.shade900],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          child: ScheduleListPages(
                            weekDays: state.scheduleTableData.result.table.weekDays,
                            times: state.scheduleTableData.result.coupleList,
                            weekType: state.weekType,
                            scheduleType: ScheduleType.current,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
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
