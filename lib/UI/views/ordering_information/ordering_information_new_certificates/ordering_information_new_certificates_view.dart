import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../../../Configurations/localizable.dart';
import '../../../widgets.dart';
import 'ordering_information_new_certificates_view_model.dart';

class OrderingInformationNewCertificatesView extends StatefulWidget {
  const OrderingInformationNewCertificatesView({super.key});

  @override
  State<OrderingInformationNewCertificatesView> createState() => _OrderingInformationMainViewState();
}

class _OrderingInformationMainViewState extends State<OrderingInformationNewCertificatesView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderingInformationNewCertificatesViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => OrderingInformationNewCertificatesViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                    extendBody: true,
                    extendBodyBehindAppBar: true,
                    appBar: customAppBar(context, Localizable.orderingInformationTitle),
                    body: _orderingInformationView(context, model)),
              ));
        });
  }
}

_orderingInformationView(BuildContext context, OrderingInformationNewCertificatesViewModel model) {
  return ListView(
    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 12, right: MediaQuery.of(context).size.width / 12, top: MediaQuery.of(context).size.height / 6),
    children: [
      Text(
        Localizable.newCertName,
        style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 20,
      ),
      Text(Localizable.newCertBossName,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
          )),
      TextField(
        controller: model.companyName,
        decoration: InputDecoration(hintText: Localizable.newCertSignature, hintStyle: const TextStyle(fontSize: 14)),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 16,
      ),
      Text(Localizable.newCertStudentName,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
          )),
      TextField(
        controller: model.studentName,
        decoration: InputDecoration(hintText: Localizable.newCertPlaceholder, hintStyle: const TextStyle(fontSize: 14)),
        onChanged: (_) {
          model.notifyListeners();
        },
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 16,
      ),
      GestureDetector(
        onTap: () {
          model.companyName.text.isEmpty || model.studentName.text.isEmpty ? null : model.sendCallCertificates(context);
          if (model.studentName.text.isNotEmpty) {
            if (model.companyName.text.isEmpty) {
              model.companyName.text = 'ФГБОУ ВО "КемГУ"';
            }
            _downloadFinish(context);
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 16,
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 3.5,
            right: MediaQuery.of(context).size.width / 3.5,
          ),
          decoration: BoxDecoration(color: model.studentName.text.isEmpty ? Colors.grey : Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              Localizable.newCertDownload,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      )
    ],
  );
}

_downloadFinish(context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(Localizable.newCertLoaded),
      content: Text(Localizable.newCertSaveOnDeviceDescription),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).popUntil(ModalRoute.withName("/menu")),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          child: Text(Localizable.ok),
        ),
      ],
    ),
  );
}
