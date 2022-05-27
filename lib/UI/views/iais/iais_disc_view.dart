import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './iais_viewmodel.dart';
import './iais_model.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class IaisRepView extends StatelessWidget {
  const IaisRepView({Key? key, required this.discData, required this.repList}) : super(key: key);
  final CourseIais discData;
  final List<ReportIais> repList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IaisViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => IaisViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness
                    .dark), //прозрачность statusbar и установка тёмных иконок
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, model, discData.DISC_NAME),
              bottomNavigationBar: customBottomBar(context, model),
              body: _iaisRepView(context, model, repList, discData),
            ),
          );
        });
  }
}

_iaisRepView(BuildContext context, IaisViewModel model, repList, discData) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 12),
      Center(
        child: Card(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
                child: Container(
                  child: ExpansionTile(
                    expandedAlignment: Alignment.center,
                    title: const Text(
                    'Данные о дисциплине',
                    style: TextStyle(
                      fontFamily: "Ubuntu",
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Дисциплина: '),
                                  TextSpan(
                                    text: discData.DISC_NAME,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Отчётность: '),
                                  TextSpan(
                                      text: discData.DISC_REP,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Часы: '),
                                  TextSpan(
                                      text: discData.DISC_HOURS.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Период проведения: '),
                                  TextSpan(
                                      text: discData.DISC_FIRST_DATE + " - " + discData.DISC_LAST_DATE,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Преподаватель: '),
                                  TextSpan(
                                      text: discData.FIO,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Количество баллов: '),
                                  TextSpan(
                                      text: discData.DISC_MARK.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                          ],
                        ),
                      ),
                    ],
                  ),
      )))),
      const SizedBox(height: 20),
      DataTable(
        columns: [
          DataColumn(label: Container(
            child: Expanded(child: Text('Название', textAlign: TextAlign.center, softWrap: true)),
              )),
          DataColumn(label: Container(
            child: Expanded(child: Text('Контр. дата', textAlign: TextAlign.center, softWrap: true)),
              )),
          DataColumn(label: Container(
            child: Expanded(child: Text('Макс. балл', textAlign: TextAlign.center, softWrap: true)),
              )),
          DataColumn(label: Container(
            child: Expanded(child: Text('Рез.', textAlign: TextAlign.center, softWrap: true)),
              )),
          DataColumn(label: Container(
            child: Expanded(child: Text('Сост.', textAlign: TextAlign.center, softWrap: true)),
              )),
        ],
        rows: repList.map<DataRow>((e) => DataRow(
          onSelectChanged: (selected) {
            if (selected==true) {
              print(e.STUDENT_TASK_LIST.toString());
            }
          },
          cells: [
            DataCell(Text(e.NAME.toString(), textAlign: TextAlign.center, softWrap: true)),
            DataCell(Text(e.REP_CONTROL_DATE.toString(), textAlign: TextAlign.center, softWrap: true)),
            DataCell(Text(e.MAX_BALL.toString(), textAlign: TextAlign.center, softWrap: true)),
            DataCell(Text(e.SUM_BALL.toString(), textAlign: TextAlign.center, softWrap: true)),
            DataCell(Text("", textAlign: TextAlign.center, softWrap: true)),
          ],
        )).toList(),
        border: TableBorder.all(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.5,
        ),
        dataRowHeight: 70,
        showCheckboxColumn: false,
        columnSpacing: 3,
      ),
  ]);
}

