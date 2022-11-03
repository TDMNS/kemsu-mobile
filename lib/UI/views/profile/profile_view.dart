import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kemsu_app/UI/views/PRS/prs_view.dart';
import 'package:kemsu_app/UI/views/debts/debts_view.dart';
import 'package:kemsu_app/UI/views/pgas/pgas_screen.dart';
import 'package:kemsu_app/UI/views/iais/iais_view.dart';
import 'package:kemsu_app/UI/views/checkList/checkList_view.dart';
import 'package:kemsu_app/UI/views/profile/profile_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets.dart';
import '../ordering information/ordering_information_view.dart';

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
                  appBar: customAppBar(context, model, 'Главная'),
                  // bottomNavigationBar: customBottomBar(context, model),
                  body: _profileView(context, model),
                ),
              ));
        });
  }

  avatarChoice(context, ProfileViewModel model) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Выбор фотографии'),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _getFromGallery(model);
                    Navigator.pop(context, 'OK');
                    model.saveImage(model.imageFile);
                  },
                  child: const Text(
                    'Галерея',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    _getFromCamera(model);
                    Navigator.pop(context, 'OK');
                    model.saveImage(model.imageFile);
                  },
                  child: const Text(
                    'Камера',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getFromGallery(ProfileViewModel model) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        model.imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera(ProfileViewModel model) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        model.imageFile = File(pickedFile.path);
      });
    }
  }

  _profileView(BuildContext context, ProfileViewModel model) {
    return Stack(
      children: [
        ListView(children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 15),
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
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          avatarChoice(context, model);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          width: 100,
                          height: 100,
                          child: model.imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    model.imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const SizedBox(),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15,
                            left: MediaQuery.of(context).size.width / 3,
                            bottom: 15),
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
                                  TextSpan(
                                      text:
                                          model.userType == EnumUserType.student
                                              ? 'Группа: '
                                              : 'Должность: \n'),
                                  model.userType == EnumUserType.student
                                      ? TextSpan(
                                          text: model.group,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))
                                      : TextSpan(
                                          //text: model.jobTitle,
                                          text:
                                              'adnfjsndjfnskdf llsd sdlfkns kldfn lksfdlk sndlf',
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
                  ),
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
                    'Данные пользователя',
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
                                TextSpan(
                                    text: model.userType == EnumUserType.student
                                        ? 'Группа: '
                                        : 'Должность: '),
                                model.userType == EnumUserType.student
                                    ? TextSpan(
                                        text: model.group,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                                    : TextSpan(
                                        text: model.jobTitle,
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
                                TextSpan(
                                    text: model.userType == EnumUserType.student
                                        ? 'Направление: '
                                        : 'Отдел: '),
                                model.userType == EnumUserType.student
                                    ? TextSpan(
                                        text: model.speciality,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                                    : TextSpan(
                                        text: model.department,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          model.userType == EnumUserType.student
                              ? const SizedBox(height: 10)
                              : const SizedBox.shrink(),
                          model.userType == EnumUserType.student
                              ? RichText(
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
                                )
                              : const SizedBox.shrink(),
                          model.userType == EnumUserType.student
                              ? const SizedBox(height: 10)
                              : const SizedBox.shrink(),
                          model.userType == EnumUserType.student
                              ? RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: 'Форма финансирования: '),
                                      TextSpan(
                                          text: model.finForm,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
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
                          model.userType == EnumUserType.student
                              ? const SizedBox(height: 10)
                              : const SizedBox.shrink(),
                          model.userType == EnumUserType.student &&
                                  model.finForm != "бюджетная"
                              ? RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: 'Задолженность за обучение: '),
                                      TextSpan(
                                          text: model.debtData,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.blue,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 9))
                                  ]),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PRSView()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 30),
                      height: 100,
                      width: 130,
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
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: const RouteSettings(name: "PgasList"),
                              builder: (context) => const PgasScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 30),
                      height: 100,
                      width: 130,
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
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const IaisView()));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 30),
                      height: 100,
                      width: 130,
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
                          const Center(
                            child: Text(
                              'ИнфОУПро',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DebtsView()));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 30),
                      height: 100,
                      width: 130,
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
                            'images/icons/Alert.png',
                            scale: 4,
                          ),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              'Долги',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const OrderingInformationView()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 30),
                    height: 100,
                    width: 130,
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
                          'images/icons/orderingInformation.png',
                          scale: 4,
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            'Заказ справок',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CheckListView()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 30),
                    height: 100,
                    width: 130,
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
                        const Center(
                          child: Text(
                            'Обходной лист',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              model.userType == EnumUserType.student
                  ? const SizedBox(height: 30)
                  : const SizedBox.shrink(),
              model.userType == EnumUserType.student
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          _paymentWebView(context, model)));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 30),
                              height: 100,
                              width: 130,
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
                                    'images/icons/money.png',
                                    scale: 4,
                                  ),
                                  const SizedBox(height: 10),
                                  const Center(
                                    child: Text(
                                      'Оплата услуг',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ])
                  : const SizedBox.shrink(),
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
          ),
        ]),

        //const LoadingScreen()
      ],
    );
  }
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
    if (_timer.isActive) {
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

_paymentWebView(BuildContext context, ProfileViewModel model) {
  return Scaffold(
    extendBody: false,
    extendBodyBehindAppBar: false,
    appBar: customAppBar(context, model, 'Оплата услуг'),
    body: WebView(
        initialUrl: Uri.encodeFull(
            'https://kemsu.ru/payment/?student_fio=${model.fio}&payer_fio=${model.fio}&phone=${model.phone?.replaceFirst('+7 ', '')}&email=${model.email}'
                .replaceAll(' ', '+'))),
  );
}
