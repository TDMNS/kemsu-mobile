import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './debts_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class DebtsView extends StatelessWidget {
  const DebtsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DebtsViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => DebtsViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness
                    .dark), //прозрачность statusbar и установка тёмных иконок
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, model, 'Долги'),
              bottomNavigationBar: customBottomBar(context, model),
              body: _debtsView(context, model),
            ),
          );
        });
  }
}

_debtsView(BuildContext context, DebtsViewModel model) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 12),
      Center(
        child: Expanded(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            columnSpacing: 0,
            columns: [
              DataColumn(
                  label: Container(
                child: Expanded(
                    child: Text('Номер курса',
                        textAlign: TextAlign.center, softWrap: true)),
              )),
              DataColumn(
                  label: Container(
                child: Expanded(
                    child: Text('Номер семестра',
                        textAlign: TextAlign.center, softWrap: true)),
              )),
              DataColumn(
                  label: Container(
                child: Expanded(
                    child: Text('Дисциплина',
                        textAlign: TextAlign.center, softWrap: true)),
              )),
              DataColumn(
                  label: Container(
                child: Expanded(
                    child: Text('Текущая оценка',
                        textAlign: TextAlign.center, softWrap: true)),
              )),
            ],
            rows: model.DebtsCourse.map<DataRow>((e) => DataRow(cells: [
                  DataCell(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.COURSE.toString(),
                      textAlign: TextAlign.center, softWrap: true))),
                  DataCell(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.SEMESTER.toString(),
                      textAlign: TextAlign.center, softWrap: true))),
                  DataCell(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.DISCIPLINE.toString(),
                      textAlign: TextAlign.center, softWrap: true))),
                  DataCell(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(e.OCENKA_SHORT.toString(),
                      textAlign: TextAlign.center, softWrap: true))),
                ])).toList(),
            border: TableBorder.all(
              color: Colors.black,
              style: BorderStyle.solid,
              width: 1.5,
            ),
            dataRowHeight: 80,
            showCheckboxColumn: false,
          ),
        )),
      ),
    ],
  );
}
