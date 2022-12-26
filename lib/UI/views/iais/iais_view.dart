import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './iais_viewmodel.dart';
import './iais_disc_view.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class IaisView extends StatelessWidget {
  const IaisView({Key? key}) : super(key: key);

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
              appBar: customAppBar(context, model, 'ИнфОУПро'),
              //bottomNavigationBar: customBottomBar(context, model),
              body: _iaisView(context, model),
            ),
          );
        });
  }
}

_iaisView(BuildContext context, IaisViewModel model) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 12),
      Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Показать все ',
            style: TextStyle(fontSize: 17.0),
          ),
          const SizedBox(width: 10), //SizedBox
          Checkbox(
              value: model.isChecked,
              onChanged: (e) {
                model.isChecked = !model.isChecked;
                if (model.isChecked) {
                  model.getDiscs(1);
                } else {
                  model.getDiscs(0);
                }
              }),
        ],
      ),
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            columns: const [
              DataColumn(
                  label: Expanded(
                      child: Text('Дисциплина', textAlign: TextAlign.center))),
              DataColumn(
                  label: Expanded(
                      child:
                          Text('Преподаватель', textAlign: TextAlign.center))),
            ],
            rows: model.Course.map<DataRow>((e) => DataRow(
                    onSelectChanged: (selected) async {
                      if (selected == true) {
                        {
                          await model.getDiscReports(e.COURSE_ID);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IaisRepView(
                                    discData: e, repList: model.Report)),
                          );
                        }
                      }
                    },
                    cells: [
                      DataCell(Text(e.DISC_NAME.toString())),
                      DataCell(Text(e.FIO.toString())),
                    ])).toList(),
            border: TableBorder.all(
              color: Theme.of(context).canvasColor,
              style: BorderStyle.solid,
              width: 1.5,
            ),
            dataRowHeight: 100,
            showCheckboxColumn: false,
          ),
        ),
      ),
    ],
  );
}
