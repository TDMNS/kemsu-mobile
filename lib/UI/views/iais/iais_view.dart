import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './iais_viewmodel.dart';
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
      const SizedBox(height: 10),
        Center(
          child: Card(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  border: TableBorder.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 1.5),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: [
                        TableCell(child: Text('Дисциплина')),
                        TableCell(child: Text('Отчётность')),
                        TableCell(child: Text('Часы')),
                        TableCell(child: Text('Период проведения')),
                        TableCell(child: Text('Преподаватель')),
                        TableCell(child: Text('Количество баллов')),
                      ],
                    ),
                  ],
                ),
            ),
          ),
        ),
    ],
  );
}

