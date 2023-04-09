import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:stacked/stacked.dart';
import '../../widgets.dart';
import 'ros_viewmodel.dart';

class RosDetailItemView extends StatelessWidget {
  const RosDetailItemView({Key? key, required this.reitItemList, required this.discipline}) : super(key: key);

  final String discipline;
  final List<ReitItemList> reitItemList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RosViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => RosViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark), //прозрачность statusbar и установка тёмных иконок
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context); //расфокус textfield при нажатии на экран
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  appBar: customAppBar(context, model, discipline),
                  //bottomNavigationBar: customBottomBar(context, model),
                  body: _rosDetailItemView(context, model, reitItemList),
                ),
              ));
        });
  }
}

_rosDetailItemView(context, RosViewModel model, reitItemList) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            border: TableBorder.all(
              color: Theme.of(context).canvasColor,
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            defaultColumnWidth: const FlexColumnWidth(),
            children: [
              const TableRow(
                children: [
                  Text(
                    'Вид учебной деятельности',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Количество',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Макс. балл',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Ваш балл',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              ...List.generate(reitItemList.length, (index) {
                var element = reitItemList[index];
                return TableRow(
                  children: [
                    Text(
                      element.comment != null
                          ? "${element.activityName} (${element.comment})"
                          : "${element.activityName}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${element.count}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${element.maxBall}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${element.ball}",
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
