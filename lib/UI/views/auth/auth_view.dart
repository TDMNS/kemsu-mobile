import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'auth_viewmodel.dart';

final loginController = TextEditingController();
final passwordController = TextEditingController();

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.onReady(),
        viewModelBuilder: () => AuthViewModel(context),
        builder: (context, model, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness
                      .dark), //прозрачность statusbar и установка тёмных иконок
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(
                      context); //расфокус textfield при нажатии на экран
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  body: _authView(context, model),
                ),
              ));
        });
  }
}

_authView(BuildContext context, AuthViewModel model) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image.asset(
        'images/kemsu_logo.png',
        height: 120,
      ),
      const SizedBox(height: 50),
      Container(
        margin: const EdgeInsets.only(right: 30, left: 30, bottom: 30, top: 8),
        color: Colors.grey.withOpacity(0.05),
        child: TextFormField(
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, top: 15),
              suffixIcon: Icon(Icons.person),
              focusColor: Colors.black,
              hintText: 'Логин',
              hintStyle: TextStyle(
                  fontFamily: "Ubuntu",
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          style: const TextStyle(
              fontFamily: "Ubuntu",
              color: Color.fromRGBO(91, 91, 126, 1),
              fontWeight: FontWeight.bold),
          controller: loginController,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(right: 30, left: 30, bottom: 30, top: 8),
        color: Colors.grey.withOpacity(0.05),
        child: TextFormField(
          decoration: InputDecoration(
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  passwordController.text != ''
                      ? IconButton(
                          onPressed: () {
                            model.isVisiblePassword();
                          },
                          icon: Icon(model.isObscure
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined))
                      : const SizedBox(),
                  const Icon(Icons.vpn_key),
                  const SizedBox(width: 5)
                ],
              ),
              contentPadding: const EdgeInsets.only(left: 15, top: 15),
              hintText: '••••••',
              hintStyle: const TextStyle(
                  letterSpacing: 5.0,
                  fontFamily: "Ubuntu",
                  color: Color.fromRGBO(91, 91, 126, 1),
                  fontWeight: FontWeight.bold)),
          style: const TextStyle(
              letterSpacing: 5.0,
              fontFamily: "Ubuntu",
              color: Color.fromRGBO(91, 91, 126, 1),
              fontWeight: FontWeight.bold),
          controller: passwordController,
          obscureText: model.isObscure,
        ),
      ),
      GestureDetector(
        onTap: () {
          model.authButton(context);
        },
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 15))
          ]),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Center(
                child: Text(
              'Войти',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
          ),
        ),
      )
    ],
  );
}
