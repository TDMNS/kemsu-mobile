import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/pgas/new_achieve_pgas_screen.dart';
import 'package:stacked/stacked.dart';

import 'pgas_detail_viewmodel.dart';

class PgasDetailScreenRoute extends MaterialPageRoute {
  PgasDetailScreenRoute() : super(builder: (context) => const PgasDetailScreen());
}

class PgasDetailScreen extends StatelessWidget {
  const PgasDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasDetailViewModel>.reactive(
        viewModelBuilder: () => PgasDetailViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }
}

_appBar(context, PgasDetailViewModel model) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_outlined),
      color: Colors.black,
      onPressed: () {
        model.goToPgasRequestList(context);
      },
      iconSize: 32,
    ),
    elevation: 0,
    actions: [
      IconButton(
          onPressed: () {
            model.goToPgasRequestInfoScreen(context);
          },
          icon: _gradientIcon(Icons.info, const Color(0xFF00C2FF), Colors.blueAccent)
      )
    ],
    backgroundColor: Colors.transparent,
  );
}

_body(context, PgasDetailViewModel model) {
  return ListView(
    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    children: [
      const SizedBox(height: 34,),
      _createAchieveButton(context, model),
      const SizedBox(height: 34,),
      _pgasAchieveTitle(),
    ],
  );
}

_pgasAchieveTitle() {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Text(
          "Прикрепленные достижения",
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

_gradientIcon(IconData icon, Color firstColor, Color secondColor) {
  return ShaderMask(
      shaderCallback: (bounds) =>
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              firstColor,
              secondColor
            ],
          ).createShader(bounds),
    child: Icon(
      icon,
      size: 32,
    ),
  );
}

_createAchieveButton(context, PgasDetailViewModel model) {
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NewAchievePgasScreen()));
          },
          child: const Text(
            "Прикрепить достижение",
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
