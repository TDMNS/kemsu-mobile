import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Configurations/localizable.dart';
import '../../widgets.dart';
import '../profile/profile_view_model.dart';

moodleWebView(BuildContext context, ProfileViewModel model) {
  bool isLoading = true;
  return Scaffold(
    extendBody: false,
    extendBodyBehindAppBar: false,
    appBar: customAppBar(context, Localizable.mainMoodle),
    body: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Stack(children: [
          WebView(
              initialUrl: Uri.encodeFull('http://open.kemsu.ru/'),
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