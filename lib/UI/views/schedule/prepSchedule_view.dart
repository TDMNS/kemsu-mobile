import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kemsu_app/UI/views/schedule/prepSchedule_model.dart';
import 'package:kemsu_app/UI/views/schedule/prepSchedule_viewmodel.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_viewmodel.dart';

import 'package:stacked/stacked.dart';

import '../../widgets.dart';

List<DropdownMenuItem<String>> dropdownItems = [];

class PrepScheduleView extends StatefulWidget {
  const PrepScheduleView({Key? key}) : super(key: key);

  @override
  State<PrepScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<PrepScheduleView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrepScheduleViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => PrepScheduleViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness
                      .dark), //прозрачность statusbar и установка тёмных иконок
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(
                      context); //расфокус textfield при нажатии на экран
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: model.circle
                    ? Container(
                        color: Colors.white,
                        child: const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
                    : Scaffold(
                        extendBody: true,
                        extendBodyBehindAppBar: true,
                        appBar: customAppBar(context, model, 'Расписание'),
                        //bottomNavigationBar: customBottomBar(context, model),
                        body: _prepSchedule(context, model)),
              ));
        });
  }
}

_prepSchedule(BuildContext context, PrepScheduleViewModel model) {
  dropdownItems = List.generate(
    model.teacherList.length,
    (index) => DropdownMenuItem(
      value: model.teacherList[index].prepId.toString(),
      child: Text(
        '${model.teacherList[index].fio}',
      ),
    ),
  );
  return ListView(
    children: <Widget>[
      model.currentTeacherID != null
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TypeAheadField<Teacher?>(
                hideSuggestionsOnKeyboardHide: false,
                textFieldConfiguration: const TextFieldConfiguration(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    hintText: 'Выбрать преподавателя',
                  ),
                ),
                suggestionsCallback: TeacherApi.getTeacherData,
                itemBuilder: (context, Teacher? suggestion) {
                  final user = suggestion!;

                  return ListTile(
                    title: Text(user.fio),
                  );
                },
                noItemsFoundBuilder: (context) => Container(
                  height: 100,
                  child: const Center(
                    child: Text(
                      'Нет результатов',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                onSuggestionSelected: (Teacher? suggestion) {
                  final user = suggestion!;
                  model.changeTeacher(user.prepId, user.fio);
                  print(user.fio);
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text('Выбран преподаватель: ${user.fio}'),
                    ));
                },
              ),
            ),
      model.teacherId != null
          ? Center(
              child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {},
                child: Text('${model.teacherFIO}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ))
          : const SizedBox(),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: model.teacherId == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            model.choiceDay('back');
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          )),
                      model.indexDay == 1
                          ? const Text(
                              'Понедельник',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 2
                          ? const Text(
                              'Вторник',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 3
                          ? const Text(
                              'Среда',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 4
                          ? const Text(
                              'Четверг',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 5
                          ? const Text(
                              'Пятница',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 6
                          ? const Text(
                              'Суббота',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 7
                          ? const Text(
                              'Воскресенье',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      IconButton(
                          onPressed: () {
                            model.choiceDay('next');
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          )),
                    ],
                  ),
                )),
      model.teacherId == null
          ? const SizedBox()
          : Stack(
              children: [
                ListTile(
                  title: const Text('четная'),
                  leading: Radio(
                    value: 1,
                    groupValue: model.weekId,
                    onChanged: (value) {
                      model.changeWeek(value);
                      print(model.weekId);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2),
                  child: ListTile(
                    title: const Text('нечетная'),
                    leading: Radio(
                      value: 0,
                      groupValue: model.weekId,
                      onChanged: (value) {
                        model.changeWeek(value);
                        print(model.weekId);
                      },
                    ),
                  ),
                )
              ],
            ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: model.teacherId == null
            ? const SizedBox()
            : model.circle
                ? Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : _choiceDay(model),
      ),
      const SizedBox(
        height: 50,
      ),
    ],
  );
}

_choiceDay(model) {
  if (model.indexDay == 1) {
    return _mondayTable(model);
  } else if (model.indexDay == 2) {
    return _tuesdayTable(model);
  } else if (model.indexDay == 3) {
    return _wednesdayTable(model);
  } else if (model.indexDay == 4) {
    return _thursdayTable(model);
  } else if (model.indexDay == 5) {
    return _fridayTable(model);
  } else if (model.indexDay == 6) {
    return _saturdayTable(model);
  } else if (model.indexDay == 7) {
    return _tableDay7(model);
  }
}

_mondayTable(PrepScheduleViewModel model) {
  return model.circle
      ? Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        )
      : Table(
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Время',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Пары',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![0].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![0].ceilList![0]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![0].ceilList![0].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![0].ceilList![0].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![0].ceilList![0].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![0].ceilList![0].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![0].ceilList![0].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![0].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![1].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![0].ceilList![1]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![0].ceilList![1].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![0].ceilList![1].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![0].ceilList![1].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId! == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![0].ceilList![1].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![0].ceilList![1].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![1].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![2].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![0].ceilList![2]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![0].ceilList![2].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![0].ceilList![2].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![0].ceilList![2].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![0].ceilList![2].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![0].ceilList![2].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![2].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![3].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![0].ceilList![3]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![0].ceilList![3].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![0].ceilList![3].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![0].ceilList![3].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![0].ceilList![3].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![0].ceilList![3].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![3].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![4].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![0].ceilList![4]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![0].ceilList![4].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![0].ceilList![4].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![0].ceilList![4].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![0].ceilList![4].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![0].ceilList![4].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![4].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![5].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![0].ceilList![5]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![0].ceilList![5].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![0].ceilList![5].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![0].ceilList![5].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![0].ceilList![5].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![0].ceilList![5].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![5].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![6].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![0].ceilList![6]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![0].ceilList![6].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![0].ceilList![6].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![0].ceilList![6].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![0].ceilList![6].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![0].ceilList![6].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![0].ceilList![6].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ])
          ],
        );
}

