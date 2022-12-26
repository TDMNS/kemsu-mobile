import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './iais_viewmodel.dart';
import './iais_model.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class IaisTaskBlockView extends StatelessWidget {
  const IaisTaskBlockView(
      {Key? key, required this.repData, required this.blockName})
      : super(key: key);
  final List<TaskListIais> repData;
  final String blockName;

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
              appBar: customAppBar(context, model, blockName),
              //bottomNavigationBar: customBottomBar(context, model),
              body: _iaisTaskBlockView(context, model, repData),
            ),
          );
        });
  }
}

_iaisTaskBlockView(BuildContext context, IaisViewModel model, repData) {
  return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: <Widget>[
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: DataTable(
            columns: [
              const DataColumn(label: Text('Название')),
              const DataColumn(label: Text('Реш.')),
              const DataColumn(
                  label: Expanded(
                      child: Text(
                'Контр. дата',
                textAlign: TextAlign.center,
                softWrap: true,
              ))),
              const DataColumn(
                  label: Expanded(
                      child: Text(
                'Макс. балл',
                softWrap: true,
              ))),
              const DataColumn(label: Text('Рез.')),
              DataColumn(
                  label: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Состояние',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                          'Статус задания.\nНе см. - Не просмотрено\nСм. - Просмотрено\nРед. - Редактируется\nНа пр. - На проверке\nОтпр. на дор. - Отправлено на доработку\nОц. - Оценено'),
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
                child: const Text(
                  'Сост.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
            ],
            rows: repData
                .map<DataRow>((e) => DataRow(
                      onSelectChanged: (selected) async {
                        if (selected == true) {
                          {}
                        }
                      },
                      cells: [
                        DataCell(Text(e.NAME.toString())),
                        DataCell(Center(
                          child: Text(
                            e.SOLVE_FLAG.toString(),
                          ),
                        )),
                        DataCell(Text(e.TASK_CONTROL_DATE.toString(),
                            textAlign: TextAlign.center)),
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
                        DataCell(Text(
                          e.SOLUTION_STATUS_SHORT.toString(),
                        )),
                      ],
                    ))
                .toList(),
            border: TableBorder.all(
              color: Theme.of(context).canvasColor,
              style: BorderStyle.solid,
              width: 1.5,
            ),
            dataRowHeight: 100,
            showCheckboxColumn: false,
            columnSpacing: 2,
          ),
        )
      ]);
}
