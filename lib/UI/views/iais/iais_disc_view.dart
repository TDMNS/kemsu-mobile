import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ordering information/ordering_information_main_view.dart';
import './iais_viewmodel.dart';
import './iais_taskblock_view.dart';
import './iais_model.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class IaisRepView extends StatelessWidget {
  const IaisRepView({Key? key, required this.discData, required this.repList}) : super(key: key);
  final CourseIais discData;
  final List<ReportIais> repList;

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
              appBar: customAppBar(context, model, discData.DISC_NAME),
              //bottomNavigationBar: customBottomBar(context, model),
              body: _iaisRepView(context, model, repList, discData),
            ),
          );
        });
  }
}

_iaisRepView(BuildContext context, IaisViewModel model, repList, discData) {
  return ListView(children: <Widget>[
    const SizedBox(height: 12),
    Center(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),
                children: <TextSpan>[
                  const TextSpan(text: 'Дисциплина: '),
                  TextSpan(
                      text: discData.DISC_NAME,
                      style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),
                children: <TextSpan>[
                  const TextSpan(text: 'Отчётность: '),
                  TextSpan(
                      text: discData.DISC_REP,
                      style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),
                children: <TextSpan>[
                  const TextSpan(text: 'Часы: '),
                  TextSpan(
                      text: discData.DISC_HOURS.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),
                children: <TextSpan>[
                  const TextSpan(text: 'Период проведения: '),
                  TextSpan(
                      text: discData.DISC_FIRST_DATE + " - " + discData.DISC_LAST_DATE,
                      style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),
                children: <TextSpan>[
                  const TextSpan(text: 'Преподаватель: '),
                  TextSpan(
                      text: discData.FIO,
                      style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),
                children: <TextSpan>[
                  const TextSpan(text: 'Количество баллов: '),
                  TextSpan(
                      text: discData.DISC_MARK.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    )),
    const SizedBox(height: 20),
    Padding(padding: const EdgeInsets.only(left: 5.0, right: 5.0), child: getDiscView(repList)),
  ]);
}

Widget getDiscView(repList) {
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
                          Text(item.NAME,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: "Ubuntu",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          richText("Контрольная дата: ", "${item.REP_CONTROL_DATE}", context),
                          const SizedBox(height: 10),
                          richText("Максимальный балл: ", "${item.MAX_BALL}", context),
                          const SizedBox(height: 10),
                          richText("Результат: ", "${item.SUM_BALL}", context),
                          TextButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IaisTaskBlockView(
                                            repData: item.STUDENT_TASK_LIST,
                                            blockName: item.NAME,
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
