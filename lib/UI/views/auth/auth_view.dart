import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:stacked/stacked.dart';

import '../../../Configurations/localizable.dart';
import 'auth_view_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
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
    return ListView(children: [
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
          Text(Localizable.applicationLogin,
              style: TextStyle(fontFamily: "Ubuntu", color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 8, top: 8),
            child: TextFormField(
                focusNode: model.loginFocus,
                onChanged: (letters) {
                  model.notifyListeners();
                },
                onTap: () {
                  model.notifyListeners();
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15, top: 15),
                    suffixIcon: model.loginController.text.isNotEmpty && model.loginFocus.hasFocus
                        ? IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              model.loginController.clear();
                              model.notifyListeners();
                            })
                        : null,
                    hintText: Localizable.login,
                    hintStyle: const TextStyle(fontFamily: "Ubuntu", color: Colors.grey, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    )),
                style: const TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold),
                controller: model.loginController,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(model.passwordFocus);
                  model.notifyListeners();
                },
                textCapitalization: TextCapitalization.none),
          ),
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 8, top: 8),
            child: TextFormField(
                focusNode: model.passwordFocus,
                onChanged: (letters) {
                  model.notifyListeners();
                },
                onTap: () {
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
                    hintText: Localizable.enterPassword,
                    hintStyle: const TextStyle(fontFamily: "Ubuntu", color: Colors.grey, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    )),
                style: const TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold),
                controller: model.passwordController,
                obscureText: model.isObscure,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (v) {
                  model.notifyListeners();
                },
                textCapitalization: TextCapitalization.none),
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
                Text(
                  Localizable.rememberMe,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          mainButton(context, onPressed: () {
            model.authButton(context);
          }, title: 'Войти', isPrimary: true),
          const SizedBox(height: 20),
          mainButton(context, onPressed: () {
            _authAlert(context);
          }, title: Localizable.troubleLoggingInHeader, isPrimary: false)
        ],
      ),
    ]);
  }

  void _authAlert(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(Localizable.troubleLoggingInHeader),
        content: Text(
          Localizable.troubleLoggingInBody,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Localizable.ok),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
