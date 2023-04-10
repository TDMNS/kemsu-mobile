import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/rating_of_students/views/ros_detail_item_view.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:stacked/stacked.dart';
import '../../../widgets.dart';
import '../../ordering information/ordering_information_main_view.dart';
import '../ros_viewmodel.dart';

class RosDetailView extends StatelessWidget {
  const RosDetailView({Key? key, required this.reitList, required this.semester}) : super(key: key);

  final int semester;
  final List<ReitList> reitList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RosViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => RosViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  appBar: customAppBar(context, model, 'Семестр $semester'),
                  body: _rosDetailView(context, model, reitList),
                ),
              ));
        });
  }
}

_rosDetailView(context, RosViewModel model, reitList) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 10),
      Padding(padding: const EdgeInsets.all(8.0), child: getListView(model, reitList))
    ],
  );
}

Widget getListView(RosViewModel model, reitList) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: reitList.length,
    itemBuilder: (context, index) {
      final item = reitList[index];
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
                          Text(
                            "${item.discipline}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontFamily: "Ubuntu",
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          richText("Форма промежуточной аттестации: ", "${item.intermediateAttestationForm}", context),
                          const SizedBox(height: 10),
                          richText("Текущий балл: ", "${item.currentScore}", context),
                          const SizedBox(height: 10),
                          richText("Аттестационный балл: ", "${item.frontScore}", context),
                          const SizedBox(height: 10),
                          richText("Общий балл: ", "${item.commonScore}", context),
                          const SizedBox(height: 10),
                          richText("Оценка: ", item.mark != null ? "${item.mark}" : "нет оценки", context),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                              onPressed: () async {
                                await model.getReitItemList(item.studyId);
                                String safelyDiscipline = item.discipline ?? "";
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RosDetailItemView(
                                          reitItemList: model.reitItemList, discipline: safelyDiscipline)),
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