_tuesdayTable(PrepScheduleViewModel model) {
  return model.circle
      ? Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        )
      : Table(
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Время',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Пары',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![0].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![1].ceilList![0]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![1].ceilList![0].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![1].ceilList![0].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![1].ceilList![0].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![1].ceilList![0].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![1].ceilList![0].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![0].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![1].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![1].ceilList![1]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![1].ceilList![1].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![1].ceilList![1].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![1].ceilList![1].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![1].ceilList![1].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![1].ceilList![1].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![1].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![2].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![1].ceilList![2]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![1].ceilList![2].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![1].ceilList![2].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![1].ceilList![2].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![1].ceilList![2].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![1].ceilList![2].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![2].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![3].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![1].ceilList![3]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![1].ceilList![3].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![1].ceilList![3].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![1].ceilList![3].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![1].ceilList![3].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![1].ceilList![3].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![3].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![4].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![1].ceilList![4]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![1].ceilList![4].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![1].ceilList![4].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![1].ceilList![4].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![1].ceilList![4].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![1].ceilList![4].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![4].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![5].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![1].ceilList![5]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![1].ceilList![5].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![1].ceilList![5].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![1].ceilList![5].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![1].ceilList![5].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![1].ceilList![5].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![5].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![6].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![1].ceilList![6]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![1].ceilList![6].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![1].ceilList![6].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![1].ceilList![6].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![1].ceilList![6].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![1].ceilList![6].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![1].ceilList![6].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ])
          ],
        );
}

_wednesdayTable(PrepScheduleViewModel model) {
  return model.circle
      ? Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        )
      : Table(
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Время',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Пары',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![0].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![2].ceilList![0]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![2].ceilList![0].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![2].ceilList![0].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![2].ceilList![0].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![2].ceilList![0].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![2].ceilList![0].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![0].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![1].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![2].ceilList![1]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![2].ceilList![1].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![2].ceilList![1].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![2].ceilList![1].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![2].ceilList![1].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![2].ceilList![1].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![1].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![2].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![2].ceilList![2]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![2].ceilList![2].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![2].ceilList![2].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![2].ceilList![2].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![2].ceilList![2].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![2].ceilList![2].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![2].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![3].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![2].ceilList![3]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![2].ceilList![3].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![2].ceilList![3].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![2].ceilList![3].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![2].ceilList![3].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![2].ceilList![3].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![3].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![4].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![2].ceilList![4]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![2].ceilList![4].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![2].ceilList![4].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![2].ceilList![4].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![2].ceilList![4].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![2].ceilList![4].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![4].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![5].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![2].ceilList![5]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![2].ceilList![5].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![2].ceilList![5].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![2].ceilList![5].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![2].ceilList![5].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![2].ceilList![5].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![5].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![6].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![2].ceilList![6]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![2].ceilList![6].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![2].ceilList![6].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![2].ceilList![6].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![2].ceilList![6].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![2].ceilList![6].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![2].ceilList![6].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ])
          ],
        );
}

