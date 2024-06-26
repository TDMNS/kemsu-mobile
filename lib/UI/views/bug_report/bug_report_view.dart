import 'package:flutter/material.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/bug_report/bug_report_view_model.dart';
import 'package:kemsu_app/UI/common_widgets.dart';
import 'package:stacked/stacked.dart';

class MainBugReportScreenRoute extends MaterialPageRoute {
  MainBugReportScreenRoute() : super(builder: (context) => const MainBugReportScreen());
}

class MainBugReportScreen extends StatelessWidget {
  const MainBugReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BugReportViewModel>.reactive(
        viewModelBuilder: () => BugReportViewModel(context),
        onViewModelReady: (viewModel) => viewModel.onReady(context),
        builder: (context, model, child) {
          return Scaffold(
            appBar: customAppBar(context, Localizable.bugReportTitle),
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
                : _body(context, model),
            floatingActionButton: model.circle
                ? Container()
                : FloatingActionButton(
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      showDialog(context: context, builder: (_) => _newMessageDialog(context, model));
                    },
                  ),
          );
        });
  }
}

Widget _body(BuildContext context, BugReportViewModel model) {
  return ListView(
    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    children: [
      const SizedBox(
        height: 34,
      ),
      _errorMessagesTitle(context),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(Localizable.bugReportWarningMessage, style: const TextStyle(color: Colors.red)),
      ),
      _reportSpace(context, model),
    ],
  );
}

Widget _errorMessagesTitle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(right: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          Localizable.bugReportYour,
          style: TextStyle(fontSize: 24, fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColorDark),
        ),
      ],
    ),
  );
}

Widget _reportSpace(BuildContext context, BugReportViewModel model) {
  return model.reportList.isEmpty
      ? Center(child: Text(Localizable.bugReportEmpty, style: const TextStyle(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)))
      : ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: model.reportList.length,
          itemBuilder: (context, index) {
            final reportList = model.reportList[index].reportStatus;
            return ExpansionTile(
              title: Text(model.reportList[index].message.toString()),
              subtitle: Text(reportList ?? Localizable.bugReportNotProcessed, style: TextStyle(color: reportList == "Решено" ? Colors.green : Colors.red)),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),
                          children: <TextSpan>[
                            TextSpan(text: Localizable.bugReportDate),
                            TextSpan(
                                text: model.reportList[index].messageDate.toString(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          });
}

Widget _newMessageDialog(BuildContext context, BugReportViewModel model) {
  return AlertDialog(
    title: Text(Localizable.bugReportCreate),
    backgroundColor: Theme.of(context).primaryColor,
    content: TextField(
      cursorColor: Colors.blue,
      controller: model.errorMsgController,
      decoration: InputDecoration(
        hintText: Localizable.bugReportEnterMessage,
      ),
      maxLines: null,
    ),
    actions: [
      TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, // Text Color
          ),
          onPressed: () async {
            model.sendAction(context);
          },
          child: Text(Localizable.bugReportSend))
    ],
  );
}
