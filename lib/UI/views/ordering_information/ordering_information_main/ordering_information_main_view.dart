import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:kemsu_app/UI/common_views/main_dropdown.dart';
import 'package:stacked/stacked.dart';
import '../../../../Configurations/localizable.dart';
import '../../../common_widgets.dart';
import '../ordering_information_model.dart';
import '../ordering_information_new_certificates/ordering_information_new_certificates_view.dart';
import '../ordering_information_view/ordering_information_view.dart';
import 'ordering_information_main_view_model.dart';

class OrderingInformationMainView extends StatefulWidget {
  const OrderingInformationMainView({super.key});

  @override
  State<OrderingInformationMainView> createState() => _OrderingInformationMainViewState();
}

class _OrderingInformationMainViewState extends State<OrderingInformationMainView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderingInformationMainViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => OrderingInformationMainViewModel(context),
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
                    body: model.circle
                        ? Container(
                            color: Theme.of(context).primaryColor,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          )
                        : _orderingInformationView(context, model)),
              ));
        });
  }
}

_orderingInformationView(context, OrderingInformationMainViewModel model) {
  return ListView(
    shrinkWrap: true,
    children: <Widget>[
      const SizedBox(height: 10),
      const SizedBox(height: 10),
      mainDropdown(context,
          value: model.trainingCertificate,
          items: model.trainingCertificates.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(e),
              ),
            );
          }).toList(),
          textHint: Localizable.orderingInformationType, onChanged: (value) {
        model.trainingCertificate = value;
        model.notifyListeners();
      }),
      const SizedBox(height: 10),
      model.trainingCertificate == TrainingCertificate.trainingCertificate
          ? Column(
              children: [
                Center(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: mainButton(context, onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderingInformationView()));
                      }, title: Localizable.orderingInformationButton, isPrimary: true)),
                ),
                Center(
                  child: _checkListView(context, model),
                )
              ],
            )
          : const SizedBox.shrink(),
      model.trainingCertificate == TrainingCertificate.callCertificate ? _checkCertificatesListView(context, model) : const SizedBox.shrink(),
    ],
  );
}

_checkCertificatesListView(BuildContext context, OrderingInformationMainViewModel model) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, children: [
      const SizedBox(height: 12),
      Wrap(children: [
        Text(Localizable.orderingInformationRequestHelpCall, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 38),
        getCertificatesListView(model.receivedCallCertificate)
      ]),
    ]),
  );
}

Widget getCertificatesListView(List<CallCertificate> items) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 15, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColorLight.withOpacity(0.5), blurRadius: 35, offset: const Offset(0, 15), spreadRadius: -15)]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    richText(Localizable.orderingInformationGroupName, "${item.groupName}", context),
                    const SizedBox(height: 10),
                    richText(Localizable.orderingInformationTypeDate, "${item.sessionType}", context),
                    const SizedBox(height: 10),
                    richText(Localizable.orderingInformationStudyYear, "${item.studyYear}", context),
                    const SizedBox(height: 10),
                    richText(Localizable.orderingInformationDateStart, "${item.startDate}", context),
                    const SizedBox(height: 10),
                    richText(Localizable.orderingInformationDateEnd, "${item.endDate}", context),
                    const SizedBox(height: 10),
                    mainButton(context, onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderingInformationNewCertificatesView()));
                    }, title: Localizable.orderingInformationNewCall, isPrimary: true)
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

_checkListView(BuildContext context, OrderingInformationMainViewModel model) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: ListView(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, children: [
      const SizedBox(height: 12),
      Wrap(children: [
        Text(Localizable.orderingInformationListReferencesAboutTraining, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 38),
        getListView(model.receivedReferences)
      ]),
    ]),
  );
}

Widget getListView(List<RequestReference> items) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 15, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColorLight, blurRadius: 15, offset: const Offset(0, 15), spreadRadius: -15)]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                collapsedIconColor: Theme.of(context).focusColor,
                initiallyExpanded: true,
                expandedAlignment: Alignment.center,
                title: Text(
                  '${Localizable.orderingInformationCall} №${index + 1}',
                  style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: "Ubuntu", fontSize: 17, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        richText("${Localizable.lastName}: ", "${item.lastName}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.firstName}: ", "${item.firstName}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.patronymic}: ", "${item.patronymic}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.instituteName}: ", "${item.instituteName}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.courseNumber}: ", "${item.courseNumber}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.educationLevel}: ", "${item.educationLevel}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.groupName}: ", "${item.groupName}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.basic}: ", "${item.basic}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.orderingInformationPeriod}: ", "${item.period}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.orderingInformationCountReferences}: ", "${item.countReferences}", context),
                        const SizedBox(height: 10),
                        richText("${Localizable.orderingInformationRequestDate}: ", "${item.requestDate}", context),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

RichText richText(String title, String item, context, {bool? isWhite}) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 16,
        color: isWhite != null && isWhite ? Colors.white : Theme.of(context).primaryColorDark,
      ),
      children: <TextSpan>[
        TextSpan(text: title, style: TextStyle(color: isWhite != null && isWhite ? Colors.white : Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
        TextSpan(text: item),
      ],
    ),
  );
}