_thursdayTable(PrepScheduleViewModel model) {
  return model.circle
      ? Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        )
      : Table(
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Время',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Пары',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![0].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![3].ceilList![0]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![3].ceilList![0].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![3].ceilList![0].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![3].ceilList![0].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![3].ceilList![0].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![3].ceilList![0].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![0].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![1].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![3].ceilList![1]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![3].ceilList![1].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![3].ceilList![1].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![3].ceilList![1].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![3].ceilList![1].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![3].ceilList![1].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![1].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![2].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![3].ceilList![2]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![3].ceilList![2].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![3].ceilList![2].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![3].ceilList![2].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![3].ceilList![2].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![3].ceilList![2].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![2].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![3].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![3].ceilList![3]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![3].ceilList![3].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![3].ceilList![3].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![3].ceilList![3].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![3].ceilList![3].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![3].ceilList![3].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![3].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![4].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![3].ceilList![4]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![3].ceilList![4].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![3].ceilList![4].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![3].ceilList![4].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![3].ceilList![4].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![3].ceilList![4].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![4].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![5].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![3].ceilList![5]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![3].ceilList![5].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![3].ceilList![5].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![3].ceilList![5].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![3].ceilList![5].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![3].ceilList![5].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![5].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![6].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![3].ceilList![6]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![3].ceilList![6].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![3].ceilList![6].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![3].ceilList![6].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![3].ceilList![6].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![3].ceilList![6].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![3].ceilList![6].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ])
          ],
        );
}

_fridayTable(PrepScheduleViewModel model) {
  return model.circle
      ? Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        )
      : Table(
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Время',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Пары',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![0].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![4].ceilList![0]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![4].ceilList![0].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![4].ceilList![0].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![4].ceilList![0].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![4].ceilList![0].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![4].ceilList![0].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![0].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![1].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![4].ceilList![1]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![4].ceilList![1].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![4].ceilList![1].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![4].ceilList![1].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![4].ceilList![1].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![4].ceilList![1].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![1].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![2].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![4].ceilList![2]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![4].ceilList![2].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![4].ceilList![2].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![4].ceilList![2].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![4].ceilList![2].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![4].ceilList![2].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![2].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![3].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![4].ceilList![3]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![4].ceilList![3].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![4].ceilList![3].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![4].ceilList![3].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![4].ceilList![3].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![4].ceilList![3].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![3].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![4].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![4].ceilList![4]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![4].ceilList![4].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![4].ceilList![4].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![4].ceilList![4].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![4].ceilList![4].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![4].ceilList![4].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![4].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![5].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![4].ceilList![5]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![4].ceilList![5].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![4].ceilList![5].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![4].ceilList![5].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![4].ceilList![5].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![4].ceilList![5].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![5].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![6].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![4].ceilList![6]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![4].ceilList![6].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![4].ceilList![6].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![4].ceilList![6].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![4].ceilList![6].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![4].ceilList![6].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![4].ceilList![6].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ])
          ],
        );
}

_saturdayTable(PrepScheduleViewModel model) {
  return model.circle
      ? Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        )
      : Table(
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Время',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Пары',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![0].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![5].ceilList![0]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![5].ceilList![0].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![5].ceilList![0].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![5].ceilList![0].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![5].ceilList![0].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![5].ceilList![0].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![0].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![1].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![5].ceilList![1]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![5].ceilList![1].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![5].ceilList![1].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![5].ceilList![1].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![5].ceilList![1].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![5].ceilList![1].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![1].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![2].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![5].ceilList![2]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![5].ceilList![2].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![5].ceilList![2].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![5].ceilList![2].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![5].ceilList![2].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![5].ceilList![2].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![2].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![3].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![5].ceilList![3]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![5].ceilList![3].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![5].ceilList![3].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![5].ceilList![3].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![5].ceilList![3].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![5].ceilList![3].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![3].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![4].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![5].ceilList![4]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![5].ceilList![4].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![5].ceilList![4].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![5].ceilList![4].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![5].ceilList![4].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![5].ceilList![4].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![4].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![5].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![5].ceilList![5]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![5].ceilList![5].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![5].ceilList![5].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![5].ceilList![5].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![5].ceilList![5].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![5].ceilList![5].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![5].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${model.result!.coupleList![6].description}'),
              ),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: model.result!.prepScheduleTable![5].ceilList![6]
                              .ceil!.uneven!.length <=
                          model.result!.prepScheduleTable![5].ceilList![6].ceil!
                              .even!.length
                      ? model.result!.prepScheduleTable![5].ceilList![6].ceil!
                          .uneven!.length
                      : model.result!.prepScheduleTable![5].ceilList![6].ceil!
                          .even!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        model.weekId == 1
                            ? Text(
                                '${model.result!.prepScheduleTable![5].ceilList![6].ceil!.even![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.even![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.even![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.even![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.even![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.even![index].endWeekNum} нед.')
                            : Text(
                                '${model.result!.prepScheduleTable![5].ceilList![6].ceil!.uneven![index].discName}, ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.uneven![index].groupName}, ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.uneven![index].lessonType}, ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.uneven![index].auditoryName}, с ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.uneven![index].startWeekNum} по ${model.result!.prepScheduleTable![5].ceilList![6].ceil!.uneven![index].endWeekNum} нед.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
            ])
          ],
        );
}

_tableDay7(model) {
  return model.circle
      ? Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        )
      : const Icon(
          Icons.hotel,
          size: 200,
          color: Colors.grey,
        );
}
