import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/Configurations/hex.dart';
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
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: Theme.of(context).primaryColor == Colors.grey.shade900 ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                extendBody: true,
                extendBodyBehindAppBar: true,
                body: _buildAuthView(context, model),
              ),
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
          Text(Localizable.authApplicationLogin,
              style: TextStyle(fontFamily: "Ubuntu", color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _customTextField(
              context,
              model.loginFocus,
              (model.loginController.text.isNotEmpty && model.loginFocus.hasFocus
                  ? IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        model.loginController.clear();
                        model.notifyListeners();
                      })
                  : const SizedBox()),
              Localizable.authLogin,
              model.loginController,
              false,
              TextInputAction.next, () {
            model.notifyListeners();
          }, () {
            model.notifyListeners();
          }, () {
            FocusScope.of(context).requestFocus(model.passwordFocus);
            model.notifyListeners();
          }),
          _customTextField(
              context,
              model.passwordFocus,
              Row(
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
              Localizable.authEnterPassword,
              model.passwordController,
              model.isObscure,
              TextInputAction.done, () {
            model.notifyListeners();
          }, () {
            model.notifyListeners();
          }, () {
            model.notifyListeners();
          }),
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
                  Localizable.authRememberMe,
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
            _customAlert(context);
          }, title: Localizable.authTroubleLoggingInHeader, isPrimary: false)
        ],
      ),
    ]);
  }

  _customTextField(BuildContext context, FocusNode focusNode, Widget suffixIcon, String hintText, TextEditingController textEditingController, bool
  isObscure,
      TextInputAction textInputAction, onChanged, onTap, onFieldSubmitted) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 8, top: 8),
      child: TextFormField(
          focusNode: focusNode,
          onChanged: (letters) {
            onChanged();
          },
          onTap: () {
            onTap();
          },
          decoration: InputDecoration(
              fillColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? HexColor('#232325') : HexColor('#f2f3f5'),
              filled: true,
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.only(left: 15, top: 15),
              hintText: hintText,
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
          controller: textEditingController,
          obscureText: isObscure,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: textInputAction,
          onFieldSubmitted: (v) {
            onFieldSubmitted();
          },
          textCapitalization: TextCapitalization.none),
    );
  }

  void _customAlert(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(Localizable.authTroubleLoggingInHeader),
        content: Text(
          Localizable.authTroubleLoggingInBody,
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
