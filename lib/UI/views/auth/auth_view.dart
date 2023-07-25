import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/common_views/primary_button.dart';
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
            statusBarIconBrightness: Theme.of(context).primaryColor == Colors.grey.shade900 ? Brightness.light : Brightness.dark,
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
    return ListView(
      children: [
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 30),
          Theme.of(context).primaryColor == Colors.grey.shade900
              ? Image.asset(
                  'images/logo_dark.png',
                  height: 120,
                )
              : Image.asset(
                  'images/logo_light.png',
                  height: 120,
                ),
          const SizedBox(height: 30),
          Text('Войти в КемГУ', style: TextStyle(fontFamily: "Ubuntu", color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 8, top: 8),
            child: TextFormField(
              onChanged: (letters) {
                model.notifyListeners();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 15, top: 15),
                suffixIcon: model.loginController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.cancel), onPressed: () {
                  model.loginController.clear();
                  model.notifyListeners();
                }) : null,
                hintText: 'Логин',
                hintStyle: const TextStyle(fontFamily: "Ubuntu", color: Colors.grey, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blue),
                )
              ),
              style: const TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold),
              controller: model.loginController,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 8, top: 8),
            child: TextFormField(
              onChanged: (letters) {
                model.notifyListeners();
              },
              decoration: InputDecoration(
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    model.passwordController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              model.isVisiblePassword();
                            },
                            icon: Icon(model.isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                          )
                        : const SizedBox()
                  ],
                ),
                contentPadding: const EdgeInsets.only(left: 15, top: 15),
                hintText: 'Введите пароль',
                hintStyle: const TextStyle(fontFamily: "Ubuntu", color: Colors.grey, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blue),
                )
              ),
              style: const TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold),
              controller: model.passwordController,
              obscureText: model.isObscure,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3, bottom: 8),
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
          mainButton(context, onPressed: () {
            model.authButton(context);
          }, title: 'Войти', isPrimary: true),
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: GestureDetector(
              onTap: () {
                _authAlert(context);
              },
              child: const Text(
                'Проблемы с входом?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  void _authAlert(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Проблемы со входом?'),
        content: const Text(
          'Если у вас наблюдаются проблемы с входом попробуйте использовать Wi-Fi КемГУ, изменить сотового оператора, либо использовать VPN. Мы уже исправляем эту проблему. В данный момент не работают сотовые операторы "Мегафон" и "Yota"',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
