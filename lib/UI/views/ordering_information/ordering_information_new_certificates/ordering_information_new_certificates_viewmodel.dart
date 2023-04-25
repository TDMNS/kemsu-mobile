import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class OrderingInformationNewCertificatesViewModel extends BaseViewModel {
  OrderingInformationNewCertificatesViewModel(BuildContext context);

  Future onReady() async {
    await sendCallCertificates();
  }

  sendCallCertificates() async {
    notifyListeners();
  }
}
