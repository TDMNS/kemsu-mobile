import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:kemsu_app/UI/views/ordering_information/ordering_information_model.dart';
import 'package:kemsu_app/UI/views/ordering_information/ordering_information_subview/ordering_information_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../../../Configurations/localizable.dart';
import '../../../widgets.dart';
import '../../rating_of_students/ros_model.dart';
import '../ordering_information_main/ordering_information_main_view.dart';

class OrderingInformationView extends StatefulWidget {
  const OrderingInformationView({Key? key}) : super(key: key);

  @override
  State<OrderingInformationView> createState() => _OrderingInformationViewState();
}

class _OrderingInformationViewState extends State<OrderingInformationView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderingInformationViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => OrderingInformationViewModel(context),
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
                  appBar: customAppBar(context, model, Localizable.orderingInformationTitle),
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
              child: DropdownButton<StudyCard>(
                dropdownColor: Theme.of(context).primaryColor,
                itemHeight: 70.0,
                hint: Text(
                  Localizable.orderingInformationMainChooseStudyCard,
                ),
                onChanged: (value) {
                  model.changeCard(value);
                },
                isExpanded: true,
                value: model.studyCard,
                items: model.receivedStudyCard.map<DropdownMenuItem<StudyCard>>((e) {
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
                      dropdownColor: Theme.of(context).primaryColor,
                      itemHeight: 70.0,
                      hint: Text(
                        Localizable.orderingInformationMainStudyBasis,
                      ),
                      onChanged: (value) {
                        model.changeBasic(value);
                      },
                      isExpanded: true,
                      value: model.selectedBasic,
                      items: model.receivedBasicList.map<DropdownMenuItem<BasisOfEducation>>((e) {
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
                      dropdownColor: Theme.of(context).primaryColor,
                      itemHeight: 70.0,
                      hint: Text(
                        Localizable.orderingInformationPeriod,
                      ),
                      onChanged: (value) {
                        model.changePeriod(value);
                      },
                      isExpanded: true,
                      value: model.selectedPeriod,
                      items: model.periodList.map<DropdownMenuItem<PeriodList>>((e) {
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
                        DateTime? newDate =
                            await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
                        model.startDate = newDate;
                        model.notifyListeners();
                      },
                      child: model.startDate == DateTime(0, 0, 0)
                          ? Text(Localizable.orderingInformationMainChooseStartDate)
                          : Text("${Localizable.orderingInformationMainStartDate} ${model.startDate?.day}.${model.startDate?.month}.${model.startDate?.year}"))),
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Localizable.orderingInformationMainAmountCerts,
                    fillColor: Colors.white,
                    //filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ))
          : const SizedBox.shrink(),
      const SizedBox(height: 20),
      model.isSelected == true && model.lastParagraph != model.selectedPeriod
          ? mainButton(context, onPressed: () {
              _orderInfo(context, model);
            }, title: Localizable.orderingInformationMainSendRequest, isPrimary: false)
          : const SizedBox.shrink(),
      model.startDate != DateTime(0, 0, 0) && model.selectedPeriod == model.lastParagraph
          ? Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate =
                            await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
                        model.endDate = newDate;
                        model.notifyListeners();
                      },
                      child: model.endDate == DateTime(0, 0, 0)
                          ? Text(Localizable.orderingInformationMainChooseEndDate)
                          : Text("${Localizable.orderingInformationMainEndDate} ${model.endDate?.day}.${model.endDate?.month}.${model.endDate?.year}"))),
            )
          : const SizedBox.shrink(),
      model.endDate != DateTime(0, 0, 0) && model.selectedPeriod == model.lastParagraph
          ? Center(
              child: Card(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: model.count,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Localizable.orderingInformationMainAmountCerts,
                    fillColor: Colors.white,
                    //filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ))
          : const SizedBox.shrink(),
      const SizedBox(height: 20),
      model.endDate != DateTime(0, 0, 0) && model.selectedPeriod == model.lastParagraph
          ? mainButton(context, onPressed: () {
              _orderInfo(context, model);
            }, title: Localizable.orderingInformationMainSendRequest, isPrimary: false)
          : const SizedBox.shrink()
    ],
  );
}

_orderInfo(context, OrderingInformationViewModel model) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(Localizable.orderingInformationMainRequestSuccessCreated),
      content: Text(Localizable.orderingInformationMainInfo),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            model.sendReferences();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderingInformationMainView()));
          },
          child: Text(Localizable.ok),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
        ),
      ],
    ),
  );
}
