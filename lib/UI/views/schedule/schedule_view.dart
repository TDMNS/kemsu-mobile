import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

final loginController = TextEditingController();
final passwordController = TextEditingController();

class ScheduleView extends StatelessWidget {
  const ScheduleView({Key? key}) : super(key: key);

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
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  appBar: customAppBar(context, model, 'Расписание'),
                  bottomNavigationBar: customBottomBar(context, model),
                  body: _scheduleView(context, model),
                ),
              ));
        });
  }
}

_scheduleView(BuildContext context, ScheduleViewModel model) {
  return ListView(
    children: <Widget>[
      Center(
        child: SizedBox(
          width: 140,
          child: DropdownButton<String>(
            value: model.dropdownValue,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            onChanged: (newValue) {
              model.newDropDownValue(newValue);
            },
            items: <String>[
              'Выбор семестра',
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: SizedBox(
          width: 140,
          child: DropdownButton<String>(
            value: model.dropdownValue2,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            onChanged: (newValue) {
              model.newDropDownValue2(newValue);
            },
            items: <String>[
              'Выбор института',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: SizedBox(
          width: 140,
          child: DropdownButton<String>(
            value: model.dropdownValue3,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            onChanged: (newValue) {
              model.newDropDownValue3(newValue);
            },
            items: <String>[
              'Выбор группы',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      )
    ],
  );
}
