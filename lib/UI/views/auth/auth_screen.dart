import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/hex.dart';
import 'package:kemsu_app/UI/views/auth/widgets/checkbox.dart';
import 'package:kemsu_app/UI/views/auth/widgets/text_field.dart';
import '../../../Configurations/localizable.dart';
import '../../../domain/repositories/authorization/abstract_auth_repository.dart';
import '../../common_views/main_button.dart';
import 'auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AuthScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _twoFactorCodeController = TextEditingController();
  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _authBloc = AuthBloc(
    const AuthState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );

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
            // if (state.isTwoFactorEnter) {
            //   return Center(
            //       child: Container(
            //     child: Column(
            //       children: [Text(Localizable.twoFactorDescription), TextField()],
            //     ),
            //   ));
            // }

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
                    if (state.isTwoFactorEnter) ...[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: const Offset(0, 5),
                                blurRadius: 16.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 24.0),
                              Text(
                                Localizable.twoFactorDescription,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: TextField(
                                  controller: _twoFactorCodeController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Проверочный код',
                                    hintStyle: const TextStyle(fontSize: 14.0),
                                    fillColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? HexColor('#232325') : HexColor('#f2f3f5'),
                                    filled: true,
                                    contentPadding: const EdgeInsets.only(left: 15, top: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24.0),
                              mainButton(context, onPressed: () {
                                _authBloc.add(AuthByCode(code: _twoFactorCodeController.text, login: _loginController.text));
                              }, title: Localizable.authButtonTitle, isPrimary: true),
                              const SizedBox(height: 24.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (!state.isTwoFactorEnter) ...[
                      AuthTextField(
                          context: context,
                          focusNode: _loginFocus,
                          suffixIcon: (_loginController.text.isNotEmpty && (_loginFocus.hasFocus || _passwordFocus.hasFocus)
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
                          },
                          onTap: () {
                            _authBloc.add(UpdateLoginTextFieldEvent(login: state.login));
                          },
                          onFieldSubmitted: (finalLogin) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                            _authBloc.add(UpdateLoginTextFieldEvent(login: finalLogin));
                          }),
                      AuthTextField(
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
                          },
                          onTap: () {
                            _authBloc.add(UpdatePasswordTextFieldEvent(password: state.password));
                          },
                          onFieldSubmitted: (finalPassword) {
                            _authBloc.add(UpdatePasswordTextFieldEvent(password: finalPassword));
                            _passwordFocus.unfocus();
                          }),
                      // AuthCheckbox(state: state, bloc: _authBloc),
                      const SizedBox(
                        height: 24.0,
                      ),
                      mainButton(context, onPressed: () {
                        _authBloc.add(PostAuthEvents(_loginController.text, _passwordController.text, context));
                      }, title: Localizable.authButtonTitle, isPrimary: true),
                    ]
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
