import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:stacked/stacked.dart';

import '../../widgets.dart';
import 'edit_view_model.dart';

class EditView extends StatefulWidget {
  const EditView({Key? key}) : super(key: key);

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.onReady(),
      viewModelBuilder: () => EditViewModel(context),
      builder: (context, model, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, model, "Редактировать"),
              body: model.circle
                  ? Container(
                color: Theme.of(context).primaryColor,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                ),
              )
                  : _editView(context, model),
            ),
          ),
        );
      },
    );
  }
}

Widget _editView(BuildContext context, EditViewModel model) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Реализуйте функциональность смены аватара
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 55,
                    child: InkWell(
                      onTap: () {
                        // avatarChoice(context, model);
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(55.0)),
                        child: model.file != null ? Image.file(model.file!, fit: BoxFit.cover, width: 120, height: 120) : const Icon(Icons.person, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // avatarChoice(context, model);
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 14,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: model.emailController,
              onSubmitted: (newEmail) {
                model.updateEmail(newEmail);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Номер телефона'),
              controller: model.phoneController,
              onSubmitted: (newPhoneNumber) {
                model.updatePhoneNumber(newPhoneNumber);
              },
            ),
            const SizedBox(height: 32),
            mainButton(context, onPressed: () {
              /// here will be some action
            }, title: 'Сменить пароль', isPrimary: false)
          ],
        ),
      ]
    ),
  );
}



