import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ordering information/ordering_information_main_view.dart';
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
                statusBarIconBrightness: Brightness.dark), //прозрачность statusbar и установка тёмных иконок
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
  return ListView(shrinkWrap: true, physics: const ScrollPhysics(), children: <Widget>[
    const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.only(left: 5, right: 5), child: getTaskBlockView(repData))
  ]);
}

Widget getTaskBlockView(repData) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: repData.length,
    itemBuilder: (context, index) {
      final item = repData[index];
      return Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 10, bottom: 15, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColorLight,
                      blurRadius: 15,
                      offset: const Offset(0, 15),
                      spreadRadius: -15)
                ]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.NAME,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: "Ubuntu",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          richText("Решение: ", "${item.SOLVE_FLAG}", context),
                          const SizedBox(height: 10),
                          richText("Контрольная дата: ", "${item.TASK_CONTROL_DATE}", context),
                          const SizedBox(height: 10),
                          richText("Максимальный балл: ", "${item.MAX_BALL}", context),
                          const SizedBox(height: 10),
                          richText("Результат: ", "${item.SUM_BALL}", context),
                          const SizedBox(height: 10),
                          richText("Состояние: ", "${item.SOLUTION_STATUS}", context)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
