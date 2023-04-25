import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/ordering_information/ordering_information_subview/ordering_information_view.dart';
import 'package:stacked/stacked.dart';
import '../../../widgets.dart';
import '../ordering_information_model.dart';
import 'ordering_information_main_viewmodel.dart';

class OrderingInformationMainView extends StatefulWidget {
  const OrderingInformationMainView({Key? key}) : super(key: key);

  @override
  State<OrderingInformationMainView> createState() => _OrderingInformationMainViewState();
}

class _OrderingInformationMainViewState extends State<OrderingInformationMainView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderingInformationMainViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => OrderingInformationMainViewModel(context),
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

_orderingInformationView(context, OrderingInformationMainViewModel model) {
  return ListView(
    shrinkWrap: true,
    children: <Widget>[
      const SizedBox(height: 10),
      const SizedBox(height: 10),
      Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                dropdownColor: Theme.of(context).primaryColor,
                itemHeight: 70.0,
                hint: const Text(
                  '- Выбрать тип заказываемой справки -',
                ),
                onChanged: (value) {
                  model.trainingCertificate = value;
                  model.notifyListeners();
                },
                isExpanded: true,
                value: model.trainingCertificate,
                items: model.trainingCertificates.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem<String>(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
              )),
        ),
      ),
      const SizedBox(height: 10),
      model.trainingCertificate == TrainingCertificate.trainingCertificate
          ? Column(
              children: [
                Center(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const OrderingInformationView()));
                          },
                          child: const Text("Заказать новую справку"))),
                ),
                Center(
                  child: _checkListView(context, model),
                )
              ],
            )
          : const SizedBox.shrink(),
      model.trainingCertificate == TrainingCertificate.callCertificate
          ? _checkCertificatesListView(context, model)
          : const SizedBox.shrink(),
    ],
  );
}

_checkCertificatesListView(BuildContext context, OrderingInformationMainViewModel model) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, children: [
      const SizedBox(height: 12),
      Wrap(children: [
        Text("Заказать справку вызова", style: Theme.of(context).textTheme.headlineSmall),
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
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColorLight,
                      blurRadius: 15,
                      offset: const Offset(0, 15),
                      spreadRadius: -15)
                ]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    richText("Название группы: ", "${item.groupName}", context),
                    const SizedBox(height: 10),
                    richText("Тип даты: ", "${item.sessionType}", context),
                    const SizedBox(height: 10),
                    richText("Учебный год: ", "${item.studyYear}", context),
                    const SizedBox(height: 10),
                    richText("Дата начала: ", "${item.startDate}", context),
                    const SizedBox(height: 10),
                    richText("Дата окончания: ", "${item.endDate}", context),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const OrderingInformationView()));
                        },
                        child: const Text("Заказать новую справку"))
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
    padding: const EdgeInsets.all(8.0),
    child: ListView(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, children: [
      const SizedBox(height: 12),
      Wrap(children: [
        Text("Список справок об обучении", style: Theme.of(context).textTheme.headlineSmall),
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
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColorLight,
                      blurRadius: 15,
                      offset: const Offset(0, 15),
                      spreadRadius: -15)
                ]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                collapsedIconColor: Theme.of(context).focusColor,
                initiallyExpanded: true,
                expandedAlignment: Alignment.center,
                title: Text(
                  'Справка №${index + 1}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: "Ubuntu",
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        richText("Фамилия: ", "${item.lastName}", context),
                        const SizedBox(height: 10),
                        richText("Имя: ", "${item.firstName}", context),
                        const SizedBox(height: 10),
                        richText("Отчество: ", "${item.patronymic}", context),
                        const SizedBox(height: 10),
                        richText("Название института: ", "${item.instituteName}", context),
                        const SizedBox(height: 10),
                        richText("Курс: ", "${item.courseNumber}", context),
                        const SizedBox(height: 10),
                        richText("Уровень образования: ", "${item.educationLevel}", context),
                        const SizedBox(height: 10),
                        richText("Группа: ", "${item.groupName}", context),
                        const SizedBox(height: 10),
                        richText("Форма обучения: ", "${item.basic}", context),
                        const SizedBox(height: 10),
                        richText("Период: ", "${item.period}", context),
                        const SizedBox(height: 10),
                        richText("Количество справок: ", "${item.countReferences}", context),
                        const SizedBox(height: 10),
                        richText("Дата запроса: ", "${item.requestDate}", context),
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
        TextSpan(
            text: title,
            style: TextStyle(
                color: isWhite != null && isWhite ? Colors.white : Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold)),
        TextSpan(text: item),
      ],
    ),
  );
}
