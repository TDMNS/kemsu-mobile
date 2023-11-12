import 'package:flutter/material.dart';

import 'package:kemsu_app/UI/views/pgas/new_achieve_pgas/new_achieve_pgas_screen.dart';
import 'package:kemsu_app/UI/views/pgas/pgas_detail/pgas_detail_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets.dart';
import '../../ordering_information/ordering_information_main/ordering_information_main_view.dart';

class PgasDetailScreenRoute extends MaterialPageRoute {
  PgasDetailScreenRoute() : super(builder: (context) => const PgasDetailScreen());
}

class PgasDetailScreen extends StatelessWidget {
  const PgasDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasDetailViewModel>.reactive(
        viewModelBuilder: () => PgasDetailViewModel(context),
        onViewModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: customAppBar(context, "Достижения"),
            body: model.circle
                ? Container(
              color: Theme.of(context).primaryColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: Colors.white,
                ),
              ),
            )
                : _body(context, model),
          );
        });
  }
}

_body(context, PgasDetailViewModel model) {
  return ListView(
    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    children: [
      const SizedBox(
        height: 34,
      ),
      _createAchieveButton(context, model),
      const SizedBox(
        height: 34,
      ),
      _pgasAchieveTitle(context),
      _pgasAchievesSpace(context, model)
    ],
  );
}

_pgasAchieveTitle(context) {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: Text(
      "Прикрепленные достижения",
      style: TextStyle(
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).focusColor),
      textAlign: TextAlign.center,
      softWrap: true,
    ),
  );
}

_createAchieveButton(context, PgasDetailViewModel model) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
    child: Container(
        width: double.maxFinite,
        height: 46,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColorLight, offset: const Offset(0, 6), spreadRadius: -1, blurRadius: 5)
          ],
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00C2FF), Colors.blueAccent],
          ),
        ),
        child: TextButton(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NewAchievePgasScreen()))
                .then((value) => model.onGoBack(context));
          },
          child: const Text(
            "Прикрепить достижение",
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )),
  );
}

_pgasAchievesSpace(context, PgasDetailViewModel model) {
  return Padding(
      padding: const EdgeInsets.all(8),
      child: model.userAchievesList.isEmpty
          ? Center(
              child: Text("Нет прикрепленных достижений.",
                  style: TextStyle(fontSize: 12, color: Theme.of(context).focusColor, fontWeight: FontWeight.w500)))
          : ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.userAchievesList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    model.userAchievesList[index].activityName.toString(),
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          richText('Ваше описание: ', '${model.userAchievesList[index].activityName}', context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText('Полное название достижения: ', '${model.userAchievesList[index].fullActivityName}',
                              context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText('Тип достижения: ', '${model.userAchievesList[index].activityType}', context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText(
                              'Год получения достижения: ', '${model.userAchievesList[index].activityYear}', context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText('Месяц получения достижения: ', '${model.userAchievesList[index].activityMonth}',
                              context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText(
                              'Подтверждение достижения: ', '${model.userAchievesList[index].activitySrc}', context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText('Баллы за достижение: ', '${model.userAchievesList[index].activityBall}', context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText('Достижение утверждено: ',
                              model.userAchievesList[index].approveFlag == 0 ? "Нет" : "Да", context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText('Достижение является групповым: ',
                              model.userAchievesList[index].groupActivityFlag == 0 ? "Нет" : "Да", context),
                          const SizedBox(
                            height: 10,
                          ),
                          richText('Комментарий администрации: ', model.userAchievesList[index].comment ?? "", context),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
                              child: Container(
                                  width: 200,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context).primaryColorLight,
                                          offset: const Offset(0, 6),
                                          spreadRadius: -1,
                                          blurRadius: 5)
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.deepOrangeAccent, Colors.red],
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      await model.deleteBtnAction(context, model.userAchievesList[index]);
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Удалить достижение",
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }));
}
