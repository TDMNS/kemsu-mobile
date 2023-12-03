import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
  final loginFocus = FocusNode();
  final passwordFocus = FocusNode();

  final _authBloc = AuthBloc(
    const AuthState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );

  @override
  void initState() {
    _authBloc.add(GetUserDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: false,
        body: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (context, state) {
            // loginController.text = state.login;
            // passwordController.text = state.password;
            return GestureDetector(
              onTap: () {
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: ListView(children: [
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
                    // TextField(controller: loginController..text = state.login),
                    // TextField(controller: passwordController..text = state.password),
                    _customTextField(
                        context: context,
                        focusNode: loginFocus,
                        suffixIcon: (loginController.text.isNotEmpty && loginFocus.hasFocus
                            ? IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  _authBloc.add(UpdateLoginTextFieldEvent(login: ''));
                                  loginController.clear();
                                })
                            : const SizedBox()),
                        hintText: Localizable.authLogin,
                        textEditingController: state.login.isNotEmpty ? (loginController..text = state.login) : loginController,
                        isObscure: false,
                        textInputAction: TextInputAction.next,
                        onChanged: (changedLogin) {
                          print("$changedLogin");
                          _authBloc.add(UpdateLoginTextFieldEvent(login: changedLogin));
                          loginController.text = changedLogin;
                        },
                        onTap: () {
                          /// Тут проблема, текст филд не обновляется если фокус был на пароле
                          _authBloc.add(UpdateLoginTextFieldEvent(login: state.login));
                          loginController.text = state.login;
                        },
                        onFieldSubmitted: (finalLogin) {
                          FocusScope.of(context).requestFocus(passwordFocus);
                          _authBloc.add(UpdateLoginTextFieldEvent(login: finalLogin));
                          loginController.text = finalLogin;
                        }),
                    _customTextField(
                        context: context,
                        focusNode: passwordFocus,
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            passwordController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _authBloc.add(ChangePasswordObscureEvent(isObscure: state.isObscure));
                                    },
                                    icon: Icon(state.isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        hintText: Localizable.authEnterPassword,
                        textEditingController: state.password.isNotEmpty ? (passwordController..text = state.password) : passwordController,
                        isObscure: state.isObscure,
                        textInputAction: TextInputAction.done,
                        onChanged: (changedPassword) {
                          _authBloc.add(UpdatePasswordTextFieldEvent(password: changedPassword));
                          passwordController.text = changedPassword;
                        },
                        onTap: () {
                          /// Тут проблема, текст филд не обновляется если фокус был на логине
                          _authBloc.add(UpdatePasswordTextFieldEvent(password: state.password));
                          passwordController.text = state.password;
                        },
                        onFieldSubmitted: (finalPassword) {
                          _authBloc.add(UpdatePasswordTextFieldEvent(password: finalPassword));
                          passwordController.text = finalPassword;
                          passwordFocus.unfocus();
                        }),
                    _profileCheckBox(state: state, bloc: _authBloc),
                    mainButton(context, onPressed: () {
                      _authBloc.add(PostAuthEvents(loginController.text, passwordController.text, context));

                      _authBloc.stream.listen((state) {
                        if (state.isAuthSuccess) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainMenu(
                                type: state.userType,
                              ),
                            ),
                          );
                        }
                      });
                    }, title: 'Войти', isPrimary: true),
                    const SizedBox(height: 20),
                    mainButton(context, onPressed: () {
                      _customAlert(context);
                    }, title: Localizable.authTroubleLoggingInHeader, isPrimary: false)
                  ],
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}

_profileCheckBox({required state, required bloc}) {
  return Padding(
    padding: const EdgeInsets.only(left: 3, bottom: 8),
    child: Row(
      children: <Widget>[
        Checkbox(
          value: state.isRememberMe,
          activeColor: Colors.blue,
          onChanged: (bool? value) {
            bloc.add(ChangeRememberMeEvent(isRememberMe: value));
          },
        ),
        Text(
          Localizable.authRememberMe,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    ),
  );
}

_customTextField(
    {required BuildContext context,
    required FocusNode focusNode,
    required Widget suffixIcon,
    required String hintText,
    required TextEditingController textEditingController,
    required bool isObscure,
    required TextInputAction textInputAction,
    required onChanged,
    required onTap,
    required onFieldSubmitted}) {
  return Container(
    margin: const EdgeInsets.only(right: 15, left: 15, bottom: 8, top: 8),
    child: TextFormField(
        focusNode: focusNode,
        onChanged: (value) {
          onChanged(value);
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
        onFieldSubmitted: (value) {
          onFieldSubmitted(value);
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
