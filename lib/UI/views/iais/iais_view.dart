import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './iais_viewmodel.dart';
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
        Center(
          child: Card(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Дисциплина')),
                  DataColumn(label: Text('Преподаватель')),
                ],
                rows: model.Course.map<DataRow>((e) => DataRow(cells: [
                  DataCell(Text(e.DISC_NAME.toString())),
                  DataCell(Text(e.FIO.toString())),
                ],
                /*onSelectChanged: (boo) {
                  if (boo==true) {() async {
                    await model.getReitList(e.startDate,
                    e.endDate, e.semester);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PRSDetailView(
                          reitList: e.discName,
                          semester: e.FIO
                        )),
                      );
                    }},

                  }
                }*/
                )).toList(),
                border: TableBorder.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 1.5,
                  ),
                dataRowHeight: 100,
                showCheckboxColumn: false,

                ),

                  /*...List.generate(model.Course.length, (index) {
                    var element = model.Course[index];
                    return TableRow(
                          children: [
                            TableCell(child: Center(child: Text('${element.DISC_NAME}'))),
                            TableCell(child: Center(child: Text('${element.FIO}'))),
                            TableCell(child: Center(child: Text('${element.DISC_MARK}'))),
                          ],
                    );
                  }),*/

                        /*IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PRSView()),
                            );
                          },
                          icon: const Icon(Icons.saved_search))*/
                    )),
                  ),
        ],
  );
}

