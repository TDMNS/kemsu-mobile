
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import 'pgas_request_info_screen.dart';

class PgasDetailViewModel extends BaseViewModel {
  PgasDetailViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();


  Future onReady() async {
  }

  goToPgasRequestInfoScreen(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PgasRequestInfoScreen()));
  }

  goToPgasRequestList(context) {
    Navigator.pop(context);
  }
}