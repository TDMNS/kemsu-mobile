import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/common_widgets.dart';
import 'package:kemsu_app/UI/views/profile_bloc/edit/edit_bloc.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

enum EditType { email, password, phone }

TextEditingController oldPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
TextEditingController newRepeatPasswordController = TextEditingController();

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
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    _editBloc.add(OnInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        oldPasswordController.clear();
        newPasswordController.clear();
        newRepeatPasswordController.clear();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: customAppBar(context, Localizable.editTitle),
        body: BlocBuilder<EditBloc, EditState>(
            bloc: _editBloc,
            builder: (context, state) {
              if (state.userData.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }
              emailController.text = state.userData.requiredContent.userInfo.email ?? '';
              phoneController.text = state.userData.requiredContent.userInfo.phone ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 12.0),
                    Center(
                      child: Container(
                        height: 84.0,
                        width: 84.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(64.0), color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                        '${state.userData.requiredContent.userInfo.lastName} ${state.userData.requiredContent.userInfo.firstName} ${state.userData.requiredContent.userInfo.middleName}'),
                    const SizedBox(height: 16.0),
                    ProfileEditField(type: EditType.email),
                    const SizedBox(height: 12.0),
                    ProfileEditField(type: EditType.phone),
                    const SizedBox(height: 16.0),
                    ProfileEditField(
                      type: EditType.password,
                      error: state.error,
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
                          value: state.twoFactorAuth,
                          onChanged: (bool value) => _editBloc.add(
                            TwoFactorAuthSwitch(twoFactorValue: value),
                          ),
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
      case EditType.phone:
        fieldName = 'Телефон';
        icon = Icons.phone;
        break;
    }

    return InkWell(
      onTap: () {
        switch (type) {
          case EditType.email:
            break;
          case EditType.password:
            _showChangePasswordAlert(context, error: error ?? '', onTap: onTap!);
            break;
          case EditType.phone:
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

void _showChangePasswordAlert(BuildContext context, {required String error, required VoidCallback onTap}) {
  bool obscureOldPass = true;
  bool obscureNewPass = true;
  bool obscureNewRepPass = true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
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
                if (error.isNotEmpty)
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: onTap, // Вызываем функцию onTap при нажатии кнопки "Сохранить"
                  child: const Text(
                    'Сохранить',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      });
    },
  );
}
