import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets.dart';
import '../ordering_information_main/ordering_information_main_view.dart';
import 'ordering_information_new_certificates_view_model.dart';

class OrderingInformationNewCertificatesView extends StatefulWidget {
  const OrderingInformationNewCertificatesView({Key? key}) : super(key: key);

  @override
  State<OrderingInformationNewCertificatesView> createState() => _OrderingInformationMainViewState();
}

class _OrderingInformationMainViewState extends State<OrderingInformationNewCertificatesView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderingInformationNewCertificatesViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => OrderingInformationNewCertificatesViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
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
                    appBar: customAppBar(context, model, 'Заказ справок'),
                    body: _orderingInformationView(context, model)),
              ));
        });
  }
}

_orderingInformationView(BuildContext context, OrderingInformationNewCertificatesViewModel model) {
  return ListView(
    padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width / 12,
        right: MediaQuery.of(context).size.width / 12,
        top: MediaQuery.of(context).size.height / 6),
    children: [
      Text(
        'Справка-вызов',
        style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 20,
      ),
      Text('Полное наименование организации-работодателя/ фамилия, имя, отчество работодателя - физического лица:',
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
          )),
      TextField(
        controller: model.companyName,
        decoration:
            const InputDecoration(hintText: 'ФГБОУ ВО "КемГУ" или ИП Иванов И. И.', hintStyle: TextStyle(fontSize: 14)),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 16,
      ),
      Text('Полное Ф.И.О. обучающегося в дательном падеже:',
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
          )),
      TextField(
        controller: model.studentName,
        decoration: const InputDecoration(hintText: 'Иванову Ивану Ивановичу', hintStyle: TextStyle(fontSize: 14)),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 16,
      ),
      GestureDetector(
        onTap: () {
          model.companyName.text.isEmpty || model.studentName.text.isEmpty ? null : model.sendCallCertificates(context);
          _downloadFinish(context);
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 16,
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 3.5,
            right: MediaQuery.of(context).size.width / 3.5,
          ),
          decoration: BoxDecoration(
              color: model.companyName.text.isEmpty || model.studentName.text.isEmpty ? Colors.grey : Colors.blue,
              borderRadius: BorderRadius.circular(10)),
          child: const Center(
            child: Text(
              'Скачать',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
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
      title: const Text('Загрузка завершена'),
      content: const Text('Справка-вызов была сохранена в загрузках устройства'),
      actions: <Widget>[
        TextButton(
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderingInformationMainView())),
          child: const Text('OK'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
        ),
      ],
    ),
  );
}
