import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import 'news_viewmodel.dart';

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => NewsViewModel(context),
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
                  appBar: customAppBar(context, model, 'Новости'),
                  //bottomNavigationBar: customBottomBar(context, model),
                  body: _newsView(context, model),
                ),
              ));
        });
  }
}

_newsView(context, NewsViewModel model) {
  return ListView(
    children: [
      // GestureDetector(
      //   onTap: () {
      //     model.messageService();
      //   },
      //   child: Container(
      //     margin: EdgeInsets.only(left: 50, right: 50, top: 50),
      //     height: 30,
      //     width: 30,
      //     color: Colors.amber,
      //   ),
      // ),
      ListView.builder(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 100),
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: model.textList.length,
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(10),
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).primaryColorLight,
                        blurRadius: 15,
                        offset: const Offset(0, 15)),
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      model.testMessage(index);
                    },
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        model.newsIcons[index],
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    model.textList[index],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                  ))
                ],
              ),
            );
          }),
    ],
  );
}

_currentNewsView(BuildContext context, NewsViewModel model) {
  return Container(
    margin: EdgeInsets.only(top: 100, left: 50, right: 50),
    height: 500,
    width: 500,
    color: Colors.grey,
    child: ListView(
      children: <Widget>[Center(child: Text(model.textList[0]))],
    ),
  );
}
