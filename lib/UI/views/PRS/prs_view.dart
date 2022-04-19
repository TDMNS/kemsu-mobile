import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import '../schedule/schedule_model.dart';
import '../schedule/schedule_view.dart';
import 'prs_viewmodel.dart';

class PRSView extends StatelessWidget {
  const PRSView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PRSViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => PRSViewModel(context),
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
                  appBar: customAppBar(context, model, 'БРС'),
                  bottomNavigationBar: customBottomBar(context, model),
                  body: _prsView(context, model),
                ),
              ));
        });
  }
}

_prsView(context, PRSViewModel model) {
  dropdownItems = List.generate(
    model.studentCard.length,
    (index) => DropdownMenuItem(
      value: model.studentCard[index].id.toString(),
      child: Text(
        '${model.studentCard[index].speciality}',
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
              child: DropdownButton<StudentCard>(
                hint: const Text(
                  'Выбрать группу',
                  style: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  model.changeCard(value);
                },
                isExpanded: true,
                value: model.card,
                items:
                    model.studentCard.map<DropdownMenuItem<StudentCard>>((e) {
                  return DropdownMenuItem<StudentCard>(
                    child: Text(e.speciality.toString()),
                    value: e,
                  );
                }).toList(),
              )),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
