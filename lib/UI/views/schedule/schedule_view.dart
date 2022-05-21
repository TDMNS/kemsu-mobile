import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_model.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

final loginController = TextEditingController();
final passwordController = TextEditingController();
List<DropdownMenuItem<String>> dropdownItems = [];

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScheduleViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => ScheduleViewModel(context),
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
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Scaffold(
                        extendBody: true,
                        extendBodyBehindAppBar: true,
                        appBar: customAppBar(context, model, 'Расписание'),
                        bottomNavigationBar: customBottomBar(context, model),
                        body: model.currentTable == false
                            ? _scheduleViewStudent(context, model)
                            : _scheduleViewAll(context, model),
                      ),
              ));
        });
  }
}

_scheduleViewAll(BuildContext context, ScheduleViewModel model) {
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
      const SizedBox(height: 10),
      Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<FacultyList>(
                hint: const Text(
                  'Выбрать институт',
                  style: TextStyle(color: Colors.black),
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
                hint: const Text(
                  'Выбрать группу',
                  style: TextStyle(color: Colors.black),
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
            model.getScheduleTable();
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
      model.table == true
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
      Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
          child: model.table == false ? const SizedBox() : _choiceDay(model))
    ],
  );
}

_scheduleViewStudent(BuildContext context, ScheduleViewModel model) {
  return ListView(
    children: <Widget>[
      Padding(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                : const Text(''),
            model.indexDay == 2
                ? const Text(
                    'Вторник',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                : const Text(''),
            model.indexDay == 3
                ? const Text(
                    'Среда',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                : const Text(''),
            model.indexDay == 4
                ? const Text(
                    'Четверг',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                : const Text(''),
            model.indexDay == 5
                ? const Text(
                    'Пятница',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                : const Text(''),
            model.indexDay == 6
                ? const Text(
                    'Суббота',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                : const Text(''),
            model.indexDay == 7
                ? const Text(
                    'Воскресенье',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
      ),
      Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
          child: _choiceDay(model))
    ],
  );
}

_choiceDay(model) {
  if (model.indexDay == 1) {
    return _tableDay1(model);
  } else if (model.indexDay == 2) {
    return _tableDay2(model);
  } else if (model.indexDay == 3) {
    return _tableDay3(model);
  } else if (model.indexDay == 4) {
    return _tableDay4(model);
  } else if (model.indexDay == 5) {
    return _tableDay5(model);
  } else if (model.indexDay == 6) {
    return _tableDay6(model);
  } else if (model.indexDay == 7) {
    return _tableDay7();
  }
}

_tableDay1(model) {
  return Table(
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
          child: Text('${model.coupleList[0].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay1All1?.length > 0
                ? Text(
                    '${model.modelDay1All1[0].discName}, ${model.modelDay1All1[0].lessonType}, ${model.modelDay1All1[0].prepName}, ${model.modelDay1All1[0].auditoryName}',
                  )
                : model.modelDay1Even1?.length > 0 &&
                        model.modelDay1Odd1?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay1Even1[0].discName}, ${model.modelDay1Even1[0].lessonType}, ${model.modelDay1Even1[0].prepName}, ${model.modelDay1Even1[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay1Odd1[0].discName}, ${model.modelDay1Odd1[0].lessonType}, ${model.modelDay1Odd1[0].prepName}, ${model.modelDay1Odd1[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay1Even1?.length > 0
                        ? Text(
                            'чет. ${model.modelDay1Even1[0].discName}, ${model.modelDay1Even1[0].lessonType}, ${model.modelDay1Even1[0].prepName}, ${model.modelDay1Even1[0].auditoryName}',
                          )
                        : model.modelDay1Odd1?.length > 0
                            ? Text(
                                'неч. ${model.modelDay1Odd1[0].discName}, ${model.modelDay1Odd1[0].lessonType}, ${model.modelDay1Odd1[0].prepName}, ${model.modelDay1Odd1[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[1].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay1All2?.length > 0
                ? Text(
                    '${model.modelDay1All2[0].discName}, ${model.modelDay1All2[0].lessonType}, ${model.modelDay1All2[0].prepName}, ${model.modelDay1All2[0].auditoryName}',
                  )
                : model.modelDay1Even2?.length > 0 &&
                        model.modelDay1Odd2?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay1Even2[0].discName}, ${model.modelDay1Even2[0].lessonType}, ${model.modelDay1Even2[0].prepName}, ${model.modelDay1Even2[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay1Odd2[0].discName}, ${model.modelDay1Odd2[0].lessonType}, ${model.modelDay1Odd2[0].prepName}, ${model.modelDay1Odd2[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay1Even2?.length > 0
                        ? Text(
                            'чет. ${model.modelDay1Even2[0].discName}, ${model.modelDay1Even2[0].lessonType}, ${model.modelDay1Even2[0].prepName}, ${model.modelDay1Even2[0].auditoryName}',
                          )
                        : model.modelDay1Odd2?.length > 0
                            ? Text(
                                'неч. ${model.modelDay1Odd2[0].discName}, ${model.modelDay1Odd2[0].lessonType}, ${model.modelDay1Odd2[0].prepName}, ${model.modelDay1Odd2[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[2].desc}'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: model.modelDay1All3?.length > 0
              ? Text(
                  '${model.modelDay1All3[0].discName}, ${model.modelDay1All3[0].lessonType}, ${model.modelDay1All3[0].prepName}, ${model.modelDay1All3[0].auditoryName}',
                )
              : model.modelDay1Even3?.length > 0 &&
                      model.modelDay1Odd3?.length > 0
                  ? Column(
                      children: [
                        Text(
                          'чет. ${model.modelDay1Even3[0].discName}, ${model.modelDay1Even3[0].lessonType}, ${model.modelDay1Even3[0].prepName}, ${model.modelDay1Even3[0].auditoryName}',
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Text(
                          'неч. ${model.modelDay1Odd3[0].discName}, ${model.modelDay1Odd3[0].lessonType}, ${model.modelDay1Odd3[0].prepName}, ${model.modelDay1Odd3[0].auditoryName}',
                        )
                      ],
                    )
                  : model.modelDay1Even3?.length > 0
                      ? Text(
                          'чет. ${model.modelDay1Even3[0].discName}, ${model.modelDay1Even3[0].lessonType}, ${model.modelDay1Even3[0].prepName}, ${model.modelDay1Even3[0].auditoryName}',
                        )
                      : model.modelDay1Odd3?.length > 0
                          ? Text(
                              'неч. ${model.modelDay1Odd3[0].discName}, ${model.modelDay1Odd3[0].lessonType}, ${model.modelDay1Odd3[0].prepName}, ${model.modelDay1Odd3[0].auditoryName}',
                            )
                          : const SizedBox(),
        )
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[3].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay1All4?.length > 0
                ? Text(
                    '${model.modelDay1All4[0].discName}, ${model.modelDay1All4[0].lessonType}, ${model.modelDay1All4[0].prepName}, ${model.modelDay1All4[0].auditoryName}',
                  )
                : model.modelDay1Even4?.length > 0 &&
                        model.modelDay1Odd4?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay1Even4[0].discName}, ${model.modelDay1Even4[0].lessonType}, ${model.modelDay1Even4[0].prepName}, ${model.modelDay1Even4[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay1Odd4[0].discName}, ${model.modelDay1Odd4[0].lessonType}, ${model.modelDay1Odd4[0].prepName}, ${model.modelDay1Odd4[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay1Even4?.length > 0
                        ? Text(
                            'чет. ${model.modelDay1Even4[0].discName}, ${model.modelDay1Even4[0].lessonType}, ${model.modelDay1Even4[0].prepName}, ${model.modelDay1Even4[0].auditoryName}',
                          )
                        : model.modelDay1Odd4?.length > 0
                            ? Text(
                                'неч. ${model.modelDay1Odd4[0].discName}, ${model.modelDay1Odd4[0].lessonType}, ${model.modelDay1Odd4[0].prepName}, ${model.modelDay1Odd4[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[4].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay1All5?.length > 0
                ? Text(
                    '${model.modelDay1All5[0].discName}, ${model.modelDay1All5[0].lessonType}, ${model.modelDay1All5[0].prepName}, ${model.modelDay1All5[0].auditoryName}',
                  )
                : model.modelDay1Even5?.length > 0 &&
                        model.modelDay1Odd5?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay1Even5[0].discName}, ${model.modelDay1Even5[0].lessonType}, ${model.modelDay1Even5[0].prepName}, ${model.modelDay1Even5[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay1Odd5[0].discName}, ${model.modelDay1Odd5[0].lessonType}, ${model.modelDay1Odd5[0].prepName}, ${model.modelDay1Odd5[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay1Even5?.length > 0
                        ? Text(
                            'чет. ${model.modelDay1Even5[0].discName}, ${model.modelDay1Even5[0].lessonType}, ${model.modelDay1Even5[0].prepName}, ${model.modelDay1Even5[0].auditoryName}',
                          )
                        : model.modelDay1Odd5?.length > 0
                            ? Text(
                                'неч. ${model.modelDay1Odd5[0].discName}, ${model.modelDay1Odd5[0].lessonType}, ${model.modelDay1Odd5[0].prepName}, ${model.modelDay1Odd5[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[5].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay1All6?.length > 0
                ? Text(
                    '${model.modelDay1All6[0].discName}, ${model.modelDay1All6[0].lessonType}, ${model.modelDay1All6[0].prepName}, ${model.modelDay1All6[0].auditoryName}',
                  )
                : model.modelDay1Even6?.length > 0 &&
                        model.modelDay1Odd6?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay1Even6[0].discName}, ${model.modelDay1Even6[0].lessonType}, ${model.modelDay1Even6[0].prepName}, ${model.modelDay1Even6[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay1Odd6[0].discName}, ${model.modelDay1Odd6[0].lessonType}, ${model.modelDay1Odd6[0].prepName}, ${model.modelDay1Odd6[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay1Even6?.length > 0
                        ? Text(
                            'чет. ${model.modelDay1Even6[0].discName}, ${model.modelDay1Even6[0].lessonType}, ${model.modelDay1Even6[0].prepName}, ${model.modelDay1Even6[0].auditoryName}',
                          )
                        : model.modelDay1Odd6?.length > 0
                            ? Text(
                                'неч. ${model.modelDay1Odd6[0].discName}, ${model.modelDay1Odd6[0].lessonType}, ${model.modelDay1Odd6[0].prepName}, ${model.modelDay1Odd6[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[6].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay1All7?.length > 0
                ? Text(
                    '${model.modelDay1All7[0].discName}, ${model.modelDay1All7[0].lessonType}, ${model.modelDay1All7[0].prepName}, ${model.modelDay1All7[0].auditoryName}',
                  )
                : model.modelDay1Even7?.length > 0 &&
                        model.modelDay1Odd7?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay1Even7[0].discName}, ${model.modelDay1Even7[0].lessonType}, ${model.modelDay1Even7[0].prepName}, ${model.modelDay1Even7[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay1Odd7[0].discName}, ${model.modelDay1Odd7[0].lessonType}, ${model.modelDay1Odd7[0].prepName}, ${model.modelDay1Odd7[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay1Even7?.length > 0
                        ? Text(
                            'чет. ${model.modelDay1Even7[0].discName}, ${model.modelDay1Even7[0].lessonType}, ${model.modelDay1Even7[0].prepName}, ${model.modelDay1Even7[0].auditoryName}',
                          )
                        : model.modelDay1Odd7?.length > 0
                            ? Text(
                                'неч. ${model.modelDay1Odd7[0].discName}, ${model.modelDay1Odd7[0].lessonType}, ${model.modelDay1Odd7[0].prepName}, ${model.modelDay1Odd7[0].auditoryName}',
                              )
                            : const SizedBox()),
      ])
    ],
  );
}

_tableDay2(model) {
  return Table(
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
          child: Text('${model.coupleList[0].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay2All1?.length > 0
                ? Text(
                    '${model.modelDay2All1[0].discName}, ${model.modelDay2All1[0].lessonType}, ${model.modelDay2All1[0].prepName}, ${model.modelDay2All1[0].auditoryName}',
                  )
                : model.modelDay2Even1?.length > 0 &&
                        model.modelDay2Odd1?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay2Even1[0].discName}, ${model.modelDay2Even1[0].lessonType}, ${model.modelDay2Even1[0].prepName}, ${model.modelDay2Even1[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay2Odd1[0].discName}, ${model.modelDay2Odd1[0].lessonType}, ${model.modelDay2Odd1[0].prepName}, ${model.modelDay2Odd1[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay2Even1?.length > 0
                        ? Text(
                            'чет. ${model.modelDay2Even1[0].discName}, ${model.modelDay2Even1[0].lessonType}, ${model.modelDay2Even1[0].prepName}, ${model.modelDay2Even1[0].auditoryName}',
                          )
                        : model.modelDay2Odd1?.length > 0
                            ? Text(
                                'неч. ${model.modelDay2Odd1[0].discName}, ${model.modelDay2Odd1[0].lessonType}, ${model.modelDay2Odd1[0].prepName}, ${model.modelDay2Odd1[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[1].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay2All2?.length > 0
                ? Text(
                    '${model.modelDay2All2[0].discName}, ${model.modelDay2All2[0].lessonType}, ${model.modelDay2All2[0].prepName}, ${model.modelDay2All2[0].auditoryName}',
                  )
                : model.modelDay2Even2?.length > 0 &&
                        model.modelDay2Odd2?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay2Even2[0].discName}, ${model.modelDay2Even2[0].lessonType}, ${model.modelDay2Even2[0].prepName}, ${model.modelDay2Even2[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay2Odd2[0].discName}, ${model.modelDay2Odd2[0].lessonType}, ${model.modelDay2Odd2[0].prepName}, ${model.modelDay2Odd2[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay2Even2?.length > 0
                        ? Text(
                            'чет. ${model.modelDay2Even2[0].discName}, ${model.modelDay2Even2[0].lessonType}, ${model.modelDay2Even2[0].prepName}, ${model.modelDay2Even2[0].auditoryName}',
                          )
                        : model.modelDay2Odd2?.length > 0
                            ? Text(
                                'неч. ${model.modelDay2Odd2[0].discName}, ${model.modelDay2Odd2[0].lessonType}, ${model.modelDay2Odd2[0].prepName}, ${model.modelDay2Odd2[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[2].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay2All3?.length > 0
                ? Text(
                    '${model.modelDay2All3[0].discName}, ${model.modelDay2All3[0].lessonType}, ${model.modelDay2All3[0].prepName}, ${model.modelDay2All3[0].auditoryName}',
                  )
                : model.modelDay2Even3?.length > 0 &&
                        model.modelDay2Odd3?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay2Even3[0].discName}, ${model.modelDay2Even3[0].lessonType}, ${model.modelDay2Even3[0].prepName}, ${model.modelDay2Even3[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay2Odd3[0].discName}, ${model.modelDay2Odd3[0].lessonType}, ${model.modelDay2Odd3[0].prepName}, ${model.modelDay2Odd3[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay2Even3?.length > 0
                        ? Text(
                            'чет. ${model.modelDay2Even3[0].discName}, ${model.modelDay2Even3[0].lessonType}, ${model.modelDay2Even3[0].prepName}, ${model.modelDay2Even3[0].auditoryName}',
                          )
                        : model.modelDay2Odd3?.length > 0
                            ? Text(
                                'неч. ${model.modelDay2Odd3[0].discName}, ${model.modelDay2Odd3[0].lessonType}, ${model.modelDay2Odd3[0].prepName}, ${model.modelDay2Odd3[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[3].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay2All4?.length > 0
                ? Text(
                    '${model.modelDay2All4[0].discName}, ${model.modelDay2All4[0].lessonType}, ${model.modelDay2All4[0].prepName}, ${model.modelDay2All4[0].auditoryName}',
                  )
                : model.modelDay2Even4?.length > 0 &&
                        model.modelDay2Odd4?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay2Even4[0].discName}, ${model.modelDay2Even4[0].lessonType}, ${model.modelDay2Even4[0].prepName}, ${model.modelDay2Even4[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay2Odd4[0].discName}, ${model.modelDay2Odd4[0].lessonType}, ${model.modelDay2Odd4[0].prepName}, ${model.modelDay2Odd4[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay2Even4?.length > 0
                        ? Text(
                            'чет. ${model.modelDay2Even4[0].discName}, ${model.modelDay2Even4[0].lessonType}, ${model.modelDay2Even4[0].prepName}, ${model.modelDay2Even4[0].auditoryName}',
                          )
                        : model.modelDay2Odd4?.length > 0
                            ? Text(
                                'неч. ${model.modelDay2Odd4[0].discName}, ${model.modelDay2Odd4[0].lessonType}, ${model.modelDay2Odd4[0].prepName}, ${model.modelDay2Odd4[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[4].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay2All5?.length > 0
                ? Text(
                    '${model.modelDay2All5[0].discName}, ${model.modelDay2All5[0].lessonType}, ${model.modelDay2All5[0].prepName}, ${model.modelDay2All5[0].auditoryName}',
                  )
                : model.modelDay2Even5?.length > 0 &&
                        model.modelDay2Odd5?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay2Even5[0].discName}, ${model.modelDay2Even5[0].lessonType}, ${model.modelDay2Even5[0].prepName}, ${model.modelDay2Even5[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay2Odd5[0].discName}, ${model.modelDay2Odd5[0].lessonType}, ${model.modelDay2Odd5[0].prepName}, ${model.modelDay2Odd5[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay2Even5?.length > 0
                        ? Text(
                            'чет. ${model.modelDay2Even5[0].discName}, ${model.modelDay2Even5[0].lessonType}, ${model.modelDay2Even5[0].prepName}, ${model.modelDay2Even5[0].auditoryName}',
                          )
                        : model.modelDay2Odd5?.length > 0
                            ? Text(
                                'неч. ${model.modelDay2Odd5[0].discName}, ${model.modelDay2Odd5[0].lessonType}, ${model.modelDay2Odd5[0].prepName}, ${model.modelDay2Odd5[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[5].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay2All6?.length > 0
                ? Text(
                    '${model.modelDay2All6[0].discName}, ${model.modelDay2All6[0].lessonType}, ${model.modelDay2All6[0].prepName}, ${model.modelDay2All6[0].auditoryName}',
                  )
                : model.modelDay2Even6?.length > 0 &&
                        model.modelDay2Odd6?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay2Even6[0].discName}, ${model.modelDay2Even6[0].lessonType}, ${model.modelDay2Even6[0].prepName}, ${model.modelDay2Even6[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay2Odd6[0].discName}, ${model.modelDay2Odd6[0].lessonType}, ${model.modelDay2Odd6[0].prepName}, ${model.modelDay2Odd6[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay2Even6?.length > 0
                        ? Text(
                            'чет. ${model.modelDay2Even6[0].discName}, ${model.modelDay2Even6[0].lessonType}, ${model.modelDay2Even6[0].prepName}, ${model.modelDay2Even6[0].auditoryName}',
                          )
                        : model.modelDay2Odd6?.length > 0
                            ? Text(
                                'неч. ${model.modelDay2Odd6[0].discName}, ${model.modelDay2Odd6[0].lessonType}, ${model.modelDay2Odd6[0].prepName}, ${model.modelDay2Odd6[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[6].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay2All7?.length > 0
                ? Text(
                    '${model.modelDay2All7[0].discName}, ${model.modelDay2All7[0].lessonType}, ${model.modelDay2All7[0].prepName}, ${model.modelDay2All7[0].auditoryName}',
                  )
                : model.modelDay2Even7?.length > 0 &&
                        model.modelDay2Odd7?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay2Even7[0].discName}, ${model.modelDay2Even7[0].lessonType}, ${model.modelDay2Even7[0].prepName}, ${model.modelDay2Even7[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay2Odd7[0].discName}, ${model.modelDay2Odd7[0].lessonType}, ${model.modelDay2Odd7[0].prepName}, ${model.modelDay2Odd7[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay2Even7?.length > 0
                        ? Text(
                            'чет. ${model.modelDay2Even7[0].discName}, ${model.modelDay2Even7[0].lessonType}, ${model.modelDay2Even7[0].prepName}, ${model.modelDay2Even7[0].auditoryName}',
                          )
                        : model.modelDay2Odd7?.length > 0
                            ? Text(
                                'неч. ${model.modelDay2Odd7[0].discName}, ${model.modelDay2Odd7[0].lessonType}, ${model.modelDay2Odd7[0].prepName}, ${model.modelDay2Odd7[0].auditoryName}',
                              )
                            : const SizedBox()),
      ])
    ],
  );
}

_tableDay3(model) {
  return Table(
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
          child: Text('${model.coupleList[0].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay3All1?.length > 0
                ? Text(
                    '${model.modelDay3All1[0].discName}, ${model.modelDay3All1[0].lessonType}, ${model.modelDay3All1[0].prepName}, ${model.modelDay3All1[0].auditoryName}',
                  )
                : model.modelDay3Even1?.length > 0 &&
                        model.modelDay3Odd1?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay3Even1[0].discName}, ${model.modelDay3Even1[0].lessonType}, ${model.modelDay3Even1[0].prepName}, ${model.modelDay3Even1[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay3Odd1[0].discName}, ${model.modelDay3Odd1[0].lessonType}, ${model.modelDay3Odd1[0].prepName}, ${model.modelDay3Odd1[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay3Even1?.length > 0
                        ? Text(
                            'чет. ${model.modelDay3Even1[0].discName}, ${model.modelDay3Even1[0].lessonType}, ${model.modelDay3Even1[0].prepName}, ${model.modelDay3Even1[0].auditoryName}',
                          )
                        : model.modelDay3Odd1?.length > 0
                            ? Text(
                                'неч. ${model.modelDay3Odd1[0].discName}, ${model.modelDay3Odd1[0].lessonType}, ${model.modelDay3Odd1[0].prepName}, ${model.modelDay3Odd1[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[1].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay3All2?.length > 0
                ? Text(
                    '${model.modelDay3All2[0].discName}, ${model.modelDay3All2[0].lessonType}, ${model.modelDay3All2[0].prepName}, ${model.modelDay3All2[0].auditoryName}',
                  )
                : model.modelDay3Even2?.length > 0 &&
                        model.modelDay3Odd2?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay3Even2[0].discName}, ${model.modelDay3Even2[0].lessonType}, ${model.modelDay3Even2[0].prepName}, ${model.modelDay3Even2[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay3Odd2[0].discName}, ${model.modelDay3Odd2[0].lessonType}, ${model.modelDay3Odd2[0].prepName}, ${model.modelDay3Odd2[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay3Even2?.length > 0
                        ? Text(
                            'чет. ${model.modelDay3Even2[0].discName}, ${model.modelDay3Even2[0].lessonType}, ${model.modelDay3Even2[0].prepName}, ${model.modelDay3Even2[0].auditoryName}',
                          )
                        : model.modelDay3Odd2?.length > 0
                            ? Text(
                                'неч. ${model.modelDay3Odd2[0].discName}, ${model.modelDay3Odd2[0].lessonType}, ${model.modelDay3Odd2[0].prepName}, ${model.modelDay3Odd2[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[2].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay3All3?.length > 0
                ? Text(
                    '${model.modelDay3All3[0].discName}, ${model.modelDay3All3[0].lessonType}, ${model.modelDay3All3[0].prepName}, ${model.modelDay3All3[0].auditoryName}',
                  )
                : model.modelDay3Even3?.length > 0 &&
                        model.modelDay3Odd3?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay3Even3[0].discName}, ${model.modelDay3Even3[0].lessonType}, ${model.modelDay3Even3[0].prepName}, ${model.modelDay3Even3[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay3Odd3[0].discName}, ${model.modelDay3Odd3[0].lessonType}, ${model.modelDay3Odd3[0].prepName}, ${model.modelDay3Odd3[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay3Even3?.length > 0
                        ? Text(
                            'чет. ${model.modelDay3Even3[0].discName}, ${model.modelDay3Even3[0].lessonType}, ${model.modelDay3Even3[0].prepName}, ${model.modelDay3Even3[0].auditoryName}',
                          )
                        : model.modelDay3Odd3?.length > 0
                            ? Text(
                                'неч. ${model.modelDay3Odd3[0].discName}, ${model.modelDay3Odd3[0].lessonType}, ${model.modelDay3Odd3[0].prepName}, ${model.modelDay3Odd3[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[3].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay3All4?.length > 0
                ? Text(
                    '${model.modelDay3All4[0].discName}, ${model.modelDay3All4[0].lessonType}, ${model.modelDay3All4[0].prepName}, ${model.modelDay3All4[0].auditoryName}',
                  )
                : model.modelDay3Even4?.length > 0 &&
                        model.modelDay3Odd4?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay3Even4[0].discName}, ${model.modelDay3Even4[0].lessonType}, ${model.modelDay3Even4[0].prepName}, ${model.modelDay3Even4[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay3Odd4[0].discName}, ${model.modelDay3Odd4[0].lessonType}, ${model.modelDay3Odd4[0].prepName}, ${model.modelDay3Odd4[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay3Even4?.length > 0
                        ? Text(
                            'чет. ${model.modelDay3Even4[0].discName}, ${model.modelDay3Even4[0].lessonType}, ${model.modelDay3Even4[0].prepName}, ${model.modelDay3Even4[0].auditoryName}',
                          )
                        : model.modelDay3Odd4?.length > 0
                            ? Text(
                                'неч. ${model.modelDay3Odd4[0].discName}, ${model.modelDay3Odd4[0].lessonType}, ${model.modelDay3Odd4[0].prepName}, ${model.modelDay3Odd4[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[4].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay3All5?.length > 0
                ? Text(
                    '${model.modelDay3All5[0].discName}, ${model.modelDay3All5[0].lessonType}, ${model.modelDay3All5[0].prepName}, ${model.modelDay3All5[0].auditoryName}',
                  )
                : model.modelDay3Even5?.length > 0 &&
                        model.modelDay3Odd5?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay3Even5[0].discName}, ${model.modelDay3Even5[0].lessonType}, ${model.modelDay3Even5[0].prepName}, ${model.modelDay3Even5[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay3Odd5[0].discName}, ${model.modelDay3Odd5[0].lessonType}, ${model.modelDay3Odd5[0].prepName}, ${model.modelDay3Odd5[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay3Even5?.length > 0
                        ? Text(
                            'чет. ${model.modelDay3Even5[0].discName}, ${model.modelDay3Even5[0].lessonType}, ${model.modelDay3Even5[0].prepName}, ${model.modelDay3Even5[0].auditoryName}',
                          )
                        : model.modelDay3Odd5?.length > 0
                            ? Text(
                                'неч. ${model.modelDay3Odd5[0].discName}, ${model.modelDay3Odd5[0].lessonType}, ${model.modelDay3Odd5[0].prepName}, ${model.modelDay3Odd5[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[5].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay3All6?.length > 0
                ? Text(
                    '${model.modelDay3All6[0].discName}, ${model.modelDay3All6[0].lessonType}, ${model.modelDay3All6[0].prepName}, ${model.modelDay3All6[0].auditoryName}',
                  )
                : model.modelDay3Even6?.length > 0 &&
                        model.modelDay3Odd6?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay3Even6[0].discName}, ${model.modelDay3Even6[0].lessonType}, ${model.modelDay3Even6[0].prepName}, ${model.modelDay3Even6[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay3Odd6[0].discName}, ${model.modelDay3Odd6[0].lessonType}, ${model.modelDay3Odd6[0].prepName}, ${model.modelDay3Odd6[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay3Even6?.length > 0
                        ? Text(
                            'чет. ${model.modelDay3Even6[0].discName}, ${model.modelDay3Even6[0].lessonType}, ${model.modelDay3Even6[0].prepName}, ${model.modelDay3Even6[0].auditoryName}',
                          )
                        : model.modelDay3Odd6?.length > 0
                            ? Text(
                                'неч. ${model.modelDay3Odd6[0].discName}, ${model.modelDay3Odd6[0].lessonType}, ${model.modelDay3Odd6[0].prepName}, ${model.modelDay3Odd6[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[6].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay3All7?.length > 0
                ? Text(
                    '${model.modelDay3All7[0].discName}, ${model.modelDay3All7[0].lessonType}, ${model.modelDay3All7[0].prepName}, ${model.modelDay3All7[0].auditoryName}',
                  )
                : model.modelDay3Even7?.length > 0 &&
                        model.modelDay3Odd7?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay3Even7[0].discName}, ${model.modelDay3Even7[0].lessonType}, ${model.modelDay3Even7[0].prepName}, ${model.modelDay3Even7[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay3Odd7[0].discName}, ${model.modelDay3Odd7[0].lessonType}, ${model.modelDay3Odd7[0].prepName}, ${model.modelDay3Odd7[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay3Even7?.length > 0
                        ? Text(
                            'чет. ${model.modelDay3Even7[0].discName}, ${model.modelDay3Even7[0].lessonType}, ${model.modelDay3Even7[0].prepName}, ${model.modelDay3Even7[0].auditoryName}',
                          )
                        : model.modelDay3Odd7?.length > 0
                            ? Text(
                                'неч. ${model.modelDay3Odd7[0].discName}, ${model.modelDay3Odd7[0].lessonType}, ${model.modelDay3Odd7[0].prepName}, ${model.modelDay3Odd7[0].auditoryName}',
                              )
                            : const SizedBox()),
      ])
    ],
  );
}

_tableDay4(model) {
  return Table(
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
          child: Text('${model.coupleList[0].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay4All1?.length > 0
                ? Text(
                    '${model.modelDay4All1[0].discName}, ${model.modelDay4All1[0].lessonType}, ${model.modelDay4All1[0].prepName}, ${model.modelDay4All1[0].auditoryName}',
                  )
                : model.modelDay4Even1?.length > 0 &&
                        model.modelDay4Odd1?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay4Even1[0].discName}, ${model.modelDay4Even1[0].lessonType}, ${model.modelDay4Even1[0].prepName}, ${model.modelDay4Even1[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay4Odd1[0].discName}, ${model.modelDay4Odd1[0].lessonType}, ${model.modelDay4Odd1[0].prepName}, ${model.modelDay4Odd1[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay4Even1?.length > 0
                        ? Text(
                            'чет. ${model.modelDay4Even1[0].discName}, ${model.modelDay4Even1[0].lessonType}, ${model.modelDay4Even1[0].prepName}, ${model.modelDay4Even1[0].auditoryName}',
                          )
                        : model.modelDay4Odd1?.length > 0
                            ? Text(
                                'неч. ${model.modelDay4Odd1[0].discName}, ${model.modelDay4Odd1[0].lessonType}, ${model.modelDay4Odd1[0].prepName}, ${model.modelDay4Odd1[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[1].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay4All2?.length > 0
                ? Text(
                    '${model.modelDay4All2[0].discName}, ${model.modelDay4All2[0].lessonType}, ${model.modelDay4All2[0].prepName}, ${model.modelDay4All2[0].auditoryName}',
                  )
                : model.modelDay4Even2?.length > 0 &&
                        model.modelDay4Odd2?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay4Even2[0].discName}, ${model.modelDay4Even2[0].lessonType}, ${model.modelDay4Even2[0].prepName}, ${model.modelDay4Even2[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay4Odd2[0].discName}, ${model.modelDay4Odd2[0].lessonType}, ${model.modelDay4Odd2[0].prepName}, ${model.modelDay4Odd2[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay4Even2?.length > 0
                        ? Text(
                            'чет. ${model.modelDay4Even2[0].discName}, ${model.modelDay4Even2[0].lessonType}, ${model.modelDay4Even2[0].prepName}, ${model.modelDay4Even2[0].auditoryName}',
                          )
                        : model.modelDay4Odd2?.length > 0
                            ? Text(
                                'неч. ${model.modelDay4Odd2[0].discName}, ${model.modelDay4Odd2[0].lessonType}, ${model.modelDay4Odd2[0].prepName}, ${model.modelDay4Odd2[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[2].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay4All3?.length > 0
                ? Text(
                    '${model.modelDay4All3[0].discName}, ${model.modelDay4All3[0].lessonType}, ${model.modelDay4All3[0].prepName}, ${model.modelDay4All3[0].auditoryName}',
                  )
                : model.modelDay4Even3?.length > 0 &&
                        model.modelDay4Odd3?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay4Even3[0].discName}, ${model.modelDay4Even3[0].lessonType}, ${model.modelDay4Even3[0].prepName}, ${model.modelDay4Even3[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay4Odd3[0].discName}, ${model.modelDay4Odd3[0].lessonType}, ${model.modelDay4Odd3[0].prepName}, ${model.modelDay4Odd3[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay4Even3?.length > 0
                        ? Text(
                            'чет. ${model.modelDay4Even3[0].discName}, ${model.modelDay4Even3[0].lessonType}, ${model.modelDay4Even3[0].prepName}, ${model.modelDay4Even3[0].auditoryName}',
                          )
                        : model.modelDay4Odd3?.length > 0
                            ? Text(
                                'неч. ${model.modelDay4Odd3[0].discName}, ${model.modelDay4Odd3[0].lessonType}, ${model.modelDay4Odd3[0].prepName}, ${model.modelDay4Odd3[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[3].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay4All4?.length > 0
                ? Text(
                    '${model.modelDay4All4[0].discName}, ${model.modelDay4All4[0].lessonType}, ${model.modelDay4All4[0].prepName}, ${model.modelDay4All4[0].auditoryName}',
                  )
                : model.modelDay4Even4?.length > 0 &&
                        model.modelDay4Odd4?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay4Even4[0].discName}, ${model.modelDay4Even4[0].lessonType}, ${model.modelDay4Even4[0].prepName}, ${model.modelDay4Even4[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay4Odd4[0].discName}, ${model.modelDay4Odd4[0].lessonType}, ${model.modelDay4Odd4[0].prepName}, ${model.modelDay4Odd4[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay4Even4?.length > 0
                        ? Text(
                            'чет. ${model.modelDay4Even4[0].discName}, ${model.modelDay4Even4[0].lessonType}, ${model.modelDay4Even4[0].prepName}, ${model.modelDay4Even4[0].auditoryName}',
                          )
                        : model.modelDay4Odd4?.length > 0
                            ? Text(
                                'неч. ${model.modelDay4Odd4[0].discName}, ${model.modelDay4Odd4[0].lessonType}, ${model.modelDay4Odd4[0].prepName}, ${model.modelDay4Odd4[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[4].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay4All5?.length > 0
                ? Text(
                    '${model.modelDay4All5[0].discName}, ${model.modelDay4All5[0].lessonType}, ${model.modelDay4All5[0].prepName}, ${model.modelDay4All5[0].auditoryName}',
                  )
                : model.modelDay4Even5?.length > 0 &&
                        model.modelDay4Odd5?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay4Even5[0].discName}, ${model.modelDay4Even5[0].lessonType}, ${model.modelDay4Even5[0].prepName}, ${model.modelDay4Even5[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay4Odd5[0].discName}, ${model.modelDay4Odd5[0].lessonType}, ${model.modelDay4Odd5[0].prepName}, ${model.modelDay4Odd5[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay4Even5?.length > 0
                        ? Text(
                            'чет. ${model.modelDay4Even5[0].discName}, ${model.modelDay4Even5[0].lessonType}, ${model.modelDay4Even5[0].prepName}, ${model.modelDay4Even5[0].auditoryName}',
                          )
                        : model.modelDay4Odd5?.length > 0
                            ? Text(
                                'неч. ${model.modelDay4Odd5[0].discName}, ${model.modelDay4Odd5[0].lessonType}, ${model.modelDay4Odd5[0].prepName}, ${model.modelDay4Odd5[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[5].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay4All6?.length > 0
                ? Text(
                    '${model.modelDay4All6[0].discName}, ${model.modelDay4All6[0].lessonType}, ${model.modelDay4All6[0].prepName}, ${model.modelDay4All6[0].auditoryName}',
                  )
                : model.modelDay4Even6?.length > 0 &&
                        model.modelDay4Odd6?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay4Even6[0].discName}, ${model.modelDay4Even6[0].lessonType}, ${model.modelDay4Even6[0].prepName}, ${model.modelDay4Even6[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay4Odd6[0].discName}, ${model.modelDay4Odd6[0].lessonType}, ${model.modelDay4Odd6[0].prepName}, ${model.modelDay4Odd6[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay4Even6?.length > 0
                        ? Text(
                            'чет. ${model.modelDay4Even6[0].discName}, ${model.modelDay4Even6[0].lessonType}, ${model.modelDay4Even6[0].prepName}, ${model.modelDay4Even6[0].auditoryName}',
                          )
                        : model.modelDay4Odd6?.length > 0
                            ? Text(
                                'неч. ${model.modelDay4Odd6[0].discName}, ${model.modelDay4Odd6[0].lessonType}, ${model.modelDay4Odd6[0].prepName}, ${model.modelDay4Odd6[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[6].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay4All7?.length > 0
                ? Text(
                    '${model.modelDay4All7[0].discName}, ${model.modelDay4All7[0].lessonType}, ${model.modelDay4All7[0].prepName}, ${model.modelDay4All7[0].auditoryName}',
                  )
                : model.modelDay4Even7?.length > 0 &&
                        model.modelDay4Odd7?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay4Even7[0].discName}, ${model.modelDay4Even7[0].lessonType}, ${model.modelDay4Even7[0].prepName}, ${model.modelDay4Even7[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay4Odd7[0].discName}, ${model.modelDay4Odd7[0].lessonType}, ${model.modelDay4Odd7[0].prepName}, ${model.modelDay4Odd7[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay4Even7?.length > 0
                        ? Text(
                            'чет. ${model.modelDay4Even7[0].discName}, ${model.modelDay4Even7[0].lessonType}, ${model.modelDay4Even7[0].prepName}, ${model.modelDay4Even7[0].auditoryName}',
                          )
                        : model.modelDay4Odd7?.length > 0
                            ? Text(
                                'неч. ${model.modelDay4Odd7[0].discName}, ${model.modelDay4Odd7[0].lessonType}, ${model.modelDay4Odd7[0].prepName}, ${model.modelDay4Odd7[0].auditoryName}',
                              )
                            : const SizedBox()),
      ])
    ],
  );
}

_tableDay5(model) {
  return Table(
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
          child: Text('${model.coupleList[0].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay5All1?.length > 0
                ? Text(
                    '${model.modelDay5All1[0].discName}, ${model.modelDay5All1[0].lessonType}, ${model.modelDay5All1[0].prepName}, ${model.modelDay5All1[0].auditoryName}',
                  )
                : model.modelDay5Even1?.length > 0 &&
                        model.modelDay5Odd1?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay5Even1[0].discName}, ${model.modelDay5Even1[0].lessonType}, ${model.modelDay5Even1[0].prepName}, ${model.modelDay5Even1[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay5Odd1[0].discName}, ${model.modelDay5Odd1[0].lessonType}, ${model.modelDay5Odd1[0].prepName}, ${model.modelDay5Odd1[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay5Even1?.length > 0
                        ? Text(
                            'чет. ${model.modelDay5Even1[0].discName}, ${model.modelDay5Even1[0].lessonType}, ${model.modelDay5Even1[0].prepName}, ${model.modelDay5Even1[0].auditoryName}',
                          )
                        : model.modelDay5Odd1?.length > 0
                            ? Text(
                                'неч. ${model.modelDay5Odd1[0].discName}, ${model.modelDay5Odd1[0].lessonType}, ${model.modelDay5Odd1[0].prepName}, ${model.modelDay5Odd1[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[1].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay5All2?.length > 0
                ? Text(
                    '${model.modelDay5All2[0].discName}, ${model.modelDay5All2[0].lessonType}, ${model.modelDay5All2[0].prepName}, ${model.modelDay5All2[0].auditoryName}',
                  )
                : model.modelDay5Even2?.length > 0 &&
                        model.modelDay5Odd2?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay5Even2[0].discName}, ${model.modelDay5Even2[0].lessonType}, ${model.modelDay5Even2[0].prepName}, ${model.modelDay5Even2[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay5Odd2[0].discName}, ${model.modelDay5Odd2[0].lessonType}, ${model.modelDay5Odd2[0].prepName}, ${model.modelDay5Odd2[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay5Even2?.length > 0
                        ? Text(
                            'чет. ${model.modelDay5Even2[0].discName}, ${model.modelDay5Even2[0].lessonType}, ${model.modelDay5Even2[0].prepName}, ${model.modelDay5Even2[0].auditoryName}',
                          )
                        : model.modelDay5Odd2?.length > 0
                            ? Text(
                                'неч. ${model.modelDay5Odd2[0].discName}, ${model.modelDay5Odd2[0].lessonType}, ${model.modelDay5Odd2[0].prepName}, ${model.modelDay5Odd2[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[2].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay5All3?.length > 0
                ? Text(
                    '${model.modelDay5All3[0].discName}, ${model.modelDay5All3[0].lessonType}, ${model.modelDay5All3[0].prepName}, ${model.modelDay5All3[0].auditoryName}',
                  )
                : model.modelDay5Even3?.length > 0 &&
                        model.modelDay5Odd3?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay5Even3[0].discName}, ${model.modelDay5Even3[0].lessonType}, ${model.modelDay5Even3[0].prepName}, ${model.modelDay5Even3[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay5Odd3[0].discName}, ${model.modelDay5Odd3[0].lessonType}, ${model.modelDay5Odd3[0].prepName}, ${model.modelDay5Odd3[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay5Even3?.length > 0
                        ? Text(
                            'чет. ${model.modelDay5Even3[0].discName}, ${model.modelDay5Even3[0].lessonType}, ${model.modelDay5Even3[0].prepName}, ${model.modelDay5Even3[0].auditoryName}',
                          )
                        : model.modelDay5Odd3?.length > 0
                            ? Text(
                                'неч. ${model.modelDay5Odd3[0].discName}, ${model.modelDay5Odd3[0].lessonType}, ${model.modelDay5Odd3[0].prepName}, ${model.modelDay5Odd3[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[3].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay5All4?.length > 0
                ? Text(
                    '${model.modelDay5All4[0].discName}, ${model.modelDay5All4[0].lessonType}, ${model.modelDay5All4[0].prepName}, ${model.modelDay5All4[0].auditoryName}',
                  )
                : model.modelDay5Even4?.length > 0 &&
                        model.modelDay5Odd4?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay5Even4[0].discName}, ${model.modelDay5Even4[0].lessonType}, ${model.modelDay5Even4[0].prepName}, ${model.modelDay5Even4[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay5Odd4[0].discName}, ${model.modelDay5Odd4[0].lessonType}, ${model.modelDay5Odd4[0].prepName}, ${model.modelDay5Odd4[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay5Even4?.length > 0
                        ? Text(
                            'чет. ${model.modelDay5Even4[0].discName}, ${model.modelDay5Even4[0].lessonType}, ${model.modelDay5Even4[0].prepName}, ${model.modelDay5Even4[0].auditoryName}',
                          )
                        : model.modelDay5Odd4?.length > 0
                            ? Text(
                                'неч. ${model.modelDay5Odd4[0].discName}, ${model.modelDay5Odd4[0].lessonType}, ${model.modelDay5Odd4[0].prepName}, ${model.modelDay5Odd4[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[4].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay5All5?.length > 0
                ? Text(
                    '${model.modelDay5All5[0].discName}, ${model.modelDay5All5[0].lessonType}, ${model.modelDay5All5[0].prepName}, ${model.modelDay5All5[0].auditoryName}',
                  )
                : model.modelDay5Even5?.length > 0 &&
                        model.modelDay5Odd5?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay5Even5[0].discName}, ${model.modelDay5Even5[0].lessonType}, ${model.modelDay5Even5[0].prepName}, ${model.modelDay5Even5[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay5Odd5[0].discName}, ${model.modelDay5Odd5[0].lessonType}, ${model.modelDay5Odd5[0].prepName}, ${model.modelDay5Odd5[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay5Even5?.length > 0
                        ? Text(
                            'чет. ${model.modelDay5Even5[0].discName}, ${model.modelDay5Even5[0].lessonType}, ${model.modelDay5Even5[0].prepName}, ${model.modelDay5Even5[0].auditoryName}',
                          )
                        : model.modelDay5Odd5?.length > 0
                            ? Text(
                                'неч. ${model.modelDay5Odd5[0].discName}, ${model.modelDay5Odd5[0].lessonType}, ${model.modelDay5Odd5[0].prepName}, ${model.modelDay5Odd5[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[5].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay5All6?.length > 0
                ? Text(
                    '${model.modelDay5All6[0].discName}, ${model.modelDay5All6[0].lessonType}, ${model.modelDay5All6[0].prepName}, ${model.modelDay5All6[0].auditoryName}',
                  )
                : model.modelDay5Even6?.length > 0 &&
                        model.modelDay5Odd6?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay5Even6[0].discName}, ${model.modelDay5Even6[0].lessonType}, ${model.modelDay5Even6[0].prepName}, ${model.modelDay5Even6[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay5Odd6[0].discName}, ${model.modelDay5Odd6[0].lessonType}, ${model.modelDay5Odd6[0].prepName}, ${model.modelDay5Odd6[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay5Even6?.length > 0
                        ? Text(
                            'чет. ${model.modelDay5Even6[0].discName}, ${model.modelDay5Even6[0].lessonType}, ${model.modelDay5Even6[0].prepName}, ${model.modelDay5Even6[0].auditoryName}',
                          )
                        : model.modelDay5Odd6?.length > 0
                            ? Text(
                                'неч. ${model.modelDay5Odd6[0].discName}, ${model.modelDay5Odd6[0].lessonType}, ${model.modelDay5Odd6[0].prepName}, ${model.modelDay5Odd6[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[6].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay5All7?.length > 0
                ? Text(
                    '${model.modelDay5All7[0].discName}, ${model.modelDay5All7[0].lessonType}, ${model.modelDay5All7[0].prepName}, ${model.modelDay5All7[0].auditoryName}',
                  )
                : model.modelDay5Even7?.length > 0 &&
                        model.modelDay5Odd7?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay5Even7[0].discName}, ${model.modelDay5Even7[0].lessonType}, ${model.modelDay5Even7[0].prepName}, ${model.modelDay5Even7[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay5Odd7[0].discName}, ${model.modelDay5Odd7[0].lessonType}, ${model.modelDay5Odd7[0].prepName}, ${model.modelDay5Odd7[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay5Even7?.length > 0
                        ? Text(
                            'чет. ${model.modelDay5Even7[0].discName}, ${model.modelDay5Even7[0].lessonType}, ${model.modelDay5Even7[0].prepName}, ${model.modelDay5Even7[0].auditoryName}',
                          )
                        : model.modelDay5Odd7?.length > 0
                            ? Text(
                                'неч. ${model.modelDay5Odd7[0].discName}, ${model.modelDay5Odd7[0].lessonType}, ${model.modelDay5Odd7[0].prepName}, ${model.modelDay5Odd7[0].auditoryName}',
                              )
                            : const SizedBox()),
      ])
    ],
  );
}

_tableDay6(model) {
  return Table(
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
          child: Text('${model.coupleList[0].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay6All1?.length > 0
                ? Text(
                    '${model.modelDay6All1[0].discName}, ${model.modelDay6All1[0].lessonType}, ${model.modelDay6All1[0].prepName}, ${model.modelDay6All1[0].auditoryName}',
                  )
                : model.modelDay6Even1?.length > 0 &&
                        model.modelDay6Odd1?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay6Even1[0].discName}, ${model.modelDay6Even1[0].lessonType}, ${model.modelDay6Even1[0].prepName}, ${model.modelDay6Even1[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay6Odd1[0].discName}, ${model.modelDay6Odd1[0].lessonType}, ${model.modelDay6Odd1[0].prepName}, ${model.modelDay6Odd1[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay6Even1?.length > 0
                        ? Text(
                            'чет. ${model.modelDay6Even1[0].discName}, ${model.modelDay6Even1[0].lessonType}, ${model.modelDay6Even1[0].prepName}, ${model.modelDay6Even1[0].auditoryName}',
                          )
                        : model.modelDay6Odd1?.length > 0
                            ? Text(
                                'неч. ${model.modelDay6Odd1[0].discName}, ${model.modelDay6Odd1[0].lessonType}, ${model.modelDay6Odd1[0].prepName}, ${model.modelDay6Odd1[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[1].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay6All2?.length > 0
                ? Text(
                    '${model.modelDay6All2[0].discName}, ${model.modelDay6All2[0].lessonType}, ${model.modelDay6All2[0].prepName}, ${model.modelDay6All2[0].auditoryName}',
                  )
                : model.modelDay6Even2?.length > 0 &&
                        model.modelDay6Odd2?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay6Even2[0].discName}, ${model.modelDay6Even2[0].lessonType}, ${model.modelDay6Even2[0].prepName}, ${model.modelDay6Even2[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay6Odd2[0].discName}, ${model.modelDay6Odd2[0].lessonType}, ${model.modelDay6Odd2[0].prepName}, ${model.modelDay6Odd2[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay6Even2?.length > 0
                        ? Text(
                            'чет. ${model.modelDay6Even2[0].discName}, ${model.modelDay6Even2[0].lessonType}, ${model.modelDay6Even2[0].prepName}, ${model.modelDay6Even2[0].auditoryName}',
                          )
                        : model.modelDay6Odd2?.length > 0
                            ? Text(
                                'неч. ${model.modelDay6Odd2[0].discName}, ${model.modelDay6Odd2[0].lessonType}, ${model.modelDay6Odd2[0].prepName}, ${model.modelDay6Odd2[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[2].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay6All3?.length > 0
                ? Text(
                    '${model.modelDay6All3[0].discName}, ${model.modelDay6All3[0].lessonType}, ${model.modelDay6All3[0].prepName}, ${model.modelDay6All3[0].auditoryName}',
                  )
                : model.modelDay6Even3?.length > 0 &&
                        model.modelDay6Odd3?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay6Even3[0].discName}, ${model.modelDay6Even3[0].lessonType}, ${model.modelDay6Even3[0].prepName}, ${model.modelDay6Even3[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay6Odd3[0].discName}, ${model.modelDay6Odd3[0].lessonType}, ${model.modelDay6Odd3[0].prepName}, ${model.modelDay6Odd3[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay6Even3?.length > 0
                        ? Text(
                            'чет. ${model.modelDay6Even3[0].discName}, ${model.modelDay6Even3[0].lessonType}, ${model.modelDay6Even3[0].prepName}, ${model.modelDay6Even3[0].auditoryName}',
                          )
                        : model.modelDay6Odd3?.length > 0
                            ? Text(
                                'неч. ${model.modelDay6Odd3[0].discName}, ${model.modelDay6Odd3[0].lessonType}, ${model.modelDay6Odd3[0].prepName}, ${model.modelDay6Odd3[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[3].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay6All4?.length > 0
                ? Text(
                    '${model.modelDay6All4[0].discName}, ${model.modelDay6All4[0].lessonType}, ${model.modelDay6All4[0].prepName}, ${model.modelDay6All4[0].auditoryName}',
                  )
                : model.modelDay6Even4?.length > 0 &&
                        model.modelDay6Odd4?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay6Even4[0].discName}, ${model.modelDay6Even4[0].lessonType}, ${model.modelDay6Even4[0].prepName}, ${model.modelDay6Even4[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay6Odd4[0].discName}, ${model.modelDay6Odd4[0].lessonType}, ${model.modelDay6Odd4[0].prepName}, ${model.modelDay6Odd4[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay6Even4?.length > 0
                        ? Text(
                            'чет. ${model.modelDay6Even4[0].discName}, ${model.modelDay6Even4[0].lessonType}, ${model.modelDay6Even4[0].prepName}, ${model.modelDay6Even4[0].auditoryName}',
                          )
                        : model.modelDay6Odd4?.length > 0
                            ? Text(
                                'неч. ${model.modelDay6Odd4[0].discName}, ${model.modelDay6Odd4[0].lessonType}, ${model.modelDay6Odd4[0].prepName}, ${model.modelDay6Odd4[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[4].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay6All5?.length > 0
                ? Text(
                    '${model.modelDay6All5[0].discName}, ${model.modelDay6All5[0].lessonType}, ${model.modelDay6All5[0].prepName}, ${model.modelDay6All5[0].auditoryName}',
                  )
                : model.modelDay6Even5?.length > 0 &&
                        model.modelDay6Odd5?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay6Even5[0].discName}, ${model.modelDay6Even5[0].lessonType}, ${model.modelDay6Even5[0].prepName}, ${model.modelDay6Even5[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay6Odd5[0].discName}, ${model.modelDay6Odd5[0].lessonType}, ${model.modelDay6Odd5[0].prepName}, ${model.modelDay6Odd5[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay6Even5?.length > 0
                        ? Text(
                            'чет. ${model.modelDay6Even5[0].discName}, ${model.modelDay6Even5[0].lessonType}, ${model.modelDay6Even5[0].prepName}, ${model.modelDay6Even5[0].auditoryName}',
                          )
                        : model.modelDay6Odd5?.length > 0
                            ? Text(
                                'неч. ${model.modelDay6Odd5[0].discName}, ${model.modelDay6Odd5[0].lessonType}, ${model.modelDay6Odd5[0].prepName}, ${model.modelDay6Odd5[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[5].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay6All6?.length > 0
                ? Text(
                    '${model.modelDay6All6[0].discName}, ${model.modelDay6All6[0].lessonType}, ${model.modelDay6All6[0].prepName}, ${model.modelDay6All6[0].auditoryName}',
                  )
                : model.modelDay6Even6?.length > 0 &&
                        model.modelDay6Odd6?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay6Even6[0].discName}, ${model.modelDay6Even6[0].lessonType}, ${model.modelDay6Even6[0].prepName}, ${model.modelDay6Even6[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay6Odd6[0].discName}, ${model.modelDay6Odd6[0].lessonType}, ${model.modelDay6Odd6[0].prepName}, ${model.modelDay6Odd6[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay6Even6?.length > 0
                        ? Text(
                            'чет. ${model.modelDay6Even6[0].discName}, ${model.modelDay6Even6[0].lessonType}, ${model.modelDay6Even6[0].prepName}, ${model.modelDay6Even6[0].auditoryName}',
                          )
                        : model.modelDay6Odd6?.length > 0
                            ? Text(
                                'неч. ${model.modelDay6Odd6[0].discName}, ${model.modelDay6Odd6[0].lessonType}, ${model.modelDay6Odd6[0].prepName}, ${model.modelDay6Odd6[0].auditoryName}',
                              )
                            : const SizedBox())
      ]),
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${model.coupleList[6].desc}'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.modelDay6All7?.length > 0
                ? Text(
                    '${model.modelDay6All7[0].discName}, ${model.modelDay6All7[0].lessonType}, ${model.modelDay6All7[0].prepName}, ${model.modelDay6All7[0].auditoryName}',
                  )
                : model.modelDay6Even7?.length > 0 &&
                        model.modelDay6Odd7?.length > 0
                    ? Column(
                        children: [
                          Text(
                            'чет. ${model.modelDay6Even7[0].discName}, ${model.modelDay6Even7[0].lessonType}, ${model.modelDay6Even7[0].prepName}, ${model.modelDay6Even7[0].auditoryName}',
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text(
                            'неч. ${model.modelDay6Odd7[0].discName}, ${model.modelDay6Odd7[0].lessonType}, ${model.modelDay6Odd7[0].prepName}, ${model.modelDay6Odd7[0].auditoryName}',
                          )
                        ],
                      )
                    : model.modelDay6Even7?.length > 0
                        ? Text(
                            'чет. ${model.modelDay6Even7[0].discName}, ${model.modelDay6Even7[0].lessonType}, ${model.modelDay6Even7[0].prepName}, ${model.modelDay6Even7[0].auditoryName}',
                          )
                        : model.modelDay6Odd7?.length > 0
                            ? Text(
                                'неч. ${model.modelDay6Odd7[0].discName}, ${model.modelDay6Odd7[0].lessonType}, ${model.modelDay6Odd7[0].prepName}, ${model.modelDay6Odd7[0].auditoryName}',
                              )
                            : const SizedBox()),
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
