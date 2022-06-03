import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './iais_viewmodel.dart';
import './iais_model.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class IaisTaskBlockView extends StatelessWidget {
  const IaisTaskBlockView({Key? key, required this.repData, required this.blockName}) : super(key: key);
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
              bottomNavigationBar: customBottomBar(context, model),
              body: _iaisTaskBlockView(context, model, repData),
            ),
          );
        });
  }
}

_iaisTaskBlockView(BuildContext context, IaisViewModel model, repData) {
  return ListView(
      children: <Widget>[
        const SizedBox(height: 12),
        Center(
            child: Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                    child:
        DataTable(
          columns: [
            DataColumn(label: Container(
              child: Expanded(child: Text('Название', textAlign: TextAlign.left, softWrap: true)),
            )),
            DataColumn(label: Container(
              child: Expanded(child: Text('Реш.', textAlign: TextAlign.center, softWrap: true)),
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
              child: Expanded(child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Состояние'),
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
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text('Сост.', textAlign: TextAlign.left)),),
            )),
          ],
          rows: repData.map<DataRow>((e) => DataRow(
            onSelectChanged: (selected) async {
              if (selected==true) {{
                print(e.NAME);
              };}
            },
            cells: [
              DataCell(Text(e.NAME.toString(), textAlign: TextAlign.left)),
              DataCell(Text(e.SOLVE_FLAG.toString(), textAlign: TextAlign.center)),
              DataCell(Text(e.TASK_CONTROL_DATE.toString(), textAlign: TextAlign.center)),
              DataCell(Text(e.MAX_BALL.toString(), textAlign: TextAlign.center)),
              DataCell(Text(e.SUM_BALL.toString(), textAlign: TextAlign.center)),
              DataCell(Text(e.SOLUTION_STATUS_SHORT.toString(), textAlign: TextAlign.center)),
            ],
          )).toList(),
          border: TableBorder.all(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 1.5,
          ),
          dataRowHeight: 100,
          showCheckboxColumn: false,
          columnSpacing: 2,
        ),
                )))]);
}