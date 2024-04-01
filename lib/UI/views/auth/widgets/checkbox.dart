import 'package:flutter/material.dart';

import '../../../../Configurations/localizable.dart';
import '../auth_bloc.dart';

class AuthCheckbox extends StatelessWidget {
  const AuthCheckbox({
    super.key,
    required this.state,
    required this.bloc
  });

  final AuthState state;
  final AuthBloc bloc;

  @override
  Widget build(BuildContext context) {
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
}