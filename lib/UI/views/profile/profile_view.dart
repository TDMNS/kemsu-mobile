import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/auth/auth_viewmodel.dart';
import 'package:kemsu_app/UI/views/profile/profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => ProfileViewModel(context),
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
                  appBar: customAppBar(context, model, 'Профиль'),
                  bottomNavigationBar: customBottomBar(context, model),
                  body: _profileView(context, model),
                ),
              ));
        });
  }
}

_profileView(BuildContext context, ProfileViewModel model) {
  return Stack(
    children: [
      ListView(children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 40))
          ]),
          child: Card(
            margin: const EdgeInsets.only(left: 20, right: 20),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(15),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: NetworkImage(
                                  'https://www.ixbt.com/img/n1/news/2021/1/0/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F_2.png'),
                              fit: BoxFit.cover),
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model.lastName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${model.firstName} ${model.middleName}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(text: 'Группа: '),
                                TextSpan(
                                    text: model.group,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(text: 'Телефон: '),
                                TextSpan(
                                    text: model.phone,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 30, right: 20),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 15))
                ]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                expandedAlignment: Alignment.center,
                title: const Text(
                  'Данные студента',
                  style: TextStyle(
                      fontFamily: "Ubuntu",
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(text: 'Группа: '),
                              TextSpan(
                                  text: model.group,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(text: 'Направление: '),
                              TextSpan(
                                  text: model.speciality,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(text: 'Форма обучения: '),
                              TextSpan(
                                  text: model.learnForm,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(text: 'Форма финансирования: '),
                              TextSpan(
                                  text: model.finForm,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(text: 'Email: '),
                              TextSpan(
                                  text: model.email,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(text: 'Телефон: '),
                              TextSpan(
                                  text: model.phone,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 15))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/icons/Search.png',
                        scale: 4,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'БРС',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 30),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 15))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/icons/Invoice.png',
                        scale: 4,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ПГАС',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 15))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/icons/Book.png',
                        scale: 4,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ИнфОУПро',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            model.exitButton(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 100, right: 100, top: 20),
            height: 50,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 15))
            ]),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                  child: Text(
                'Выйти',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
            ),
          ),
        )
      ]),
      //const LoadingScreen()
    ],
  );
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _controller!.forward();
    super.initState();

    Timer _timer = Timer(const Duration(seconds: 3), () => {});
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  AnimationController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 20),
              )
            ]),
            child: Card(
              margin: const EdgeInsets.only(left: 50, right: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Ожидайте.',
                      style: TextStyle(
                          color: Color.fromRGBO(91, 91, 126, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 40),
                    child: Text(
                      'Ваши данные находятся на проверке.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(91, 91, 126, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  Image.asset('images/icons/loader.gif', height: 50, width: 50),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
