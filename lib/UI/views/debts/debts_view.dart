import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_lib_model.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_academy_model.dart';
import 'package:kemsu_app/UI/views/debts/models/debts_pay_model.dart';
import '../ordering_information/ordering_information_main/ordering_information_main_view.dart';
import './debts_view_model.dart';
import 'package:stacked/stacked.dart';
import '../../common_widgets.dart';

class DebtsView extends StatefulWidget {
  const DebtsView({super.key});

  @override
  State<DebtsView> createState() => _DebtsViewState();
}

class _DebtsViewState extends State<DebtsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DebtsViewModel>.reactive(
        onViewModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => DebtsViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                appBar: customAppBar(context, 'Долги'),
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
                    : RefreshIndicator(
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
                model.academyDebts.isNotEmpty ? _getAcademyDebtsView(model.academyDebts) : const SizedBox.shrink(),
                model.libraryDebts.isNotEmpty ? _getLibraryDebtsView(model.libraryDebts) : const SizedBox.shrink(),
                model.payDebts.isNotEmpty ? _getPayDebtsView(model.payDebts) : const SizedBox.shrink(),
                const SizedBox(
                  height: 30,
                ),
                model.academyDebts.isEmpty && model.libraryDebts.isEmpty && model.payDebts.isEmpty ? const Text("Задолженностей нет") : const SizedBox.shrink()
              ],
            )),
      ),
    ],
  );
}

Widget _getAcademyDebtsView(List<AcademyDebts> items) {
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
                initiallyExpanded: true,
                expandedAlignment: Alignment.center,
                title: Text(
                  EnumDebts.academyDebtsTitle,
                  style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: "Ubuntu", fontSize: 17, fontWeight: FontWeight.bold),
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

Widget _getLibraryDebtsView(List<LibraryDebts> items) {
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
                initiallyExpanded: true,
                expandedAlignment: Alignment.center,
                title: Text(
                  EnumDebts.libraryDebtsTitle,
                  style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: "Ubuntu", fontSize: 17, fontWeight: FontWeight.bold),
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

Widget _getPayDebtsView(List<PayDebts> items) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                initiallyExpanded: true,
                expandedAlignment: Alignment.center,
                title: Text(
                  EnumDebts.payDebtsTitle,
                  style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: "Ubuntu", fontSize: 17, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        richText("Сумма: ", "${item.amount}", context),
                        const SizedBox(height: 10),
                        richText("На дату: ", DateFormat('dd-MM-yy').format(item.date ?? DateTime.now()), context),
                        const SizedBox(height: 10)
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
