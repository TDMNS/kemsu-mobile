import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/common_widgets.dart';
import 'package:kemsu_app/UI/views/profile_bloc/edit/edit_bloc.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum EditType { email, password, twoFactor }

TextEditingController oldPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
TextEditingController newRepeatPasswordController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController twoFactorCodeController = TextEditingController();

void _clearControllers() {
  oldPasswordController.clear();
  newPasswordController.clear();
  newRepeatPasswordController.clear();
  twoFactorCodeController.clear();
}

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _editBloc = EditBloc(
    const EditState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );

  @override
  void initState() {
    _editBloc.add(OnInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: customAppBar(context, Localizable.editTitle),
        body: BlocBuilder<EditBloc, EditState>(
            bloc: _editBloc,
            builder: (context, state) {
              if (state.userInfo.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }

              emailController.text = state.userInfo.requiredContent.email ?? '';
              phoneController.text = state.userInfo.requiredContent.phone ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 12.0),
                    Center(
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.white.withOpacity(0.4),
                        child: state.avatar.isEmpty ? Image.asset('images/avatar1.png') : ClipOval(child: Image.network(state.avatar, width: 200, height: 200, fit: BoxFit.cover)),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text('${state.userInfo.content?.lastName} ${state.userInfo.content?.firstName} ${state.userInfo.content?.middleName}'),
                    const SizedBox(height: 16.0),
                    ProfileEditField(
                      type: EditType.email,
                      error: state.error.errorText,
                      onTap: () => _editBloc.add(
                        ChangeEmail(
                          email: emailController.text,
                          password: oldPasswordController.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ProfileEditField(
                      type: EditType.password,
                      error: state.error.errorText,
                      onTap: () => _editBloc.add(
                        ChangePassword(oldPassword: oldPasswordController.text, newPassword: newPasswordController.text, newRepPassword: newRepeatPasswordController.text),
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Localizable.twoFactorAuth, style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0)),
                        Switch(
                          activeColor: Colors.green,
                          value: state.twoFactorAuthConfirmed,
                          onChanged: (bool value) {
                            if (state.twoFactorAuthConfirmed) {
                              _editBloc.add(DisableTwoFactorAuth());
                            } else {
                              _editBloc.add(EnableTwoFactorAuth());
                              _showTwoFactorAuthAlert(context, onTap: () => _editBloc.add(ConfirmTwoFactorAuth(code: twoFactorCodeController.text)));
                            }

                            // _editBloc.add(
                            //   TwoFactorAuthSwitch(twoFactorValue: value),
                            // );
                          },
                        ),
                      ],
                    ),
                    // CupertinoSwitch(value: state.twoFactorAuth, onChanged: (bool val) {})
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class ProfileEditField extends StatelessWidget {
  const ProfileEditField({
    super.key,
    required this.type,
    this.error,
    this.onTap,
  });

  final EditType type;
  final String? error;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String fieldName;
    IconData icon;

    switch (type) {
      case EditType.email:
        fieldName = 'E-mail';
        icon = Icons.email;
        break;
      case EditType.password:
        fieldName = 'Сменить пароль';
        icon = Icons.lock;
        break;
      case EditType.twoFactor:
        fieldName = 'Двухфакторная аутентификация';
        icon = Icons.lock_outline;
        break;
        break;
    }

    return InkWell(
      onTap: () {
        switch (type) {
          case EditType.email:
            _showChangeEmailAlert(context, error: error ?? '', onTap: onTap!);
            break;
          case EditType.password:
            _showChangePasswordAlert(context, onTap: onTap!);
            break;
          case EditType.twoFactor:
            _showTwoFactorAuthAlert(context, onTap: onTap!);
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fieldName,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
                ),
                Icon(
                  icon,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

void _showChangeEmailAlert(BuildContext context, {required String error, required VoidCallback onTap}) {
  final editBloc = EditBloc(
    const EditState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );
  showDialog(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (_) => editBloc,
        child: AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Смена Email',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    suffixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: oldPasswordController,
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    suffixIcon: Icon(Icons.password),
                  ),
                ),
                const SizedBox(height: 16.0),
                BlocBuilder<EditBloc, EditState>(
                  builder: (context, state) {
                    if (state.isSuccess) {
                      return const Text(
                        'Email успешно изменён',
                        style: TextStyle(color: Colors.green),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                if (error.isNotEmpty)
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: onTap,
                  child: const Text(
                    'Сохранить',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  ).then((_) => _clearControllers());
}

void _showChangePasswordAlert(BuildContext context, {required VoidCallback onTap}) {
  bool obscureOldPass = true;
  bool obscureNewPass = true;
  bool obscureNewRepPass = true;
  final editBloc = EditBloc(
    const EditState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );

  showDialog(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (_) => editBloc,
        child: StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Смена  пароля',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: obscureOldPass,
                    decoration: InputDecoration(
                      hintText: 'Старый пароль',
                      suffixIcon: IconButton(
                        icon: Icon(obscureOldPass ? Icons.visibility : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            obscureOldPass = !obscureOldPass;
                          });
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: obscureNewPass,
                    decoration: InputDecoration(
                      hintText: 'Новый пароль',
                      suffixIcon: IconButton(
                        icon: Icon(obscureNewPass ? Icons.visibility : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            obscureNewPass = !obscureNewPass;
                          });
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: newRepeatPasswordController,
                    obscureText: obscureNewRepPass,
                    decoration: InputDecoration(
                      hintText: 'Повторите пароль',
                      suffixIcon: IconButton(
                        icon: Icon(obscureNewRepPass ? Icons.visibility : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            obscureNewRepPass = !obscureNewRepPass;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  BlocBuilder<EditBloc, EditState>(
                    builder: (context, state) {
                      if (state.isSuccess) {
                        return const Text(
                          'Пароль успешно изменён',
                          style: TextStyle(color: Colors.green),
                        );
                      }
                      if (state.error != ErrorType.noError) {
                        return Text(
                          state.error.errorText,
                          style: const TextStyle(color: Colors.red),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<EditBloc>(context).add(
                        ChangePassword(
                          oldPassword: oldPasswordController.text,
                          newPassword: newPasswordController.text,
                          newRepPassword: newRepeatPasswordController.text,
                        ),
                      );
                    },
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    },
  ).then((_) => _clearControllers());
}

void _showTwoFactorAuthAlert(BuildContext context, {required VoidCallback onTap}) {
  final editBloc = EditBloc(
    const EditState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );

  showDialog(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (_) => editBloc,
        child: StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'На ваш Email был отправлен проверочный код',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                TextField(
                  controller: twoFactorCodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Проверочный код'),
                ),
                BlocBuilder<EditBloc, EditState>(
                  builder: (context, state) {
                    if (state.twoFactorError.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Text(
                          state.twoFactorError,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: onTap,
                  child: const Text(
                    'Продолжить',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    },
  ).then((_) => _clearControllers());
}
