import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/schedule/prepSchedule_view.dart';
import 'package:kemsu_app/UI/views/schedule/schedule2.0_model.dart';
import 'package:kemsu_app/UI/views/schedule/schedule2.0_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class NewScheduleView extends StatefulWidget {
  const NewScheduleView({Key? key}) : super(key: key);

  @override
  State<NewScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<NewScheduleView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewScheduleViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => NewScheduleViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness
                      .dark), //прозрачность statusbar и установка тёмных иконок
              child: WillPopScope(
                onWillPop: () async => false,
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
                          //backgroundColor: Colors.white,
                          appBar: customAppBar(context, model, 'Расписание'),
                          //bottomNavigationBar: customBottomBar(context, model),
                          body: model.currentTable == true
                              ? _scheduleViewAll(context, model)
                              : _scheduleViewStudent(context, model)),
                ),
              ));
        });
  }
}

_scheduleViewStudent(BuildContext context, NewScheduleViewModel model) {
  return ListView(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: IconButton(
                    onPressed: () {
                      model.changeTable(true);
                    },
                    icon: const Icon(Icons.edit)),
              ),
            ),
            Row(
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
          ],
        ),
      ),
      Stack(
        children: [
          ListTile(
            title: const Text('четная'),
            leading: Radio(
              value: true,
              groupValue: model.weekType,
              onChanged: (value) {
                model.changeWeek(value);
              },
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
            child: ListTile(
              title: const Text('нечетная'),
              leading: Radio(
                value: false,
                groupValue: model.weekType,
                onChanged: (value) {
                  model.changeWeek(value);
                },
              ),
            ),
          )
        ],
      ),
      Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
          child: _choiceDay(model, context)),
      Center(
          child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrepScheduleView()),
          );
        },
        child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 15))
                ]),
            child: const Center(
                child: Text(
              'Расписание преподавателей',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ))),
      )),
    ],
  );
}

_scheduleViewAll(BuildContext context, NewScheduleViewModel model) {
  dropdownItems = List.generate(
    model.facultyList.length,
    (index) => DropdownMenuItem(
      value: model.facultyList[index].id.toString(),
      child: Text(
        '${model.facultyList[index].faculty}',
      ),
    ),
  );
  return ListView(
    children: <Widget>[
      Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: () {
            model.changeTable(false);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<FacultyList>(
                dropdownColor: Theme.of(context).primaryColor,
                hint: const Text(
                  'Выбрать институт',
                ),
                onChanged: (value) {
                  model.changeFaculty(value);
                },
                isExpanded: true,
                value: model.scheduleFaculty,
                items:
                    model.facultyList.map<DropdownMenuItem<FacultyList>>((e) {
                  return DropdownMenuItem<FacultyList>(
                    child: Text(e.faculty.toString()),
                    value: e,
                  );
                }).toList(),
              )),
        ),
      ),
      const SizedBox(height: 10),
      Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<GroupList>(
                dropdownColor: Theme.of(context).primaryColor,
                hint: const Text(
                  'Выбрать группу',
                ),
                onChanged: (value) {
                  model.changeGroup(value);
                },
                isExpanded: true,
                value: model.scheduleGroup,
                items: model.groupList.map<DropdownMenuItem<GroupList>>((e) {
                  return DropdownMenuItem<GroupList>(
                    child: Text(e.groupName.toString()),
                    value: e,
                  );
                }).toList(),
              )),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: GestureDetector(
          onTap: () async {
            model.getSchedule();
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            height: 50,
            decoration: BoxDecoration(
                color: model.scheduleGroup == null ? Colors.grey : Colors.red,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 15))
                ]),
            child: const Center(
              child: Text(
                'Показать',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ),
      ),
      model.tableView == true
          ? Padding(
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
            )
          : const SizedBox(),
      model.tableView == false
          ? const SizedBox()
          : Stack(
              children: [
                ListTile(
                  title: const Text('четная'),
                  leading: Radio(
                    value: true,
                    groupValue: model.weekType,
                    onChanged: (value) {
                      model.changeWeek(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2),
                  child: ListTile(
                    title: const Text('нечетная'),
                    leading: Radio(
                      value: false,
                      groupValue: model.weekType,
                      onChanged: (value) {
                        model.changeWeek(value);
                      },
                    ),
                  ),
                )
              ],
            ),
      Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
          child: model.tableView == false
              ? const SizedBox()
              : _choiceDay(model, context))
    ],
  );
}

