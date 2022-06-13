import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/API/config.dart';
import 'package:kemsu_app/UI/views/PRS/prs_detail_view.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_model.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import '../PRS/prs_viewmodel.dart';
import '../schedule/schedule_model.dart';
import '../schedule/schedule_view.dart';

class OrderingInformationView extends StatefulWidget {
  const OrderingInformationView({Key? key}) : super(key: key);

  @override
  State<OrderingInformationView> createState() =>
      _OrderingInformationViewState();
}

class _OrderingInformationViewState extends State<OrderingInformationView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderingInformationViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => OrderingInformationViewModel(context),
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
                  appBar: customAppBar(context, model, 'Заказ справок'),
                  bottomNavigationBar: customBottomBar(context, model),
                  body: _orderingInformationView(context, model),
                ),
              ));
        });
  }
}

_orderingInformationView(context, OrderingInformationViewModel model) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 10),
      Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<BasisOfEducation>(
                itemHeight: 70.0,
                hint: const Text(
                  '- Выбрать основу обучения -',
                  style: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  model.changeBasic(value);
                },
                isExpanded: true,
                value: model.selectedBasic,
                items: model.receivedBasicList
                    .map<DropdownMenuItem<BasisOfEducation>>((e) {
                  return DropdownMenuItem<BasisOfEducation>(
                    child: Text(e.basic.toString()),
                    value: e,
                  );
                }).toList(),
              )),
        ),
      ),
      model.selectedBasic != null
          ? Center(
              child: Card(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<PeriodListModel>(
                      itemHeight: 70.0,
                      hint: const Text(
                        '- Период за который требуется справка -',
                        style: TextStyle(color: Colors.black),
                      ),
                      onChanged: (value) {
                        model.changePeriod(value);
                      },
                      isExpanded: true,
                      value: model.selectedPeriod,
                      items: model.periodList
                          .map<DropdownMenuItem<PeriodListModel>>((e) {
                        return DropdownMenuItem<PeriodListModel>(
                          child: Text(e.period.toString()),
                          value: e,
                        );
                      }).toList(),
                    )),
              ),
            )
          : const SizedBox.shrink(),
      model.lastParagraph == model.selectedPeriod
          ? Center(
              child: Card(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            model.startDate = newDate;
                          },
                          child: model.startDate == DateTime(0, 0, 0)
                              ? const Text("Выбрать начальную дату")
                              : Text(
                                  "Начальная дата: ${model.startDate?.day}.${model.startDate?.month}.${model.startDate?.year}")))),
            )
          : const SizedBox.shrink(),
      model.startDate != DateTime(0, 0, 0)
          ? Center(
              child: Card(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            model.endDate = newDate;
                          },
                          child: model.endDate == DateTime(0, 0, 0)
                              ? const Text("Выбрать конечную дату")
                              : Text(
                                  "Конечная дата: ${model.endDate?.day}.${model.endDate?.month}.${model.endDate?.year}")))),
            )
          : const SizedBox.shrink(),
      model.endDate != DateTime(0, 0, 0)
          ? Center(
              child: Card(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 15))
                          ]),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Center(
                                child: Text(
                              'Подать заявку',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )),
                          ),
                        ),
                      ))),
            )
          : const SizedBox.shrink(),
    ],
  );
}