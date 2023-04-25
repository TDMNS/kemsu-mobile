import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets.dart';
import 'ordering_information_new_certificates_viewmodel.dart';

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
