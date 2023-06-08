import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'auth_view_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.onReady(),
      viewModelBuilder: () => AuthViewModel(context),
      builder: (context, model, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Theme.of(context).primaryColor == Colors.grey.shade900
                ? Brightness.light
                : Brightness.dark,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody: true,
              extendBodyBehindAppBar: true,
              body: _buildAuthView(context, model),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthView(BuildContext context, AuthViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Theme.of(context).primaryColor == Colors.grey.shade900
            ? Image.asset(
          'images/logo_dark.png',
          height: 120,
        )
            : Image.asset(
          'images/logo_light.png',
          height: 120,
        ),
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.only(right: 30, left: 30, bottom: 30, top: 8),
          color: Colors.grey.withOpacity(0.05),
          child: TextFormField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, top: 15),
              suffixIcon: Icon(
                Icons.person,
              ),
              focusColor: Colors.black,
              hintText: 'Логин',
              hintStyle: TextStyle(fontFamily: "Ubuntu", color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            style: const TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold),
            controller: model.loginController,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 30, left: 30, bottom: 30, top: 8),
          color: Colors.grey.withOpacity(0.05),
          child: TextFormField(
            decoration: InputDecoration(
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  model.passwordController.text != ''
                      ? IconButton(
                    onPressed: () {
                      model.isVisiblePassword();
                    },
                    icon: Icon(model.isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                  )
                      : const SizedBox(),
                  const Icon(
                    Icons.vpn_key,
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              contentPadding: const EdgeInsets.only(left: 15, top: 15),
              hintText: '••••••',
              hintStyle: const TextStyle(letterSpacing: 5.0, fontFamily: "Ubuntu", fontWeight: FontWeight.bold),
            ),
            style: const TextStyle(letterSpacing: 5.0, fontFamily: "Ubuntu", fontWeight: FontWeight.bold),
            controller: model.passwordController,
            obscureText: model.isObscure,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: model.rememberMe,
                activeColor: Colors.blue,
                onChanged: (bool? value) {
                  model.rememberFunc(value);
                },
              ),
              const Text(
                'Запомнить меня',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            model.authButton(context);
          },
          child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 15),
                  spreadRadius: -15,
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text(
                  'Войти',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: GestureDetector(
            onTap: () {
              authAlert(context);
            },
            child: const Text(
              'Проблемы с входом?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  void authAlert(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Проблемы со входом?'),
        content: const Text(
          'Если у вас наблюдаются проблемы с входом попробуйте использовать Wi-Fi КемГУ, изменить сотового оператора, либо использовать VPN. Мы уже исправляем эту проблему. В данный момент не работают сотовые операторы "Мегафон" и "Yota"',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