_choiceDay(model, context) {
  if (model.indexDay == 1) {
    return _tableDay1(model, context);
  } else if (model.indexDay == 2) {
    return _tableDay2(model, context);
  } else if (model.indexDay == 3) {
    return _tableDay3(model, context);
  } else if (model.indexDay == 4) {
    return _tableDay4(model, context);
  } else if (model.indexDay == 5) {
    return _tableDay5(model, context);
  } else if (model.indexDay == 6) {
    return _tableDay6(model, context);
  } else if (model.indexDay == 7) {
    return _tableDay7();
  }
}

_tableDay1(NewScheduleViewModel model, context) {
  return Table(
    border: TableBorder.all(
      color: Theme.of(context).canvasColor,
    ),
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
          child: Text(model.coupleTime[0]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay1!.coupleAll1!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay1!.coupleAll1![0].discName}, ${model.scheduleTable!.weekDay1!.coupleAll1![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleAll1![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleAll1![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay1!.coupleEven1!.isNotEmpty &&
                        model.scheduleTable!.weekDay1!.coupleOdd1!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay1!.coupleEven1![0].discName}, ${model.scheduleTable!.weekDay1!.coupleEven1![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleEven1![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleEven1![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay1!.coupleOdd1![0].discName}, ${model.scheduleTable!.weekDay1!.coupleOdd1![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleOdd1![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleOdd1![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[1]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay1!.coupleAll2!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay1!.coupleAll2![0].discName}, ${model.scheduleTable!.weekDay1!.coupleAll2![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleAll2![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleAll2![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay1!.coupleEven2!.isNotEmpty &&
                        model.scheduleTable!.weekDay1!.coupleOdd2!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay1!.coupleEven2![0].discName}, ${model.scheduleTable!.weekDay1!.coupleEven2![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleEven2![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleEven2![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay1!.coupleOdd2![0].discName}, ${model.scheduleTable!.weekDay1!.coupleOdd2![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleOdd2![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleOdd2![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[2]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay1!.coupleAll3!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay1!.coupleAll3![0].discName}, ${model.scheduleTable!.weekDay1!.coupleAll3![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleAll3![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleAll3![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay1!.coupleEven3!.isNotEmpty &&
                        model.scheduleTable!.weekDay1!.coupleOdd3!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay1!.coupleEven3![0].discName}, ${model.scheduleTable!.weekDay1!.coupleEven3![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleEven3![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleEven3![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay1!.coupleOdd3![0].discName}, ${model.scheduleTable!.weekDay1!.coupleOdd3![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleOdd3![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleOdd3![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[3]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay1!.coupleAll4!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay1!.coupleAll4![0].discName}, ${model.scheduleTable!.weekDay1!.coupleAll4![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleAll4![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleAll4![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay1!.coupleEven4!.isNotEmpty &&
                        model.scheduleTable!.weekDay1!.coupleOdd4!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay1!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay1!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleEven4![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay1!.coupleOdd4![0].discName}, ${model.scheduleTable!.weekDay1!.coupleOdd4![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleOdd4![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleOdd4![0].auditoryName}',
                                )
                        ],
                      )
                    : model.scheduleTable!.weekDay1!.coupleEven4!.isNotEmpty
                        ? Text(
                            ' ${model.scheduleTable!.weekDay1!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay1!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleEven4![0].auditoryName}',
                          )
                        : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[4]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay1!.coupleAll5!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay1!.coupleAll5![0].discName}, ${model.scheduleTable!.weekDay1!.coupleAll5![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleAll5![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleAll5![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay1!.coupleEven5!.isNotEmpty &&
                        model.scheduleTable!.weekDay1!.coupleOdd5!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay1!.coupleEven5![0].discName}, ${model.scheduleTable!.weekDay1!.coupleEven5![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleEven5![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleEven5![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay1!.coupleOdd5![0].discName}, ${model.scheduleTable!.weekDay1!.coupleOdd5![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleOdd5![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleOdd5![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[5]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay1!.coupleAll6!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay1!.coupleAll6![0].discName}, ${model.scheduleTable!.weekDay1!.coupleAll6![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleAll6![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleAll6![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay1!.coupleEven6!.isNotEmpty &&
                        model.scheduleTable!.weekDay1!.coupleOdd6!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay1!.coupleEven6![0].discName}, ${model.scheduleTable!.weekDay1!.coupleEven6![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleEven6![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleEven6![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay1!.coupleOdd6![0].discName}, ${model.scheduleTable!.weekDay1!.coupleOdd6![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleOdd6![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleOdd6![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[6]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay1!.coupleAll7!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay1!.coupleAll7![0].discName}, ${model.scheduleTable!.weekDay1!.coupleAll7![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleAll7![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleAll7![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay1!.coupleEven7!.isNotEmpty &&
                        model.scheduleTable!.weekDay1!.coupleOdd7!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay1!.coupleEven7![0].discName}, ${model.scheduleTable!.weekDay1!.coupleEven7![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleEven7![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleEven7![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay1!.coupleOdd7![0].discName}, ${model.scheduleTable!.weekDay1!.coupleOdd7![0].lessonType}, ${model.scheduleTable!.weekDay1!.coupleOdd7![0].prepName}, ${model.scheduleTable!.weekDay1!.coupleOdd7![0].auditoryName}',
                                )
                        ],
                      )
                    : null),
      ])
    ],
  );
}

_tableDay2(NewScheduleViewModel model, context) {
  return Table(
    border: TableBorder.all(
      color: Theme.of(context).canvasColor,
    ),
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
          child: Text(model.coupleTime[0]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay2!.coupleAll1!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay2!.coupleAll1![0].discName}, ${model.scheduleTable!.weekDay2!.coupleAll1![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleAll1![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleAll1![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay2!.coupleEven1!.isNotEmpty &&
                        model.scheduleTable!.weekDay2!.coupleOdd1!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay2!.coupleEven1![0].discName}, ${model.scheduleTable!.weekDay2!.coupleEven1![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleEven1![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleEven1![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay2!.coupleOdd1![0].discName}, ${model.scheduleTable!.weekDay2!.coupleOdd1![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleOdd1![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleOdd1![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[1]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay2!.coupleAll2!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay2!.coupleAll2![0].discName}, ${model.scheduleTable!.weekDay2!.coupleAll2![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleAll2![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleAll2![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay2!.coupleEven2!.isNotEmpty &&
                        model.scheduleTable!.weekDay2!.coupleOdd2!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay2!.coupleEven2![0].discName}, ${model.scheduleTable!.weekDay2!.coupleEven2![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleEven2![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleEven2![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay2!.coupleOdd2![0].discName}, ${model.scheduleTable!.weekDay2!.coupleOdd2![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleOdd2![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleOdd2![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[2]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay2!.coupleAll3!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay2!.coupleAll3![0].discName}, ${model.scheduleTable!.weekDay2!.coupleAll3![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleAll3![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleAll3![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay2!.coupleEven3!.isNotEmpty &&
                        model.scheduleTable!.weekDay2!.coupleOdd3!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay2!.coupleEven3![0].discName}, ${model.scheduleTable!.weekDay2!.coupleEven3![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleEven3![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleEven3![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay2!.coupleOdd3![0].discName}, ${model.scheduleTable!.weekDay2!.coupleOdd3![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleOdd3![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleOdd3![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[3]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay2!.coupleAll4!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay2!.coupleAll4![0].discName}, ${model.scheduleTable!.weekDay2!.coupleAll4![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleAll4![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleAll4![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay2!.coupleEven4!.isNotEmpty &&
                        model.scheduleTable!.weekDay2!.coupleOdd4!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay2!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay2!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleEven4![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay2!.coupleOdd4![0].discName}, ${model.scheduleTable!.weekDay2!.coupleOdd4![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleOdd4![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleOdd4![0].auditoryName}',
                                )
                        ],
                      )
                    : model.scheduleTable!.weekDay2!.coupleEven4!.isNotEmpty
                        ? Text(
                            ' ${model.scheduleTable!.weekDay2!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay2!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleEven4![0].auditoryName}',
                          )
                        : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[4]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay2!.coupleAll5!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay2!.coupleAll5![0].discName}, ${model.scheduleTable!.weekDay2!.coupleAll5![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleAll5![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleAll5![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay2!.coupleEven5!.isNotEmpty &&
                        model.scheduleTable!.weekDay2!.coupleOdd5!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay2!.coupleEven5![0].discName}, ${model.scheduleTable!.weekDay2!.coupleEven5![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleEven5![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleEven5![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay2!.coupleOdd5![0].discName}, ${model.scheduleTable!.weekDay2!.coupleOdd5![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleOdd5![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleOdd5![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[5]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay2!.coupleAll6!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay2!.coupleAll6![0].discName}, ${model.scheduleTable!.weekDay2!.coupleAll6![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleAll6![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleAll6![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay2!.coupleEven6!.isNotEmpty &&
                        model.scheduleTable!.weekDay2!.coupleOdd6!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay2!.coupleEven6![0].discName}, ${model.scheduleTable!.weekDay2!.coupleEven6![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleEven6![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleEven6![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay2!.coupleOdd6![0].discName}, ${model.scheduleTable!.weekDay2!.coupleOdd6![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleOdd6![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleOdd6![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[6]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay2!.coupleAll7!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay2!.coupleAll7![0].discName}, ${model.scheduleTable!.weekDay2!.coupleAll7![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleAll7![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleAll7![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay2!.coupleEven7!.isNotEmpty &&
                        model.scheduleTable!.weekDay2!.coupleOdd7!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay2!.coupleEven7![0].discName}, ${model.scheduleTable!.weekDay2!.coupleEven7![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleEven7![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleEven7![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay2!.coupleOdd7![0].discName}, ${model.scheduleTable!.weekDay2!.coupleOdd7![0].lessonType}, ${model.scheduleTable!.weekDay2!.coupleOdd7![0].prepName}, ${model.scheduleTable!.weekDay2!.coupleOdd7![0].auditoryName}',
                                )
                        ],
                      )
                    : null),
      ])
    ],
  );
}

_tableDay3(NewScheduleViewModel model, context) {
  return Table(
    border: TableBorder.all(
      color: Theme.of(context).canvasColor,
    ),
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
          child: Text(model.coupleTime[0]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay3!.coupleAll1!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay3!.coupleAll1![0].discName}, ${model.scheduleTable!.weekDay3!.coupleAll1![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleAll1![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleAll1![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay3!.coupleEven1!.isNotEmpty &&
                        model.scheduleTable!.weekDay3!.coupleOdd1!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay3!.coupleEven1![0].discName}, ${model.scheduleTable!.weekDay3!.coupleEven1![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleEven1![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleEven1![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay3!.coupleOdd1![0].discName}, ${model.scheduleTable!.weekDay3!.coupleOdd1![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleOdd1![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleOdd1![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[1]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay3!.coupleAll2!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay3!.coupleAll2![0].discName}, ${model.scheduleTable!.weekDay3!.coupleAll2![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleAll2![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleAll2![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay3!.coupleEven2!.isNotEmpty &&
                        model.scheduleTable!.weekDay3!.coupleOdd2!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay3!.coupleEven2![0].discName}, ${model.scheduleTable!.weekDay3!.coupleEven2![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleEven2![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleEven2![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay3!.coupleOdd2![0].discName}, ${model.scheduleTable!.weekDay3!.coupleOdd2![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleOdd2![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleOdd2![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[2]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay3!.coupleAll3!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay3!.coupleAll3![0].discName}, ${model.scheduleTable!.weekDay3!.coupleAll3![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleAll3![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleAll3![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay3!.coupleEven3!.isNotEmpty &&
                        model.scheduleTable!.weekDay3!.coupleOdd3!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay3!.coupleEven3![0].discName}, ${model.scheduleTable!.weekDay3!.coupleEven3![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleEven3![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleEven3![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay3!.coupleOdd3![0].discName}, ${model.scheduleTable!.weekDay3!.coupleOdd3![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleOdd3![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleOdd3![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[3]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay3!.coupleAll4!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay3!.coupleAll4![0].discName}, ${model.scheduleTable!.weekDay3!.coupleAll4![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleAll4![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleAll4![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay3!.coupleEven4!.isNotEmpty &&
                        model.scheduleTable!.weekDay3!.coupleOdd4!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay3!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay3!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleEven4![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay3!.coupleOdd4![0].discName}, ${model.scheduleTable!.weekDay3!.coupleOdd4![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleOdd4![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleOdd4![0].auditoryName}',
                                )
                        ],
                      )
                    : model.scheduleTable!.weekDay3!.coupleEven4!.isNotEmpty
                        ? Text(
                            ' ${model.scheduleTable!.weekDay3!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay3!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleEven4![0].auditoryName}',
                          )
                        : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[4]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay3!.coupleAll5!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay3!.coupleAll5![0].discName}, ${model.scheduleTable!.weekDay3!.coupleAll5![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleAll5![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleAll5![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay3!.coupleEven5!.isNotEmpty &&
                        model.scheduleTable!.weekDay3!.coupleOdd5!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay3!.coupleEven5![0].discName}, ${model.scheduleTable!.weekDay3!.coupleEven5![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleEven5![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleEven5![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay3!.coupleOdd5![0].discName}, ${model.scheduleTable!.weekDay3!.coupleOdd5![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleOdd5![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleOdd5![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[5]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay3!.coupleAll6!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay3!.coupleAll6![0].discName}, ${model.scheduleTable!.weekDay3!.coupleAll6![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleAll6![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleAll6![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay3!.coupleEven6!.isNotEmpty &&
                        model.scheduleTable!.weekDay3!.coupleOdd6!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay3!.coupleEven6![0].discName}, ${model.scheduleTable!.weekDay3!.coupleEven6![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleEven6![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleEven6![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay3!.coupleOdd6![0].discName}, ${model.scheduleTable!.weekDay3!.coupleOdd6![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleOdd6![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleOdd6![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[6]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay3!.coupleAll7!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay3!.coupleAll7![0].discName}, ${model.scheduleTable!.weekDay3!.coupleAll7![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleAll7![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleAll7![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay3!.coupleEven7!.isNotEmpty &&
                        model.scheduleTable!.weekDay3!.coupleOdd7!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay3!.coupleEven7![0].discName}, ${model.scheduleTable!.weekDay3!.coupleEven7![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleEven7![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleEven7![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay3!.coupleOdd7![0].discName}, ${model.scheduleTable!.weekDay3!.coupleOdd7![0].lessonType}, ${model.scheduleTable!.weekDay3!.coupleOdd7![0].prepName}, ${model.scheduleTable!.weekDay3!.coupleOdd7![0].auditoryName}',
                                )
                        ],
                      )
                    : null),
      ])
    ],
  );
}

_tableDay4(NewScheduleViewModel model, context) {
  return Table(
    border: TableBorder.all(
      color: Theme.of(context).canvasColor,
    ),
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
          child: Text(model.coupleTime[0]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay4!.coupleAll1!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay4!.coupleAll1![0].discName}, ${model.scheduleTable!.weekDay4!.coupleAll1![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleAll1![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleAll1![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay4!.coupleEven1!.isNotEmpty &&
                        model.scheduleTable!.weekDay4!.coupleOdd1!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay4!.coupleEven1![0].discName}, ${model.scheduleTable!.weekDay4!.coupleEven1![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleEven1![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleEven1![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay4!.coupleOdd1![0].discName}, ${model.scheduleTable!.weekDay4!.coupleOdd1![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleOdd1![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleOdd1![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[1]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay4!.coupleAll2!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay4!.coupleAll2![0].discName}, ${model.scheduleTable!.weekDay4!.coupleAll2![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleAll2![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleAll2![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay4!.coupleEven2!.isNotEmpty &&
                        model.scheduleTable!.weekDay4!.coupleOdd2!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay4!.coupleEven2![0].discName}, ${model.scheduleTable!.weekDay4!.coupleEven2![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleEven2![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleEven2![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay4!.coupleOdd2![0].discName}, ${model.scheduleTable!.weekDay4!.coupleOdd2![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleOdd2![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleOdd2![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[2]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay4!.coupleAll3!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay4!.coupleAll3![0].discName}, ${model.scheduleTable!.weekDay4!.coupleAll3![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleAll3![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleAll3![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay4!.coupleEven3!.isNotEmpty &&
                        model.scheduleTable!.weekDay4!.coupleOdd3!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay4!.coupleEven3![0].discName}, ${model.scheduleTable!.weekDay4!.coupleEven3![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleEven3![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleEven3![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay4!.coupleOdd3![0].discName}, ${model.scheduleTable!.weekDay4!.coupleOdd3![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleOdd3![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleOdd3![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[3]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay4!.coupleAll4!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay4!.coupleAll4![0].discName}, ${model.scheduleTable!.weekDay4!.coupleAll4![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleAll4![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleAll4![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay4!.coupleEven4!.isNotEmpty &&
                        model.scheduleTable!.weekDay4!.coupleOdd4!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay4!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay4!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleEven4![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay4!.coupleOdd4![0].discName}, ${model.scheduleTable!.weekDay4!.coupleOdd4![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleOdd4![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleOdd4![0].auditoryName}',
                                )
                        ],
                      )
                    : model.scheduleTable!.weekDay4!.coupleEven4!.isNotEmpty
                        ? Text(
                            ' ${model.scheduleTable!.weekDay4!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay4!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleEven4![0].auditoryName}',
                          )
                        : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[4]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay4!.coupleAll5!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay4!.coupleAll5![0].discName}, ${model.scheduleTable!.weekDay4!.coupleAll5![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleAll5![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleAll5![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay4!.coupleEven5!.isNotEmpty &&
                        model.scheduleTable!.weekDay4!.coupleOdd5!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay4!.coupleEven5![0].discName}, ${model.scheduleTable!.weekDay4!.coupleEven5![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleEven5![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleEven5![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay4!.coupleOdd5![0].discName}, ${model.scheduleTable!.weekDay4!.coupleOdd5![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleOdd5![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleOdd5![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[5]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay4!.coupleAll6!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay4!.coupleAll6![0].discName}, ${model.scheduleTable!.weekDay4!.coupleAll6![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleAll6![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleAll6![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay4!.coupleEven6!.isNotEmpty &&
                        model.scheduleTable!.weekDay4!.coupleOdd6!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay4!.coupleEven6![0].discName}, ${model.scheduleTable!.weekDay4!.coupleEven6![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleEven6![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleEven6![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay4!.coupleOdd6![0].discName}, ${model.scheduleTable!.weekDay4!.coupleOdd6![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleOdd6![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleOdd6![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[6]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay4!.coupleAll7!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay4!.coupleAll7![0].discName}, ${model.scheduleTable!.weekDay4!.coupleAll7![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleAll7![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleAll7![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay4!.coupleEven7!.isNotEmpty &&
                        model.scheduleTable!.weekDay4!.coupleOdd7!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay4!.coupleEven7![0].discName}, ${model.scheduleTable!.weekDay4!.coupleEven7![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleEven7![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleEven7![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay4!.coupleOdd7![0].discName}, ${model.scheduleTable!.weekDay4!.coupleOdd7![0].lessonType}, ${model.scheduleTable!.weekDay4!.coupleOdd7![0].prepName}, ${model.scheduleTable!.weekDay4!.coupleOdd7![0].auditoryName}',
                                )
                        ],
                      )
                    : null),
      ])
    ],
  );
}

_tableDay5(NewScheduleViewModel model, context) {
  return Table(
    border: TableBorder.all(
      color: Theme.of(context).canvasColor,
    ),
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
          child: Text(model.coupleTime[0]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay5!.coupleAll1!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay5!.coupleAll1![0].discName}, ${model.scheduleTable!.weekDay5!.coupleAll1![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleAll1![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleAll1![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay5!.coupleEven1!.isNotEmpty &&
                        model.scheduleTable!.weekDay5!.coupleOdd1!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay5!.coupleEven1![0].discName}, ${model.scheduleTable!.weekDay5!.coupleEven1![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleEven1![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleEven1![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay5!.coupleOdd1![0].discName}, ${model.scheduleTable!.weekDay5!.coupleOdd1![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleOdd1![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleOdd1![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[1]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay5!.coupleAll2!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay5!.coupleAll2![0].discName}, ${model.scheduleTable!.weekDay5!.coupleAll2![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleAll2![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleAll2![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay5!.coupleEven2!.isNotEmpty &&
                        model.scheduleTable!.weekDay5!.coupleOdd2!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay5!.coupleEven2![0].discName}, ${model.scheduleTable!.weekDay5!.coupleEven2![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleEven2![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleEven2![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay5!.coupleOdd2![0].discName}, ${model.scheduleTable!.weekDay5!.coupleOdd2![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleOdd2![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleOdd2![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[2]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay5!.coupleAll3!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay5!.coupleAll3![0].discName}, ${model.scheduleTable!.weekDay5!.coupleAll3![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleAll3![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleAll3![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay5!.coupleEven3!.isNotEmpty &&
                        model.scheduleTable!.weekDay5!.coupleOdd3!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay5!.coupleEven3![0].discName}, ${model.scheduleTable!.weekDay5!.coupleEven3![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleEven3![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleEven3![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay5!.coupleOdd3![0].discName}, ${model.scheduleTable!.weekDay5!.coupleOdd3![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleOdd3![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleOdd3![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[3]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay5!.coupleAll4!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay5!.coupleAll4![0].discName}, ${model.scheduleTable!.weekDay5!.coupleAll4![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleAll4![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleAll4![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay5!.coupleEven4!.isNotEmpty &&
                        model.scheduleTable!.weekDay5!.coupleOdd4!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay5!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay5!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleEven4![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay5!.coupleOdd4![0].discName}, ${model.scheduleTable!.weekDay5!.coupleOdd4![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleOdd4![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleOdd4![0].auditoryName}',
                                )
                        ],
                      )
                    : model.scheduleTable!.weekDay5!.coupleEven4!.isNotEmpty
                        ? Text(
                            ' ${model.scheduleTable!.weekDay5!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay5!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleEven4![0].auditoryName}',
                          )
                        : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[4]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay5!.coupleAll5!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay5!.coupleAll5![0].discName}, ${model.scheduleTable!.weekDay5!.coupleAll5![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleAll5![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleAll5![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay5!.coupleEven5!.isNotEmpty &&
                        model.scheduleTable!.weekDay5!.coupleOdd5!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay5!.coupleEven5![0].discName}, ${model.scheduleTable!.weekDay5!.coupleEven5![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleEven5![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleEven5![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay5!.coupleOdd5![0].discName}, ${model.scheduleTable!.weekDay5!.coupleOdd5![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleOdd5![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleOdd5![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[5]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay5!.coupleAll6!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay5!.coupleAll6![0].discName}, ${model.scheduleTable!.weekDay5!.coupleAll6![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleAll6![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleAll6![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay5!.coupleEven6!.isNotEmpty &&
                        model.scheduleTable!.weekDay5!.coupleOdd6!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay5!.coupleEven6![0].discName}, ${model.scheduleTable!.weekDay5!.coupleEven6![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleEven6![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleEven6![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay5!.coupleOdd6![0].discName}, ${model.scheduleTable!.weekDay5!.coupleOdd6![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleOdd6![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleOdd6![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[6]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay5!.coupleAll7!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay5!.coupleAll7![0].discName}, ${model.scheduleTable!.weekDay5!.coupleAll7![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleAll7![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleAll7![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay5!.coupleEven7!.isNotEmpty &&
                        model.scheduleTable!.weekDay5!.coupleOdd7!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay5!.coupleEven7![0].discName}, ${model.scheduleTable!.weekDay5!.coupleEven7![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleEven7![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleEven7![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay5!.coupleOdd7![0].discName}, ${model.scheduleTable!.weekDay5!.coupleOdd7![0].lessonType}, ${model.scheduleTable!.weekDay5!.coupleOdd7![0].prepName}, ${model.scheduleTable!.weekDay5!.coupleOdd7![0].auditoryName}',
                                )
                        ],
                      )
                    : null),
      ])
    ],
  );
}

_tableDay6(NewScheduleViewModel model, context) {
  return Table(
    border: TableBorder.all(
      color: Theme.of(context).canvasColor,
    ),
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
          child: Text(model.coupleTime[0]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay6!.coupleAll1!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay6!.coupleAll1![0].discName}, ${model.scheduleTable!.weekDay6!.coupleAll1![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleAll1![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleAll1![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay6!.coupleEven1!.isNotEmpty &&
                        model.scheduleTable!.weekDay6!.coupleOdd1!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay6!.coupleEven1![0].discName}, ${model.scheduleTable!.weekDay6!.coupleEven1![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleEven1![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleEven1![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay6!.coupleOdd1![0].discName}, ${model.scheduleTable!.weekDay6!.coupleOdd1![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleOdd1![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleOdd1![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[1]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay6!.coupleAll2!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay6!.coupleAll2![0].discName}, ${model.scheduleTable!.weekDay6!.coupleAll2![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleAll2![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleAll2![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay6!.coupleEven2!.isNotEmpty &&
                        model.scheduleTable!.weekDay6!.coupleOdd2!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay6!.coupleEven2![0].discName}, ${model.scheduleTable!.weekDay6!.coupleEven2![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleEven2![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleEven2![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay6!.coupleOdd2![0].discName}, ${model.scheduleTable!.weekDay6!.coupleOdd2![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleOdd2![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleOdd2![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[2]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay6!.coupleAll3!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay6!.coupleAll3![0].discName}, ${model.scheduleTable!.weekDay6!.coupleAll3![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleAll3![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleAll3![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay6!.coupleEven3!.isNotEmpty &&
                        model.scheduleTable!.weekDay6!.coupleOdd3!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay6!.coupleEven3![0].discName}, ${model.scheduleTable!.weekDay6!.coupleEven3![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleEven3![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleEven3![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay6!.coupleOdd3![0].discName}, ${model.scheduleTable!.weekDay6!.coupleOdd3![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleOdd3![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleOdd3![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[3]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay6!.coupleAll4!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay6!.coupleAll4![0].discName}, ${model.scheduleTable!.weekDay6!.coupleAll4![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleAll4![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleAll4![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay6!.coupleEven4!.isNotEmpty &&
                        model.scheduleTable!.weekDay6!.coupleOdd4!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay6!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay6!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleEven4![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay6!.coupleOdd4![0].discName}, ${model.scheduleTable!.weekDay6!.coupleOdd4![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleOdd4![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleOdd4![0].auditoryName}',
                                )
                        ],
                      )
                    : model.scheduleTable!.weekDay6!.coupleEven4!.isNotEmpty
                        ? Text(
                            ' ${model.scheduleTable!.weekDay6!.coupleEven4![0].discName}, ${model.scheduleTable!.weekDay6!.coupleEven4![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleEven4![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleEven4![0].auditoryName}',
                          )
                        : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[4]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay6!.coupleAll5!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay6!.coupleAll5![0].discName}, ${model.scheduleTable!.weekDay6!.coupleAll5![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleAll5![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleAll5![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay6!.coupleEven5!.isNotEmpty &&
                        model.scheduleTable!.weekDay6!.coupleOdd5!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay6!.coupleEven5![0].discName}, ${model.scheduleTable!.weekDay6!.coupleEven5![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleEven5![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleEven5![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay6!.coupleOdd5![0].discName}, ${model.scheduleTable!.weekDay6!.coupleOdd5![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleOdd5![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleOdd5![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[5]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay6!.coupleAll6!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay6!.coupleAll6![0].discName}, ${model.scheduleTable!.weekDay6!.coupleAll6![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleAll6![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleAll6![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay6!.coupleEven6!.isNotEmpty &&
                        model.scheduleTable!.weekDay6!.coupleOdd6!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay6!.coupleEven6![0].discName}, ${model.scheduleTable!.weekDay6!.coupleEven6![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleEven6![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleEven6![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay6!.coupleOdd6![0].discName}, ${model.scheduleTable!.weekDay6!.coupleOdd6![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleOdd6![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleOdd6![0].auditoryName}',
                                )
                        ],
                      )
                    : null)
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.coupleTime[6]),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.scheduleTable!.weekDay6!.coupleAll7!.isNotEmpty
                ? Text(
                    '${model.scheduleTable!.weekDay6!.coupleAll7![0].discName}, ${model.scheduleTable!.weekDay6!.coupleAll7![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleAll7![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleAll7![0].auditoryName}',
                  )
                : model.scheduleTable!.weekDay6!.coupleEven7!.isNotEmpty &&
                        model.scheduleTable!.weekDay6!.coupleOdd7!.isNotEmpty
                    ? Column(
                        children: [
                          model.weekType == true
                              ? Text(
                                  '${model.scheduleTable!.weekDay6!.coupleEven7![0].discName}, ${model.scheduleTable!.weekDay6!.coupleEven7![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleEven7![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleEven7![0].auditoryName}',
                                )
                              : Text(
                                  '${model.scheduleTable!.weekDay6!.coupleOdd7![0].discName}, ${model.scheduleTable!.weekDay6!.coupleOdd7![0].lessonType}, ${model.scheduleTable!.weekDay6!.coupleOdd7![0].prepName}, ${model.scheduleTable!.weekDay6!.coupleOdd7![0].auditoryName}',
                                )
                        ],
                      )
                    : null),
      ])
    ],
  );
}

_tableDay7() {
  return const Icon(
    Icons.hotel,
    size: 200,
    color: Colors.grey,
  );
}
