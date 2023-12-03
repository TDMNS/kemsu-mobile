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
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();

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
  void dispose() {
    _loginFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
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
                    _customTextField(
                        context: context,
                        focusNode: _loginFocus,
                        suffixIcon: (_loginController.text.isNotEmpty && _loginFocus.hasFocus
                            ? IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  _authBloc.add(UpdateLoginTextFieldEvent(login: ''));
                                  _loginController.clear();
                                })
                            : const SizedBox()),
                        hintText: Localizable.authLogin,
                        textEditingController: state.login.isNotEmpty ? (_loginController..text = state.login) : _loginController,
                        isObscure: false,
                        textInputAction: TextInputAction.next,
                        onChanged: (changedLogin) {
                          _authBloc.add(UpdateLoginTextFieldEvent(login: changedLogin));
                          _loginController.text = changedLogin;
                        },
                        onTap: () {
                          _authBloc.add(UpdateLoginTextFieldEvent(login: state.login));
                          _loginController.text = state.login;
                        },
                        onFieldSubmitted: (finalLogin) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                          _authBloc.add(UpdateLoginTextFieldEvent(login: finalLogin));
                          _loginController.text = finalLogin;
                        }),
                    _customTextField(
                        context: context,
                        focusNode: _passwordFocus,
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _passwordController.text.isNotEmpty
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
                        textEditingController: state.password.isNotEmpty ? (_passwordController..text = state.password) : _passwordController,
                        isObscure: state.isObscure,
                        textInputAction: TextInputAction.done,
                        onChanged: (changedPassword) {
                          _authBloc.add(UpdatePasswordTextFieldEvent(password: changedPassword));
                          _passwordController.text = changedPassword;
                        },
                        onTap: () {
                          _authBloc.add(UpdatePasswordTextFieldEvent(password: state.password));
                          _passwordController.text = state.password;
                        },
                        onFieldSubmitted: (finalPassword) {
                          _authBloc.add(UpdatePasswordTextFieldEvent(password: finalPassword));
                          _passwordController.text = finalPassword;
                          _passwordFocus.unfocus();
                        }),
                    _profileCheckBox(state: state, bloc: _authBloc),
                    mainButton(context, onPressed: () {
                      _authBloc.add(PostAuthEvents(_loginController.text, _passwordController.text, context));

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
                    }, title: Localizable.authButtonTitle, isPrimary: true),
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
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
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

_customAlert(BuildContext context) {
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
