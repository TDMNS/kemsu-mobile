import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/schedule_new/auditor_schedule/auditor_schedule_bloc.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/search_bar.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_num_title.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_type_radio.dart';
import 'package:kemsu_app/UI/widgets.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_list_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

class AuditorScheduleScreen extends StatefulWidget {
  const AuditorScheduleScreen({super.key});

  @override
  State<AuditorScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<AuditorScheduleScreen> {
  final _auditorScheduleBloc = AuditorScheduleBloc(
    const AuditorScheduleState(),
    scheduleRepository: GetIt.I<AbstractScheduleRepository>(),
  );

  @override
  void initState() {
    _auditorScheduleBloc.add(GetAuditorList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: customAppBar(context, Localizable.auditorScheduleTitle),
      body: BlocBuilder<AuditorScheduleBloc, AuditorScheduleState>(
        bloc: _auditorScheduleBloc,
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
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '${state.selectedAuditor!.auditoryName}, ${state.selectedAuditor!.auditoryType}, ${state.selectedAuditor!.auditoryBuild}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _auditorScheduleBloc.add(AuditorUnselect()),
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                    )
                  : ScheduleSearchBar(
                      title: Localizable.auditorScheduleSearch,
                      onChanged: (value) => _auditorScheduleBloc.add(AuditorSearchQuery(searchQuery: value)),
                      onSubmitted: (value) => _auditorScheduleBloc.add(AuditorSearchQuery(searchQuery: value)),
                    ),
              const SizedBox(
                height: 12.0,
              ),
              if (state.isSelected) ...[
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
                      onTap: () => _auditorScheduleBloc.add(ChangeTypeWeek(weekType: WeekType.even)),
                    ),
                    const SizedBox(width: 12.0),
                    WeekTypeRadio(
                      title: 'Нечетная',
                      weekType: WeekType.odd,
                      currentWeekType: state.weekType,
                      onTap: () => _auditorScheduleBloc.add(ChangeTypeWeek(weekType: WeekType.odd)),
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
                  child: state.isSelected
                      ? ScheduleListPages(
                          weekType: state.weekType,
                          auditorSchedule: state.auditorSchedule,
                          scheduleType: ScheduleType.auditor,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
                          itemBuilder: (context, index) {
                            final auditor = state.searchResult[index];

                            return AuditorCard(
                              auditor: auditor,
                              onTap: (value) => _auditorScheduleBloc.add(AuditorChoice(auditor: value)),
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
}

class AuditorCard extends StatelessWidget {
  const AuditorCard({
    super.key,
    required this.auditor,
    required this.onTap,
  });

  final AuditorListElement auditor;
  final ValueSetter<AuditorListElement> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(auditor),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '${auditor.auditoryName}, ${auditor.auditoryType}, ${auditor.auditoryBuild}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
