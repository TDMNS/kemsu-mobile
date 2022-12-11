import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_model.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import '../PRS/prs_model.dart';
import 'ordering_information_main_view.dart';
import 'ordering_information_main_viewmodel.dart';

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
                  statusBarIconBrightness: Brightness.dark),
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
                  body: _orderingInformationView(context, model),
                ),
              ));
        });
  }
}

_orderingInformationView(context, OrderingInformationViewModel model) {
  final textController = TextEditingController();
  return ListView(
    children: <Widget>[
      const SizedBox(height: 10),
      Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<StudyCard>(
                itemHeight: 70.0,
                hint: const Text(
                  '- Выбрать учебную карту -',
                  style: TextStyle(color: Colors.black),
                ),
                onChanged: (value) {
                  model.changeCard(value);
                },
                isExpanded: true,
                value: model.studyCard,
                items: model.receivedStudyCard
                    .map<DropdownMenuItem<StudyCard>>((e) {
                  return DropdownMenuItem<StudyCard>(
                    child: Text(e.speciality.toString()),
                    value: e,
                  );
                }).toList(),
              )),
        ),
      ),
      model.studyCard != null
          ? Center(
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
            )
          : const SizedBox.shrink(),
      model.selectedBasic != null
          ? Center(
              child: Card(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<PeriodList>(
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
                          .map<DropdownMenuItem<PeriodList>>((e) {
                        return DropdownMenuItem<PeriodList>(
                          child: Text(e.period.toString()),
                          value: e,
                        );
                      }).toList(),
                    )),
              ),
            )
          : const SizedBox.shrink(),
      model.lastParagraph == model.selectedPeriod && model.isSelected == true
          ? Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        model.startDate = newDate;
                        model.notifyListeners();
                      },
                      child: model.startDate == DateTime(0, 0, 0)
                          ? const Text("Выбрать начальную дату")
                          : Text(
                              "Начальная дата: ${model.startDate?.day}.${model.startDate?.month}.${model.startDate?.year}"))),
            )
          : const SizedBox.shrink(),
      model.isSelected == true && model.lastParagraph != model.selectedPeriod
          ? Center(
              child: Card(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: model.count,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Количество справок (по умолчанию 1)",
                    fillColor: Colors.white,
                    //filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ))
          : const SizedBox.shrink(),
      model.isSelected == true && model.lastParagraph != model.selectedPeriod
          ? Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      orderInfo(context, model);
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
                  )),
            )
          : const SizedBox.shrink(),
      model.startDate != DateTime(0, 0, 0) &&
              model.selectedPeriod == model.lastParagraph
          ? Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        model.endDate = newDate;
                        model.notifyListeners();
                      },
                      child: model.endDate == DateTime(0, 0, 0)
                          ? const Text("Выбрать конечную дату")
                          : Text(
                              "Конечная дата: ${model.endDate?.day}.${model.endDate?.month}.${model.endDate?.year}"))),
            )
          : const SizedBox.shrink(),
      model.endDate != DateTime(0, 0, 0) &&
              model.selectedPeriod == model.lastParagraph
          ? Center(
              child: Card(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: model.count,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Количество справок (по умолчанию 1)",
                    fillColor: Colors.white,
                    //filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ))
          : const SizedBox.shrink(),
      model.endDate != DateTime(0, 0, 0) &&
              model.selectedPeriod == model.lastParagraph
          ? Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      orderInfo(context, model);
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
                  )),
            )
          : const SizedBox.shrink(),
    ],
  );
}

orderInfo(context, OrderingInformationViewModel model) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Готово'),
      content: const Text('Справку можно забрать:'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            model.sendReferences();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderingInformationMainView()));
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
