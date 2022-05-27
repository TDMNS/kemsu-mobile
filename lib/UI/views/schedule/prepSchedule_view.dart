import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/schedule/prepSchedule_model.dart';
import 'package:kemsu_app/UI/views/schedule/prepSchedule_viewmodel.dart';

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
                child: Scaffold(
                    extendBody: true,
                    extendBodyBehindAppBar: true,
                    appBar: customAppBar(context, model, 'Расписание'),
                    bottomNavigationBar: customBottomBar(context, model),
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
      Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<TeacherList>(
                hint: const Text(
                  'Выбрать преподавателя',
                  style: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  model.changeTeacher(value);
                },
                isExpanded: true,
                value: model.choiceTeacher,
                items:
                    model.teacherList.map<DropdownMenuItem<TeacherList>>((e) {
                  return DropdownMenuItem<TeacherList>(
                    child: Text(e.fio.toString()),
                    value: e,
                  );
                }).toList(),
              )),
        ),
      ),
    ],
  );
}
