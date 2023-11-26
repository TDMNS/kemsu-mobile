import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/UI/views/profile/profile_view_model.dart';

import '../../../../Configurations/hex.dart';
import '../../../../Configurations/localizable.dart';
import '../../../../domain/repositories/authorization/abstract_auth_repository.dart';
import '../../../common_views/main_button.dart';
import '../../../menu.dart';
import 'auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AuthScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  final _authBloc = AuthBloc(
    const AuthState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );

  @override
  void initState() {
    // _authBloc.add(PostAuthEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: false,
        body: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (context, state) {
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
                  Text(Localizable.authApplicationLogin, style: TextStyle(fontFamily: "Ubuntu", color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(controller: loginController),
                  TextField(controller: passwordController),
                  mainButton(context, onPressed: () {
                    _authBloc.add(PostAuthEvents(loginController.text, passwordController.text));

                    final isAuthSuccess = state.authData?.success ?? false;
                    final userType = state.authData?.userInfo.userType == EnumUserType.employee ? 1 : 0;

                    /// Исправить isAuthSuccess!

                    if (isAuthSuccess) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainMenu(
                            type: userType,
                          ),
                        ),
                      );
                    }
                  }, title: 'Войти', isPrimary: true),
                  const SizedBox(height: 20),
                  mainButton(context, onPressed: () {
                    _customAlert(context);
                  }, title: Localizable.authTroubleLoggingInHeader, isPrimary: false)
                ],
              ),
            ]);
          },
        ),
      ),
    );
  }
}

_customTextField(BuildContext context, FocusNode focusNode, Widget suffixIcon, String hintText, TextEditingController textEditingController, bool isObscure,
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
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: Text(Localizable.ok),
        )
      ],
    ),
  );
}