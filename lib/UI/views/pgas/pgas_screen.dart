import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/pgas/pgas_viewmodel.dart';
import 'package:kemsu_app/UI/widgets.dart';
import 'package:stacked/stacked.dart';

class PgasScreenRoute extends MaterialPageRoute {
  PgasScreenRoute() : super(builder: (context) => const PgasScreen());
}

class PgasScreen extends StatelessWidget {
  const PgasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasViewModel>.reactive(
        viewModelBuilder: () => PgasViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(context),
        builder: (context, model, child) {
          return model.circle ? const Center(child: CircularProgressIndicator(),) : Scaffold(
            appBar: customAppBar(context, model, "ПГАС"),
            body: _body(context, model),
          );
        });
  }
}

_body(context, model) {
  return ListView(
    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    children: [
      const SizedBox(height: 34,),
      _createRequestButton(context, model),
      const SizedBox(height: 34,),
      _pgasRequestsTitle(),
      const SizedBox(height: 31,),
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
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 6),
                spreadRadius: 1,
                blurRadius: 7
            )
          ],
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00C2FF),
              Colors.blueAccent
            ],
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
              color: Colors.white,),
          ),

        )
    ),
  );
}

_pgasRequestsTitle() {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Text(
          "Ваши заявки",
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

_pgasRequestsSpace(context, PgasViewModel model) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: model.pgasList.isEmpty ? const Center(
        child: Text(
            "Нет заявок на ПГАС.",
            style: TextStyle(fontSize: 12, color: Color(0xFF757575), fontWeight: FontWeight.w500)
        )) : ListView.builder(
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
                    Text("Заявка №${model.pgasList[index].requestId}",
                      style: const TextStyle(fontFamily: "Ubuntu", fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),),
                    Row(
                      children: [
                        TextButton(onPressed: () async {
                          await model.storage.write(key: "pgas_id", value: model.pgasList[index].requestId.toString());
                          model.goToPgasDetail(context);
                        },
                            child: const Text("Подробнее...", style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent
                        ),)),
                        model.pgasList[index].approveFlag == 1 ? const Icon(Icons.check, color: Colors.green, size: 36,) :
                        const Icon(Icons.access_time_outlined, color: Colors.black, size: 36,)
                      ],
                    )
                  ],
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                )
              ],
            ),
          );
        }
    ),
  );
}