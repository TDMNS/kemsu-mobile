import 'package:flutter/material.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Configurations/localizable.dart';
import '../../common_widgets.dart';

class PaymentWebView extends StatefulWidget {
  // String fio = model.fio;
  // String phone = model.userType == EnumUserType.student ? model.phone.replaceFirst('+7', '') : model.phone.replaceFirst('+7 ', '');
  // String email = model.email;
  // bool isLoading = true;
  // final String fio;
  // final String phone;
  // final String email;
  final AbstractAuthRepository authRepository;

  const PaymentWebView({super.key, required this.authRepository});
  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late WebViewController webViewController;
  bool isLoading = true;
  late String fio;
  late String phone;
  late String email;

  @override
  void initState() {
    fio = widget.authRepository.userData.value.requiredContent.userInfo?.fullName ?? '';
    phone = widget.authRepository.userData.value.requiredContent.userInfo?.phone ?? '';
    email = widget.authRepository.userData.value.requiredContent.userInfo?.email ?? '';

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://kemsu.ru/payment/?student_fio=$fio&payer_fio=$fio&phone=$phone&email=$email'.replaceAll(' ', '+')))
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (finish) {
          setState(() {
            isLoading = false;
          });
        }),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: customAppBar(context, Localizable.paymentTitle),
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Stack(children: [
            WebViewWidget(controller: webViewController),
            if (isLoading) const Center(child: CircularProgressIndicator(color: Colors.blue)),
          ]);
        },
      ),
    );
  }
}

// paymentWebView(BuildContext context, ProfileViewModel model) {
//   String fio = model.fio;
//   String phone = model.userType == EnumUserType.student ? model.phone.replaceFirst('+7', '') : model.phone.replaceFirst('+7 ', '');
//   String email = model.email;
//   bool isLoading = true;
//   return Scaffold(
//     extendBody: false,
//     extendBodyBehindAppBar: false,
//     appBar: customAppBar(context, Localizable.paymentTitle),
//     body: StatefulBuilder(
//       builder: (BuildContext context, StateSetter setState) {
//         return Stack(children: [
//           WebView(
//               initialUrl: Uri.encodeFull('https://kemsu.ru/payment/?student_fio=$fio&payer_fio=$fio&phone=$phone&email=$email'.replaceAll(' ', '+')),
//               javascriptMode: JavascriptMode.unrestricted,
//               onPageFinished: (finish) {
//                 setState(() {
//                   isLoading = false;
//                 });
//               }),
//           isLoading
//               ? const Center(
//                   child: CircularProgressIndicator(color: Colors.blue),
//                 )
//               : const Stack(),
//         ]);
//       },
//     ),
//   );
// }
