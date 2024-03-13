import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Configurations/localizable.dart';
import '../../common_widgets.dart';
import '../profile/profile_view_model.dart';

class MoodleWebView extends StatefulWidget {
  const MoodleWebView({super.key});

  @override
  State<MoodleWebView> createState() => _MoodleWebViewState();
}

class _MoodleWebViewState extends State<MoodleWebView> {
  late WebViewController webViewController;
  bool isLoading = true;

  @override
  void initState() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('http://open.kemsu.ru/'))
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
      appBar: customAppBar(context, Localizable.mainMoodle),
      body: Stack(
        children: [
          WebViewWidget(controller: webViewController),
          if (isLoading) const Center(child: CircularProgressIndicator(color: Colors.blue)),
        ],
      ),
    );
  }
}
