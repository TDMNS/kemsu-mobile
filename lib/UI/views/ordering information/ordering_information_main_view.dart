import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_view.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_viewmodel.dart';
import 'package:stacked/stacked.dart';
import '../../widgets.dart';
import 'ordering_information_model.dart';

class OrderingInformationMainView extends StatefulWidget {
  const OrderingInformationMainView({Key? key}) : super(key: key);

  @override
  State<OrderingInformationMainView> createState() =>
      _OrderingInformationMainViewState();
}

class _OrderingInformationMainViewState
    extends State<OrderingInformationMainView> {
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
  return ListView(
    shrinkWrap: true,
    children: <Widget>[
      const SizedBox(height: 10),
      Center(
        child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const OrderingInformationView()));
                },
                child: const Text("Заказать новую справку"))),
      ),
      Center(
        child: _checkListView(context, model),
      )
    ],
  );
}

_checkListView(BuildContext context, OrderingInformationViewModel model) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          const SizedBox(height: 12),
          Wrap(children: [
            Text("Список заказанных справок",
                style: Theme.of(context).textTheme.headline5),
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
          ExpansionTile(
            expandedAlignment: Alignment.center,
            title: Text(
              'Справка №${index + 1}',
              style: const TextStyle(
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
                    richText("Фамилия: ", "${item.lastName}"),
                    const SizedBox(height: 10),
                    richText("Имя: ", "${item.firstName}"),
                    const SizedBox(height: 10),
                    richText("Отчество: ", "${item.patronymic}"),
                    const SizedBox(height: 10),
                    richText("Название института: ", "${item.instituteName}"),
                    const SizedBox(height: 10),
                    richText("Курс: ", "${item.courseNumber}"),
                    const SizedBox(height: 10),
                    richText("Уровень образования: ", "${item.educationLevel}"),
                    const SizedBox(height: 10),
                    richText("Группа: ", "${item.groupName}"),
                    const SizedBox(height: 10),
                    richText("Форма обучения: ", "${item.basic}"),
                    const SizedBox(height: 10),
                    richText("Период: ", "${item.period}"),
                    const SizedBox(height: 10),
                    richText("Количество справок: ", "${item.countReferences}"),
                    const SizedBox(height: 10),
                    richText("Дата запроса: ", "${item.requestDate}"),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

RichText richText(String title, String item) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      children: <TextSpan>[
        TextSpan(text: title),
        TextSpan(
            text: item,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

// Text("Фамилия: ${item.lastName}"),
// Text("Имя: ${item.firstName}"),
// Text("Отчество: ${item.patronymic}"),
// Text("Название института: ${item.instituteName}"),
// Text("Курс: ${item.courseNumber}"),
// Text("Уровень образования: ${item.educationLevel}"),
// Text("Группа: ${item.groupName}"),
// Text("Форма обучения: ${item.basic}"),
// Text("Период: ${item.period}"),
// Text("Количество справок: ${item.countReferences}"),
// Text("Дата запроса: ${item.requestDate}"),
