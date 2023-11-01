import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:kemsu_app/UI/common_views/main_dropdown.dart';
import 'package:kemsu_app/UI/views/ordering_information/ordering_information_model.dart';
import 'package:stacked/stacked.dart';

import '../../../../Configurations/localizable.dart';
import '../../../widgets.dart';
import '../../rating_of_students/ros_model.dart';
import 'ordering_information_view_model.dart';

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
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
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
              appBar: customAppBar(
                context,
                Localizable.orderingInformationTitle,
              ),
              body: _orderingInformationView(context, model),
            ),
          ),
        );
      },
    );
  }
}

Widget _orderingInformationView(BuildContext context, OrderingInformationViewModel model) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 10),
      mainDropdown(
        context,
        value: model.studyCard,
        items: model.receivedStudyCard.map<DropdownMenuItem<StudyCard>>((e) {
          return DropdownMenuItem<StudyCard>(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e.groupName.toString()),
            ),
            value: e,
          );
        }).toList(),
        textHint: Localizable.orderingInformationMainChooseStudyCard,
        onChanged: (value) {
          model.changeCard(value);
        },
      ),
      const SizedBox(height: 10),
      if (model.studyCard != null)
        mainDropdown(
          context,
          value: model.selectedBasic,
          items: model.receivedBasicList.map<DropdownMenuItem<BasisOfEducation>>((e) {
            return DropdownMenuItem<BasisOfEducation>(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(e.basic.toString()),
              ),
              value: e,
            );
          }).toList(),
          textHint: Localizable.orderingInformationMainStudyBasis,
          onChanged: (value) {
            model.changeBasic(value);
          },
        )
      else
        const SizedBox.shrink(),
      const SizedBox(height: 10),
      if (model.selectedBasic != null)
        mainDropdown(
          context,
          value: model.selectedPeriod,
          items: model.periodList.map<DropdownMenuItem<PeriodList>>((e) {
            return DropdownMenuItem<PeriodList>(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(e.period.toString()),
              ),
              value: e,
            );
          }).toList(),
          textHint: Localizable.orderingInformationPeriod,
          onChanged: (value) {
            model.changePeriod(value);
            model.count.clear();
          },
        )
      else
        const SizedBox.shrink(),
      if (model.lastParagraph == model.selectedPeriod && model.isSelected == true)
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: mainButton(
              context,
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                model.startDate = newDate;
                model.notifyListeners();
              },
              title: model.startDate == DateTime(0, 0, 0) || model.startDate?.day == null
                  ? Localizable.orderingInformationMainChooseStartDate
                  : "${Localizable.orderingInformationMainStartDate} ${model.startDate?.day}.${model.startDate?.month}.${model.startDate?.year}",
              isPrimary: true,
            ),
          ),
        )
      else
        const SizedBox.shrink(),
      if (model.lastParagraph == model.selectedPeriod && model.isSelected == true) const SizedBox.shrink() else const SizedBox(height: 20),
      if (model.isSelected == true && model.lastParagraph != model.selectedPeriod && model.selectedPeriod != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: TextFormField(
            decoration: InputDecoration(
              filled: false,
              contentPadding: const EdgeInsets.only(left: 15, top: 15),
              hintText: Localizable.orderingInformationMainAmountCerts,
              hintStyle: const TextStyle(
                fontFamily: "Ubuntu",
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(
              fontFamily: "Ubuntu",
              fontWeight: FontWeight.bold,
            ),
            controller: model.count,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.none,
          ),
        )
      else
        const SizedBox.shrink(),
      const SizedBox(height: 20),
      if (model.isSelected == true && model.lastParagraph != model.selectedPeriod && model.selectedPeriod != null)
        mainButton(
          context,
          onPressed: () {
            _orderInfo(context, model);
          },
          title: Localizable.orderingInformationMainSendRequest,
          isPrimary: false,
        )
      else
        const SizedBox.shrink(),
      if (model.startDate != DateTime(0, 0, 0) && model.selectedPeriod == model.lastParagraph)
        mainButton(
          context,
          onPressed: () async {
            DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            model.endDate = newDate;
            model.notifyListeners();
          },
          title: model.endDate == DateTime(0, 0, 0) || model.endDate?.day == null
              ? Localizable.orderingInformationMainChooseEndDate
              : "${Localizable.orderingInformationMainEndDate} ${model.endDate?.day}.${model.endDate?.month}.${model.endDate?.year}",
          isPrimary: true,
        )
      else
        const SizedBox.shrink(),
      if (model.endDate != DateTime(0, 0, 0) && model.selectedPeriod == model.lastParagraph && model.startDate?.day != null && model.endDate?.day != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: TextFormField(
            decoration: InputDecoration(
              filled: false,
              contentPadding: const EdgeInsets.only(left: 15, top: 15),
              hintText: Localizable.orderingInformationMainAmountCerts,
              hintStyle: const TextStyle(
                fontFamily: "Ubuntu",
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(
              fontFamily: "Ubuntu",
              fontWeight: FontWeight.bold,
            ),
            controller: model.count,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.none,
          ),
        )
      else
        const SizedBox.shrink(),
      const SizedBox(height: 20),
      if (model.endDate != DateTime(0, 0, 0) && model.selectedPeriod == model.lastParagraph && model.startDate?.day != null && model.endDate?.day != null)
        mainButton(
          context,
          onPressed: () {
            _orderInfo(context, model);
          },
          title: Localizable.orderingInformationMainSendRequest,
          isPrimary: false,
        )
      else
        const SizedBox.shrink(),
    ],
  );
}

void _orderInfo(BuildContext context, OrderingInformationViewModel model) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(Localizable.orderingInformationMainRequestSuccessCreated),
      content: Text(Localizable.orderingInformationMainInfo),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            model.sendReferences();
            Navigator.of(context).popUntil(ModalRoute.withName("/menu"));
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
