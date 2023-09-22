import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/UI/views/schedule_new/schedule_bloc.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _scheduleBloc = ScheduleBloc(
    GetIt.I<AbstractScheduleRepository>(),
  );

  @override
  void initState() {
    _scheduleBloc.add(const CurrentGroupLoadedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = List.generate(10, (index) => 'Title $index');
    List<String> times = List.generate(10, (index) => 'Time $index');
    return Scaffold(
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        bloc: _scheduleBloc,
        builder: (context, state) {
          if (state is CurrentGroupLoaded) {
            final scheduleTable = state.currentGroup.result.table;
            final times = state.currentGroup.result.coupleList;
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
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(26.0)),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      child: Text(
                        'Четная',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16.0)),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(16.0)),
                        child: Text('Нечетная')),
                  ],
                ),
                const Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.lightBlue, Colors.blue.shade900], begin: Alignment.bottomLeft, end: Alignment.topRight),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 22.0),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 8.0,
                            // child: Divider(
                            //   color: Colors.white.withOpacity(0.4),
                            //   thickness: 0.5,
                            // ),
                          ),
                      itemBuilder: (context, index) {
                        return Container(
                          // height: 60,
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    scheduleTable.weekDay1.coupleEven6Str,
                                    style: const TextStyle(color: Colors.white, fontSize: 18.0),
                                  ),
                                ),
                                // const Spacer(),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      times[index].description,
                                      style: TextStyle(color: Colors.white.withOpacity(0.4)),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: 7),
                )
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
