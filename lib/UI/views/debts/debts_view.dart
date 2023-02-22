import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './debts_viewmodel.dart';
import 'package:stacked/stacked.dart';
import '../../widgets.dart';

class DebtsView extends StatefulWidget {
  const DebtsView({Key? key}) : super(key: key);

  @override
  State<DebtsView> createState() => _DebtsViewState();
}

class _DebtsViewState extends State<DebtsView> {
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
                    .dark),
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, model, 'Долги'),
              body: RefreshIndicator(
                backgroundColor: Colors.blue,
                color: Colors.white,
                onRefresh: () => _pullRefresh(model),
                child: _debtsView(context, model),
              )
            ),
          );
        });
  }

  Future<void> _pullRefresh(DebtsViewModel model) async {
    await model.updateDebts();
  }
}

_debtsView(BuildContext context, DebtsViewModel model) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 12),
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: model.debtsCourse.isNotEmpty
          ? Column(
            children: [
              model.libraryDebts.isNotEmpty ?
              ElevatedButton(
                  onPressed: () {
                    DataTable(
                      columnSpacing: 0,
                      columns: const [
                        DataColumn(
                          label: Expanded(
                              child: Text('Книга',
                                  textAlign: TextAlign.center, softWrap: true)),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text('Дата выдачи книги',
                                  textAlign: TextAlign.center, softWrap: true)),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text('Предполагаемая дата возврата книги',
                                  textAlign: TextAlign.center, softWrap: true)),
                        )
                      ],
                      rows: model.libraryDebts.map<DataRow>((e) => DataRow(cells: [
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.info.toString(),
                                textAlign: TextAlign.center, softWrap: true))),
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.extraditionDay.toString(),
                                textAlign: TextAlign.center, softWrap: true))),
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.estimatedReturnDay.toString(),
                                textAlign: TextAlign.center, softWrap: true)))
                      ])).toList(),
                      border: TableBorder.all(
                        color: Theme.of(context).canvasColor,
                        style: BorderStyle.solid,
                        width: 1.5,
                      ),
                      dataRowHeight: 80,
                      showCheckboxColumn: false,
                    );
                  },
                  child: const Text('Показать долги по книгам'))
              : const SizedBox.shrink(),
              model.debtsCourse.isNotEmpty ?
              ElevatedButton(
                  onPressed: () {
                    DataTable(
                      columnSpacing: 0,
                      columns: const [
                        DataColumn(
                          label: Expanded(
                              child: Text('Номер курса',
                                  textAlign: TextAlign.center, softWrap: true)),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text('Номер семестра',
                                  textAlign: TextAlign.center, softWrap: true)),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text('Дисциплина',
                                  textAlign: TextAlign.center, softWrap: true)),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Text('Текущая оценка',
                                  textAlign: TextAlign.center, softWrap: true)),
                        ),
                      ],
                      rows: model.debtsCourse.map<DataRow>((e) => DataRow(cells: [
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.course.toString(),
                                textAlign: TextAlign.center, softWrap: true))),
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.semester.toString(),
                                textAlign: TextAlign.center, softWrap: true))),
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.discipline.toString(),
                                textAlign: TextAlign.center, softWrap: true))),
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.shortMark.toString(),
                                textAlign: TextAlign.center, softWrap: true))),
                      ])).toList(),
                      border: TableBorder.all(
                        color: Theme.of(context).canvasColor,
                        style: BorderStyle.solid,
                        width: 1.5,
                      ),
                      dataRowHeight: 80,
                      showCheckboxColumn: false,
                    );
                  },
                  child: const Text('Показать др. виды задолженности'))
              : const SizedBox.shrink(),
            ],
          )
          : const Text("Долги отсутствуют"),
        ),
      ),
    ],
  );
}
