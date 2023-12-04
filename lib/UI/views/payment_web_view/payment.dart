import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Configurations/localizable.dart';
import '../../common_widgets.dart';
import '../profile/profile_view_model.dart';

paymentWebView(BuildContext context, ProfileViewModel model) {
  String fio = model.fio;
  String phone = model.userType == EnumUserType.student ? model.phone.replaceFirst('+7', '') : model.phone.replaceFirst('+7 ', '');
  String email = model.email;
  bool isLoading = true;
  return Scaffold(
    extendBody: false,
    extendBodyBehindAppBar: false,
    appBar: customAppBar(context, Localizable.paymentTitle),
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