import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import 'prs_viewmodel.dart';

class PRSView extends StatelessWidget {
  const PRSView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PRSViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => PRSViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness
                      .dark), //прозрачность statusbar и установка тёмных иконок
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(
                      context); //расфокус textfield при нажатии на экран
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  appBar: customAppBar(context, model, 'БРС'),
                  bottomNavigationBar: customBottomBar(context, model),
                  body: _prsView(context, model),
                ),
              ));
        });
  }
}

_prsView(context, PRSViewModel model) {
  return ListView.builder(
      padding:
          const EdgeInsets.only(left: 20, right: 20, top: 150, bottom: 100),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(10),
          height: 150,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 15)),
              ]),
          child: Stack(),
        );
      });
}
