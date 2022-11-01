import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/pgas/new_achieve_pgas_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pgas_detail_viewmodel.dart';

class PgasDetailScreenRoute extends MaterialPageRoute {
  PgasDetailScreenRoute()
      : super(builder: (context) => const PgasDetailScreen());
}

class PgasDetailScreen extends StatelessWidget {
  const PgasDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasDetailViewModel>.reactive(
        viewModelBuilder: () => PgasDetailViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }
}

_appBar(context, PgasDetailViewModel model) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_outlined),
      color: Colors.black,
      onPressed: () {
        model.goToPgasRequestList(context);
      },
      iconSize: 32,
    ),
    elevation: 0,
    actions: [
      IconButton(
          onPressed: () {
            model.goToPgasRequestInfoScreen(context);
          },
          icon: _gradientIcon(
              Icons.more_horiz, const Color(0xFF00C2FF), Colors.blueAccent))
    ],
    backgroundColor: Colors.transparent,
  );
}

_body(context, PgasDetailViewModel model) {
  return ListView(
    physics:
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    children: [
      const SizedBox(
        height: 34,
      ),
      _createAchieveButton(context, model),
      const SizedBox(
        height: 34,
      ),
      _pgasAchieveTitle(),
      _pgasAchievesSpace(context, model)
    ],
  );
}

_pgasAchieveTitle() {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Text(
          "Прикрепленные достижения",
          style: TextStyle(
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5B5B7E)),
        ),
      ],
    ),
  );
}

_gradientIcon(IconData icon, Color firstColor, Color secondColor) {
  return ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [firstColor, secondColor],
    ).createShader(bounds),
    child: Icon(
      icon,
      size: 32,
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
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 6),
                spreadRadius: 1,
                blurRadius: 7)
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
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewAchievePgasScreen()))
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
          ? const Center(
              child: Text("Нет прикрепленных достижений.",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                      fontWeight: FontWeight.w500)))
          : ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.userAchievesList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                      model.userAchievesList[index].activityName.toString()),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(text: 'Ваше описание: '),
                                TextSpan(
                                    text: model
                                        .userAchievesList[index].activityName
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Полное название достижения: '),
                                TextSpan(
                                    text: model.userAchievesList[index]
                                        .fullActivityName
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(text: 'Тип достижения: '),
                                TextSpan(
                                    text: model
                                        .userAchievesList[index].activityType
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Год получения достижения: '),
                                TextSpan(
                                    text: model
                                        .userAchievesList[index].activityYear
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Месяц получения достижения: '),
                                TextSpan(
                                    text: model
                                        .userAchievesList[index].activityMonth
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Подтверждение достижения: '),
                                TextSpan(
                                  text: model
                                      .userAchievesList[index].activitySrc
                                      .toString(),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(Uri.parse(model
                                          .userAchievesList[index].activitySrc
                                          .toString()));
                                    },
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(text: 'Баллы за достижение: '),
                                TextSpan(
                                    text: model
                                        .userAchievesList[index].activityBall
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(text: 'Достижение утверждено: '),
                                TextSpan(
                                    text: model.userAchievesList[index]
                                                .approveFlag ==
                                            0
                                        ? "Нет"
                                        : "Да",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Достижение является групповым: '),
                                TextSpan(
                                    text: model.userAchievesList[index]
                                                .groupActivityFlag ==
                                            0
                                        ? "Нет"
                                        : "Да",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Комментарий администрации: '),
                                TextSpan(
                                    text:
                                        model.userAchievesList[index].comment ??
                                            "",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 22),
                              child: Container(
                                  width: 200,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0, 6),
                                          spreadRadius: 1,
                                          blurRadius: 7)
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.deepOrangeAccent,
                                        Colors.red
                                      ],
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      await model.deleteBtnAction(context,
                                          model.userAchievesList[index]);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
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
