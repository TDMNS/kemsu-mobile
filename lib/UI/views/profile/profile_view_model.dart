import 'dart:convert';
import 'dart:io';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Configurations/config.dart';
import '../../../Configurations/localizable.dart';
import '../../widgets.dart';
import '../auth/auth_view.dart';
import '../bug_report/bug_report_view.dart';
import '../info/views/info_view.dart';
import '../debts/debts_view.dart';
import '../check_list/check_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import '../pgas/pgas_screen.dart';
import '../rating_of_students/views/ros_view.dart';

class EnumUserType {
  static String get student => "обучающийся";
  static String get employee => "сотрудник";
}

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(BuildContext context);

  bool circle = true;

  int selectedIndex = 1;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  final storage = const FlutterSecureStorage();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();

  String firstName = '';
  String lastName = '';
  String middleName = '';
  String email = '';
  String phone = '';
  String group = '';
  String speciality = '';
  String faculty = '';
  String course = '';
  String qualification = '';
  String learnForm = '';
  String statusSTR = '';
  String finForm = '';
  String startYear = '';
  String userType = '';
  int? userTypeInt;
  String jobTitle = '';
  String department = '';
  String fio = '';
  File? imageFile;
  String? img64;
  File? file;
  File? localImage;
  bool darkTheme = false;
  String? avatar;
  bool isExpanded = false;
  String imageUrl = '';
  String token = '';

  saveImage() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    final fileName = basename(imageFile!.path);
    await imageFile!.copy('$appDocPath/$fileName');
    file = File('$appDocPath/$fileName');
    await storage.write(key: "avatar", value: file!.path);

    notifyListeners();
  }

  changeTheme(value) {
    darkTheme = value;
    notifyListeners();
  }

  getThemeToMain() {
    notifyListeners();
    return darkTheme;
  }

  Future onReady(BuildContext context) async {
    await _prolongToken(context);
    await _checkFileExisting();
    await _getAuthRequest();
    _showNewYearGreetings(context);
    _showUpdate(context);
    appMetricaTest();
    circle = false;
    notifyListeners();
  }

  Future<void> _prolongToken(context) async {
    String? token = await storage.read(key: 'tokenKey');
    final responseToken = await http.post(Uri.parse(Config.proLongToken), body: {"accessToken": token});
    responseToken.statusCode == 401 ? Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthView())) : null;
    var newToken = json.decode(responseToken.body)['accessToken'];
    await storage.write(key: "tokenKey", value: newToken);
  }

  Future<void> _checkFileExisting() async {
    String? img = await storage.read(key: "avatar");
    file = img != null ? File(img) : null;

    bool fileExists = await file?.exists() ?? false;

    if (!fileExists) {
      file = null;
    }
  }

  Future<void> _getAuthRequest() async {
    String? token = await storage.read(key: "tokenKey");
    String? login = await storage.read(key: "login");
    String? password = await storage.read(key: "password");

    var dio = Dio();
    final responseProlongToken = await dio.post(Config.proLongToken, queryParameters: {"accessToken": token});
    token = responseProlongToken.data['accessToken'];
    await storage.write(key: "tokenKey", value: token);
    String? recordedToken = await storage.read(key: "tokenKey");
    var userData = await _getUserData(dio, login, password);

    if (userType == EnumUserType.student) {
      await _writeStudentData(userData, dio, recordedToken);
    } else if (userType == EnumUserType.employee) {
      await _writeEmployeeData(dio, recordedToken);
    }
    fio = ('$lastName $firstName $middleName');

    await storage.write(key: "fio", value: fio);
    await storage.write(key: "email", value: phone);
    await storage.write(key: "phone", value: phone);

    await _getUserImage(dio, recordedToken);
  }

  Future<dynamic> _getUserData(Dio dio, String? login, String? password) async {
    final responseAuth = await dio.post(Config.apiHost, data: {"login": login, "password": password});

    var userData = responseAuth.data['userInfo'];
    userType = userData["userType"];

    email = userData["email"] ?? '';
    phone = userData["phone"] ?? '';
    String emailTemp = email;
    String phoneTemp = phone;
    emailController?.text = emailTemp;
    phoneController?.text = phoneTemp;
    notifyListeners();
    return userData;
  }

  Future<void> _writeStudentData(userData, Dio dio, String? recordedToken) async {
    firstName = userData["firstName"] ?? '';
    lastName = userData["lastName"] ?? '';
    middleName = userData["middleName"] ?? '';
    final responseStudent = await dio.get(Config.studCardHost, queryParameters: {"accessToken": recordedToken});

    var studentCard = responseStudent.data.isNotEmpty ? responseStudent.data[0] : {};
    group = studentCard["GROUP_NAME"] ?? '';
    speciality = studentCard["SPECIALITY"] ?? '';
    faculty = studentCard["FACULTY"] ?? '';
    qualification = studentCard["QUALIFICATION"] ?? '';
    learnForm = studentCard["LEARN_FORM"] ?? '';
    statusSTR = studentCard["STATUS_STR"] ?? '';
    finForm = studentCard["FINFORM"] ?? '';

    await storage.write(key: "firstName", value: firstName);
    await storage.write(key: "lastName", value: lastName);
    await storage.write(key: "middleName", value: middleName);
    await storage.write(key: "group", value: group);
  }

  Future<void> _writeEmployeeData(Dio dio, String? recordedToken) async {
    final responseEmployee = await dio.get(Config.empCardHost, queryParameters: {"accessToken": recordedToken});

    var employeeCard = responseEmployee.data["empList"].isNotEmpty ? responseEmployee.data["empList"][0] : {};
    firstName = employeeCard["FIRST_NAME"] ?? '';
    lastName = employeeCard["LAST_NAME"] ?? '';
    middleName = employeeCard["MIDDLE_NAME"] ?? '';
    jobTitle = employeeCard["POST_NAME"] ?? '';
    department = employeeCard["DEP"] ?? '';

    await storage.write(key: "firstName", value: firstName);
    await storage.write(key: "lastName", value: lastName);
    await storage.write(key: "middleName", value: middleName);
    await storage.write(key: "jobTitle", value: jobTitle);
    await storage.write(key: "department", value: department);
  }

  Future<void> _showUpdate(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    final responseMobileAppVersion = await dio.post(Config.checkMobileAppVersion, queryParameters: {"accessToken": token}, data: {"clientVersion": packageInfo.version});
    var valueForShowUpdateAlert = responseMobileAppVersion.data['versionEqualFlag'];
    if (valueForShowUpdateAlert == 0) {
      String downloadLink = 'https://www.kemsu.ru/education/app-kemsu/';
      if (Platform.isIOS) {
        downloadLink = 'https://apps.apple.com/ru/app/%D0%BA%D0%B5%D0%BC%D0%B3%D1%83/id6444271769';
      }
      Uri url = Uri.parse(downloadLink);
      _showAlertDialog(context,
          title: Localizable.mainUpdateTitle,
          content: Localizable.mainUpdateContent,
          buttonTitle: Localizable.mainUpdateButtonTitle, action: () async {
        Navigator.pop(context);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      });
    }
  }

  Future<void> _getUserImage(Dio dio, String? recordedToken) async {
    final imageResponse = await dio.get(Config.userInfo, queryParameters: {"accessToken": recordedToken});
    if (imageResponse.data['success'] == true) {
      var imageUrl = imageResponse.data['userInfo']['PHOTO_URL'];
      final String fileName = '${const Uuid().v1()}.jpg';
      try {
        final Dio dio = Dio();
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        if (imageUrl != null) {
          final Response response = await dio.get(imageUrl, queryParameters: {"accessToken": recordedToken}, options: Options(responseType: ResponseType.bytes));
          file = File('$appDocPath/$fileName');
          await file?.writeAsBytes(response.data);
        } else {
          file = null;
        }
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  void _showNewYearGreetings(BuildContext context) {
    final now = DateTime.now();
    final newYearDate = DateTime(now.year, DateTime.january, 3).toString().split(' ');
    final currentDate = now.toString().split(' ');
    if (currentDate[0] == newYearDate[0]) {
      _showAlertDialog(context, title: Localizable.mainHappyNewYearTitle, content: Localizable.mainHappyNewYearBody, buttonTitle: Localizable.mainThanks, action: () {
        Navigator.pop(context);
      });
    }
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Main screen (profile) event');
  }

  void updateProfile() async {
    var dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    await dio.post(Config.updateEmail, queryParameters: {"accessToken": token}, data: {"email": emailController?.text});
    await dio.post(Config.updatePhone, queryParameters: {"accessToken": token}, data: {"phone": phoneController?.text});
    email = emailController!.text;
    phone = phoneController!.text;
    notifyListeners();
  }

  void exit(context) async {
    await storage.write(key: "tokenKey", value: "");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthView()));
    notifyListeners();
  }

  void navigateInfoView(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoOUProView()));
    notifyListeners();
  }

  void navigateDebtsView(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const DebtsView()));
    notifyListeners();
  }

  void navigateCheckListView(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckListView()));
    notifyListeners();
  }

  void navigateOrderingInformationMainView(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderingInformationMainView()));
    notifyListeners();
  }

  void navigateWebView(context, model) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => _paymentWebView(context, model)));
    notifyListeners();
  }

  void navigateMainBugReportScreen(context, model) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const MainBugReportScreen()));
    notifyListeners();
  }

  void navigateRosView(context, model) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RosView()));
    notifyListeners();
  }

  void navigatePgasScreen(context, model) {
    Navigator.push(context, MaterialPageRoute(settings: const RouteSettings(name: "PgasList"), builder: (context) => const PgasScreen()));
    notifyListeners();
  }

  void _showAlertDialog(BuildContext context, {required String title, required String content, required String buttonTitle, required Function() action}) {
    Widget okButton = TextButton(
      child: Text(buttonTitle),
      onPressed: () {
        action();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

/// Payment Web View
_paymentWebView(BuildContext context, ProfileViewModel model) {
  String fio = model.fio;
  String phone = model.userType == EnumUserType.student ? model.phone.replaceFirst('+7', '') : model.phone.replaceFirst('+7 ', '');
  String email = model.email;
  bool isLoading = true;
  return Scaffold(
    extendBody: false,
    extendBodyBehindAppBar: false,
    appBar: customAppBar(context, model, Localizable.paymentTitle),
    body: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Stack(children: [
          WebView(
              initialUrl: Uri.encodeFull('https://kemsu.ru/payment/?student_fio=$fio&payer_fio=$fio&phone=$phone&email=$email'.replaceAll(' ', '+')),
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              }),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                )
              : const Stack(),
        ]);
      },
    ),
  );
}
