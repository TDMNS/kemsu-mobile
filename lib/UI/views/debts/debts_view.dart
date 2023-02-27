import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_lib_model.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_model.dart';
import '../ordering information/ordering_information_main_view.dart';
import './debts_viewmodel.dart';
import 'package:stacked/stacked.dart';
import '../../widgets.dart';

class DebtsView extends StatefulWidget {
  const DebtsView({Key? key}) : super(key: key);

  @override
  State<DebtsView> createState() => _DebtsViewState();
}

class _DebtsViewState extends State<DebtsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DebtsViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => DebtsViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                appBar: customAppBar(context, model, 'Долги'),
                body: RefreshIndicator(
                  backgroundColor: Colors.blue,
                  color: Colors.white,
                  onRefresh: () => _pullRefresh(model),
                  child: _debtsView(context, model),
                )),
          );
        });
  }

  Future<void> _pullRefresh(DebtsViewModel model) async {
    await model.updateDebts();
  }
}

_debtsView(BuildContext context, DebtsViewModel model) {
  return ListView(
    children: <Widget>[
      const SizedBox(height: 12),
      Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                model.debtsCourse.isNotEmpty ? _getAcademyDebtView(model.debtsCourse) : const SizedBox.shrink(),
                model.libraryDebts.isNotEmpty ? _getLibraryDebtView(model.libraryDebts) : const SizedBox.shrink(),
                const SizedBox(
                  height: 30,
                ),
                model.debtsCourse.isEmpty && model.libraryDebts.isEmpty
                    ? const Text("Задолженностей нет")
                    : const SizedBox.shrink()
              ],
            )),
      ),
    ],
  );
}

Widget _getAcademyDebtView(List<AcademyDebts> items) {
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
                  BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 15))
                ]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                expandedAlignment: Alignment.center,
                title: Text(
                  EnumDebts.academicDebt,
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
                        richText("Номер курса: ", "${item.course}", context),
                        const SizedBox(height: 10),
                        richText("Номер семестра: ", "${item.semester}", context),
                        const SizedBox(height: 10),
                        richText("Дисциплина: ", "${item.discipline}", context),
                        const SizedBox(height: 10),
                        richText("Текущая оценка: ", "${item.shortMark}", context)
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

Widget _getLibraryDebtView(List<LibraryDebts> items) {
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
                  BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 15))
                ]),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                expandedAlignment: Alignment.center,
                title: Text(
                  EnumDebts.libraryDebt,
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
                        richText("Книга: ", "${item.info}", context),
                        const SizedBox(height: 10),
                        richText("Дата выдачи книги: ", "${item.extraditionDay}", context),
                        const SizedBox(height: 10),
                        richText("Предполагаемая дата возврата книги: ", "${item.estimatedReturnDay}", context),
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
