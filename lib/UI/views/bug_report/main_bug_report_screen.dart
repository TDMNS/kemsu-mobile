import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/bug_report/bug_report_viewmodel.dart';
import 'package:kemsu_app/UI/widgets.dart';
import 'package:stacked/stacked.dart';

class MainBugReportScreenRoute extends MaterialPageRoute {
  MainBugReportScreenRoute() : super(builder: (context) => const MainBugReportScreen());
}

class MainBugReportScreen extends StatelessWidget {
  const MainBugReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BugReportViewModel>.reactive(
        viewModelBuilder: () => BugReportViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(context),
        builder: (context, model, child) {
          return model.circle ? const Center(child: CircularProgressIndicator(),) : Scaffold(
            appBar: customAppBar(context, model, "Сообщения об ошибках"),
            body: _body(context, model),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => newMessageDialog(context, model)
                );
              },
            ),
          );
        });
  }
}

_body(context, BugReportViewModel model) {
  return ListView(
    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    children: [
      const SizedBox(height: 34,),
      _errorMessagesTitle(),
      const SizedBox(height: 34,),
      _reportSpace(context, model),
    ],
  );
}

_errorMessagesTitle() {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Text(
          "Ваши обращения",
          style: TextStyle(
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5B5B7E)
          ),
        ),
      ],
    ),
  );
}

_reportSpace(context, BugReportViewModel model) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: model.reportList.isEmpty ? Center(
        child: Text(
            "Нет отправленных обращений.",
            style: TextStyle(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)
        )
    ) : ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: model.reportList.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(model.reportList[index].message.toString()),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          const TextSpan(text: 'Дата обращения: '),
                          TextSpan(
                              text: model.reportList[index].messageDate.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
    ),
  );
}

newMessageDialog(context, BugReportViewModel model) {
  return AlertDialog(
    title: Text("Создать обращение"),
    content: TextField(
      controller: model.errorMsgController,
      decoration: InputDecoration.collapsed(
          hintText: 'Введите сообщение'
      ),
    ),
    actions: [
      TextButton(
          onPressed: () async {
            model.sendAction(context);
          },
          child: Text("Отправить")
      )
    ],
  );
}