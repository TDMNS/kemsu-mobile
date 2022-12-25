import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../loadingScreen.dart';
import 'pgas_request_info_viewmodel.dart';

class PgasRequestInfoScreenRoute extends MaterialPageRoute {
  PgasRequestInfoScreenRoute() : super(builder: (context) => const PgasRequestInfoScreen());
}

class PgasRequestInfoScreen extends StatelessWidget {
  const PgasRequestInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PgasRequestInfoViewModel>.reactive(
        viewModelBuilder: () => PgasRequestInfoViewModel(context),
        onModelReady: (viewModel) => viewModel.onReady(context),
        builder: (context, model, child) {
          return model.circle ? const Center(child: LoadingScreen()) : Scaffold(
            appBar: _appBar(context, model),
            body: _body(context, model),
          );
        });
  }
}

_appBar(context, PgasRequestInfoViewModel model) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_outlined),
      color: Colors.black,
      onPressed: () async {
        Navigator.pop(context);
      },
      iconSize: 32,
    ),
    actions: [
      IconButton(
          onPressed: () {
            model.goToEditPgasRequestScreen(context);
          },
          icon: _gradientIcon(Icons.edit, const Color(0xFF00C2FF), Colors.blueAccent, 32)//const Icon(Icons.edit_outlined, color: Color(0xFF5878DD), size: 32,)
      ),
      IconButton(
          onPressed: () {
            _deleteRequestAlert(context, model);
          },
          icon: _gradientIcon(Icons.delete, Colors.red, Colors.deepOrange, 32)
      )
    ],
    elevation: 0,
    backgroundColor: Colors.transparent,
  );
}

_body(context, PgasRequestInfoViewModel model) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _title(context),
            ],
          ),
        ),
        _infoTextField(context, _gradientIcon(Icons.person, const Color(0xFF00C2FF), Colors.blueAccent, 32), model.pgasRequest!.surname.toString(), "Фамилия"),
        _infoTextField(context, _gradientIcon(Icons.person, const Color(0xFF00C2FF), Colors.blueAccent, 32), model.pgasRequest!.name.toString(), "Имя"),
        _infoTextField(context, _gradientIcon(Icons.person, const Color(0xFF00C2FF), Colors.blueAccent, 32), model.pgasRequest!.patronymic.toString(), "Отчество"),
        _infoTextField(context, _gradientIcon(Icons.phone, const Color(0xFF00C2FF), Colors.blueAccent, 32), model.pgasRequest!.phone.toString(), "Номер телефона"),
        _infoTextField(context, _gradientIcon(Icons.school, const Color(0xFF00C2FF), Colors.blueAccent, 32), model.pgasRequest!.facultyName.toString(), "Институт"),
        _infoTextField(context, _gradientIcon(Icons.school, const Color(0xFF00C2FF), Colors.blueAccent, 32), model.pgasRequest!.group.toString(), "Группа"),
        _infoTextField(context, null, model.pgasRequest!.courseNum.toString(), "Курс"),
        _infoTextField(context, null, model.pgasRequest!.studyYear.toString(), "Учебный год"),
        _infoTextField(context, null, model.pgasRequest!.semesterType.toString(), "Семестр"),
      ],
    ),
  );
}

_title(context) {
  return const Text("Ваша заявка",
      style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF5B5B7E)
      )
  );
}

_deleteRequestAlert(context, PgasRequestInfoViewModel model) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Удаление заявки на ПГАС",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5B5B7E)
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Вы действительно хотите удалить заявку?\nВосстановить заявку будет невозможно.",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF757575)
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 6),
                            spreadRadius: 1,
                            blurRadius: 7
                        )
                      ],
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.redAccent,
                          Colors.red
                        ],
                      ),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        model.deletePgasAction(context);
                      },
                      child: const Text(
                        "Подтвердить",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,),
                      ),

                    )
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Отмена")
            ),
          ],
        );
      }
  );
}

_infoTextField(context, ShaderMask? icon, String dataString, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    child: TextFormField(
      enabled: false,
      decoration: InputDecoration(
          prefixIcon: icon,
          labelText: label,
          labelStyle: const TextStyle(
              color: Color(0xFF4065D8)
          )
      ),
      initialValue: dataString,
    ),
  );
}

_gradientIcon(IconData icon, Color firstColor, Color secondColor, double size) {
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
      size: size,
    ),
  );
}