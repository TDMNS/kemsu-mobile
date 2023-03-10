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
  State<NewScheduleView> createState() => _NewScheduleViewState();
}

class _NewScheduleViewState extends State<NewScheduleView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewScheduleViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => NewScheduleViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark), //прозрачность statusbar и установка тёмных иконок
              child: WillPopScope(
                onWillPop: () async => false,
                child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context); //расфокус textfield при нажатии на экран
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
  return model.circle == true
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : ListView(
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
                      model.indexDay == 0
                          ? const Text(
                              'Понедельник',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 1
                          ? const Text(
                              'Вторник',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 2
                          ? const Text(
                              'Среда',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 3
                          ? const Text(
                              'Четверг',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 4
                          ? const Text(
                              'Пятница',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : const Text(''),
                      model.indexDay == 5
                          ? const Text(
                              'Суббота',
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
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
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
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30), child: _scheduleTable(context, model)),
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
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(25), boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 15))
                  ]),
                  child: const Center(
                      child: Text(
                    'Расписание преподавателей',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
            model.getScheduleString();
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
                items: model.facultyList.map<DropdownMenuItem<FacultyList>>((e) {
                  return DropdownMenuItem<FacultyList>(
                      child: Text(e.faculty.toString(), style: const TextStyle(color: Colors.black)), value: e);
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
            model.getScheduleString();
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            height: 50,
            decoration: BoxDecoration(
                color: model.scheduleGroup == null ? Colors.grey : Colors.red,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 15))
                ]),
            child: const Center(
              child: Text(
                'Показать',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
                  model.indexDay == 0
                      ? const Text(
                          'Понедельник',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      : const Text(''),
                  model.indexDay == 1
                      ? const Text(
                          'Вторник',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      : const Text(''),
                  model.indexDay == 2
                      ? const Text(
                          'Среда',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      : const Text(''),
                  model.indexDay == 3
                      ? const Text(
                          'Четверг',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      : const Text(''),
                  model.indexDay == 4
                      ? const Text(
                          'Пятница',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      : const Text(''),
                  model.indexDay == 5
                      ? const Text(
                          'Суббота',
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
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
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
          child: model.tableView == false ? const SizedBox() : _scheduleTable(context, model))
    ],
  );
}

_scheduleTable(BuildContext context, NewScheduleViewModel model) {
  List<TableRow> rows = [];
  rows.add(const TableRow(children: [
    Text('Время'),
    Text('Пары'),
  ]));
  for (int i = 0; i < 7; i++) {
    rows.add(TableRow(children: [
      Text(model.coupleTime[i]),
      model.weekType == true
          ? model.indexDay == 6
              ? const Text('')
              : Text('${model.coupleAllList![i]}\r\n${model.coupleEvenList![i]}')
          : model.indexDay == 6
              ? const Text('')
              : Text('${model.coupleAllList![i]}\r\n${model.coupleOddList![i]}'),
    ]));
  }
  return Table(
      border: TableBorder.all(
        color: Theme.of(context).canvasColor,
      ),
      children: rows);
}
