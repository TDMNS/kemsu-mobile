import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/iais/iais_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

final loginController = TextEditingController();
final passwordController = TextEditingController();

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
          ));
        });
  }
}

_iaisView(BuildContext context, IaisViewModel model) {
  return Table(
    defaultColumnWidth: FixedColumnWidth(120.0),
    border: TableBorder.all(
        color: Colors.black,
        style: BorderStyle.solid,
        width: 2),
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
  );
}

