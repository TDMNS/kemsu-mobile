import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_view.dart';
import 'package:stacked/stacked.dart';
import '../../menu.dart';
import '../../widgets.dart';
import 'ordering_information_main_viewmodel.dart';
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
    return ViewModelBuilder<OrderingInformationMainViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => OrderingInformationMainViewModel(context),
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
                  body: _orderingInformationView(context, model)
                ),
              ));
        });
  }
}

_orderingInformationView(context, OrderingInformationMainViewModel model) {
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

_checkListView(BuildContext context, OrderingInformationMainViewModel model) {
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
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 15, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 15))
                ]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
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
                        richText("Название института: ",
                            "${item.instituteName}", context),
                        const SizedBox(height: 10),
                        richText("Курс: ", "${item.courseNumber}", context),
                        const SizedBox(height: 10),
                        richText("Уровень образования: ",
                            "${item.educationLevel}", context),
                        const SizedBox(height: 10),
                        richText("Группа: ", "${item.groupName}", context),
                        const SizedBox(height: 10),
                        richText("Форма обучения: ", "${item.basic}", context),
                        const SizedBox(height: 10),
                        richText("Период: ", "${item.period}", context),
                        const SizedBox(height: 10),
                        richText("Количество справок: ",
                            "${item.countReferences}", context),
                        const SizedBox(height: 10),
                        richText(
                            "Дата запроса: ", "${item.requestDate}", context),
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

RichText richText(String title, String item, context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).primaryColorDark,
      ),
      children: <TextSpan>[
        TextSpan(text: title),
        TextSpan(
            text: item,
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold)),
      ],
    ),
  );
}