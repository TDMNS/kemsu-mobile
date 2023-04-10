import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ordering information/ordering_information_main_view.dart';
import './info_viewmodel.dart';
import './info_task_block_view.dart';
import './info_model.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class InfoOUProRepView extends StatelessWidget {
  const InfoOUProRepView({Key? key, required this.discData, required this.repList}) : super(key: key);
  final CourseInfoOUPro discData;
  final List<ReportInfoOUPro> repList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InfoOUProViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => InfoOUProViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, model, discData.discName),
              body: _infoOUProRepView(context, model, repList, discData),
            ),
          );
        });
  }
}

_infoOUProRepView(BuildContext context, InfoOUProViewModel model, repList, discData) {
  return ListView(children: <Widget>[
    Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
      child: Center(
          child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              richText("Дисциплина: ", discData.discName, context),
              const SizedBox(height: 10),
              richText("Отчётность", discData.discRep, context),
              const SizedBox(height: 10),
              richText("Часы: ", discData.discHours.toString(), context),
              const SizedBox(height: 10),
              richText("Период проведения: ", discData.discFirstDate + " - " + discData.discLastDate, context),
              const SizedBox(height: 10),
              richText("Преподаватель: ", discData.fio, context),
              const SizedBox(height: 10),
              richText("Количество баллов: ", discData.discMark.toString(), context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      )),
    ),
    const SizedBox(height: 20),
    Padding(padding: const EdgeInsets.only(left: 5.0, right: 5.0), child: _getDiscView(repList)),
  ]);
}

Widget _getDiscView(repList) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: repList.length,
    itemBuilder: (context, index) {
      final item = repList[index];
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
                          Text(item.name,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: "Ubuntu",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          richText("Контрольная дата: ", "${item.repControlDate}", context),
                          const SizedBox(height: 10),
                          richText("Максимальный балл: ", "${item.maxBall}", context),
                          const SizedBox(height: 10),
                          richText("Результат: ", "${item.sumBall}", context),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InfoOUProTaskBlockView(
                                            repData: item.studentTaskList,
                                            blockName: item.name,
                                          )),
                                );
                              },
                              child: const Text("Подробнее", style: TextStyle(color: Colors.white)))
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
