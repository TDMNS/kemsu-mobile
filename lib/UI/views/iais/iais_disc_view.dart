import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './iais_viewmodel.dart';
import './iais_taskblock_view.dart';
import './iais_model.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class IaisRepView extends StatelessWidget {
  const IaisRepView({Key? key, required this.discData, required this.repList})
      : super(key: key);
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
  return ListView(children: <Widget>[
    const SizedBox(height: 12),
    Center(
        child: Card(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Padding(
                padding: const EdgeInsets.all(2.0),
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
                                    text: discData.DISC_FIRST_DATE +
                                        " - " +
                                        discData.DISC_LAST_DATE,
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
                )))),
    const SizedBox(height: 20),
    Expanded(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(
        columns: [
          const DataColumn(
              label: Text(
            'Название',
          )),
          DataColumn(
              label: Expanded(
            child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Контрольная дата'),
                      content: const Text('Контрольная дата блока заданий'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Закрыть'))
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text('Контр. дата',
                    textAlign: TextAlign.center, softWrap: true)),
          )),
          DataColumn(
              label: Expanded(
            child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Максимальный балл'),
                      content: const Text(
                          'Максимальный балл, который можно получить за выполнение всех заданий в блоке'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Закрыть'))
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text('Макс. балл',
                    textAlign: TextAlign.center, softWrap: true)),
          )),
          DataColumn(
              label: Expanded(
            child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Текущий балл'),
                      content: const Text(
                          'Текущий балл, полученный за выполнение заданий в блоке'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Закрыть'))
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text('Рез.',
                    textAlign: TextAlign.center, softWrap: true)),
          )),
        ],
        rows: repList
            .map<DataRow>((e) => DataRow(
                  onSelectChanged: (selected) async {
                    if (selected == true) {
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IaisTaskBlockView(
                                    repData: e.STUDENT_TASK_LIST,
                                    blockName: e.NAME,
                                  )),
                        );
                      }
                    }
                  },
                  cells: [
                    DataCell(Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        e.NAME.toString(),
                      ),
                    )),
                    DataCell(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        e.REP_CONTROL_DATE.toString(),
                      ),
                    )),
                    DataCell(Center(
                      child: Text(
                        e.MAX_BALL.toString(),
                      ),
                    )),
                    DataCell(Center(
                      child: Text(
                        e.SUM_BALL.toString(),
                      ),
                    )),
                  ],
                ))
            .toList(),
        border: TableBorder.all(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.5,
        ),
        dataRowHeight: 70,
        showCheckboxColumn: false,
        columnSpacing: 1,
      ),
    ))
  ]);
}
