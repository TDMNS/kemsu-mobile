import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './iais_viewmodel.dart';
import './iais_disc_view.dart';
import './iais_model.dart';
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
              bottomNavigationBar: customBottomBar(context, model),
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
          SizedBox(
            width: 10,
          ),
          Text(
            'Показать все ',
            style: TextStyle(fontSize: 17.0),
          ),
          SizedBox(width: 10), //SizedBox
          Checkbox(
              value: model.isChecked,
              onChanged: (e) {
                model.isChecked = !model.isChecked;
                if(model.isChecked) model.getDiscs(1);
                else model.getDiscs(0);
              }),
        ],
      ),
        Center(
          child: Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Container(
                    child: Expanded(child: Text('Дисциплина', textAlign: TextAlign.center, softWrap: true)),
                  )),
                  DataColumn(label: Container(
                    child: Expanded(child: Text('Преподаватель', textAlign: TextAlign.center, softWrap: true)),
                  )),
                ],
                rows: model.Course.map<DataRow>((e) => DataRow(
                  onSelectChanged: (selected) async {
                    if (selected==true) {{
                      print(e.DISC_NAME);
                      print(e.COURSE_ID);
                      await model.getDiscReports(e.COURSE_ID);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IaisRepView(
                            discData: e,
                            repList: model.Report
                        )),
                      );
                    };}
                  },
                    cells: [
                        DataCell(Text(e.DISC_NAME.toString(), textAlign: TextAlign.center, softWrap: true)),
                        DataCell(Text(e.FIO.toString(), textAlign: TextAlign.center, softWrap: true)),
                ]
                )).toList(),
                border: TableBorder.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 1.5,
                  ),
                dataRowHeight: 100,
                showCheckboxColumn: false,

                ),
                    )),
                  ),
        ],
  );
}

