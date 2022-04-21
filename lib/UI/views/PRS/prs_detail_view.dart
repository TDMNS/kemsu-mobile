import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import '../schedule/schedule_model.dart';
import '../schedule/schedule_view.dart';
import 'prs_viewmodel.dart';

class PRSDetailView extends StatelessWidget {
  const PRSDetailView(
      {Key? key, required this.reitList, required this.semester})
      : super(key: key);

  final int semester;
  final List<ReitList> reitList;

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
                  appBar: customAppBar(context, model, 'Семестр $semester'),
                  bottomNavigationBar: customBottomBar(context, model),
                  body: _prsDetailView(context, model, reitList),
                ),
              ));
        });
  }
}

_prsDetailView(context, PRSViewModel model, reitList) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            defaultColumnWidth: const FlexColumnWidth(),
            children: [
              const TableRow(
                children: [
                  Text(
                    'Дисциплина',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Форма промежуточной аттестации',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Текущий балл',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Аттестационный балл',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Общий балл',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Оценка',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              ...List.generate(reitList.length, (index) {
                var element = reitList[index];
                return TableRow(
                  children: [
                    Text(
                      "${element.discipline}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${element.intermediateAttestationForm}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${element.currentScore}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${element.frontScore}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${element.commonScore}",
                      textAlign: TextAlign.center,
                    ), //Extracting from Map element the value
                    Text(
                      "${element.mark}",
                      textAlign: TextAlign.center,
                    )
                  ],
                );
              }),
            ],
          ))
    ],
  );
}
