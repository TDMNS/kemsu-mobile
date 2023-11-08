import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/pgas/pgas_view_model.dart';
import 'package:kemsu_app/UI/widgets.dart';
import 'package:stacked/stacked.dart';

class PgasScreenRoute extends MaterialPageRoute {
  PgasScreenRoute() : super(builder: (context) => const PgasScreen());
}

class PgasScreen extends StatelessWidget {
  const PgasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasViewModel>.reactive(
        viewModelBuilder: () => PgasViewModel(context),
        onViewModelReady: (viewModel) => viewModel.onReady(context),
        builder: (context, model, child) {
          return Scaffold(
            appBar: customAppBar(context, "ПГАС"),
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
          );
        });
  }
}

_body(context, PgasViewModel model) {
  return ListView(
    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    children: [
      const SizedBox(
        height: 34,
      ),
      _createRequestButton(context, model),
      const SizedBox(
        height: 34,
      ),
      _pgasRequestsTitle(context),
      const SizedBox(
        height: 31,
      ),
      _pgasRequestsSpace(context, model)
    ],
  );
}

_createRequestButton(context, PgasViewModel model) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
    child: Container(
        width: double.maxFinite,
        height: 46,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Theme.of(context).primaryColorLight, offset: const Offset(0, 6), spreadRadius: -1, blurRadius: 5)],
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00C2FF), Colors.blueAccent],
          ),
        ),
        child: TextButton(
          onPressed: () async {
            model.goToNewPgasRequest(context);
          },
          child: const Text(
            "Подать заявку на ПГАС",
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )),
  );
}

_pgasRequestsTitle(context) {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Ваши заявки",
          style: TextStyle(fontSize: 24, fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, color: Theme.of(context).focusColor),
        ),
      ],
    ),
  );
}

_pgasRequestsSpace(context, PgasViewModel model) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: model.pgasList.isEmpty
        ? const Center(child: Text("Нет заявок на ПГАС.", style: TextStyle(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: model.pgasList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  await model.storage.write(key: "pgas_id", value: model.pgasList[index].requestId.toString());
                  model.goToPgasDetail(context);
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Заявка №${model.pgasList[index].requestId}",
                          style: TextStyle(fontFamily: "Ubuntu", fontSize: 16, color: Theme.of(context).focusColor, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () async {
                                  await model.storage.write(key: "pgas_id", value: model.pgasList[index].requestId.toString());
                                  model.goToPgasDetail(context);
                                },
                                child: Text(
                                  "Подробнее...",
                                  style: TextStyle(fontSize: 16, color: Theme.of(context).focusColor),
                                )),
                            model.pgasList[index].approveFlag == 1
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 36,
                                  )
                                : Icon(
                                    Icons.access_time_outlined,
                                    color: Theme.of(context).focusColor,
                                    size: 36,
                                  )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Theme.of(context).focusColor,
                    )
                  ],
                ),
              );
            }),
  );
}
