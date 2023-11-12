import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kemsu_app/Configurations/hex.dart';
import 'package:kemsu_app/UI/common_views/capitalize_first_letter.dart';
import 'package:kemsu_app/UI/views/profile/profile_provider.dart';
import 'package:kemsu_app/UI/views/profile/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../Configurations/localizable.dart';
import '../../common_views/main_button.dart';
import '../../common_views/profile_tiles.dart';
import '../../widgets.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.onReady(context),
      viewModelBuilder: () => ProfileViewModel(context),
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: model.circle
                ? Container(
                    color: Theme.of(context).primaryColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : Scaffold(
                    extendBody: true,
                    extendBodyBehindAppBar: true,
                    appBar: customAppBar(context, Localizable.mainTitle),
                    body: _profileView(context, model),
                  ),
          ),
        );
      },
    );
  }

  avatarChoice(context, ProfileViewModel model) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        title: Text(Localizable.mainChoosePhoto),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                mainButton(context, onPressed: () {
                  _getFromGallery(model);
                  Navigator.pop(context, Localizable.ok);
                }, title: Localizable.mainGallery, isPrimary: true),
                const SizedBox(
                  height: 15,
                ),
                mainButton(context, onPressed: () {
                  _getFromCamera(model);
                  Navigator.pop(context, Localizable.ok);
                }, title: Localizable.mainCamera, isPrimary: false),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getFromGallery(ProfileViewModel model) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        model.imageFile = File(pickedFile.path);
      });
      model.saveImage();
    }
  }

  _getFromCamera(ProfileViewModel model) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        model.imageFile = File(pickedFile.path);
      });
      model.saveImage();
    }
  }

  _profileView(BuildContext context, ProfileViewModel model) {
    List<Widget> tiles = [];
    tiles = [
      profileTiles(context, onPressed: () {
        model.navigateMoodleWebView(context, model);
      }, title: Localizable.mainMoodle, imageSource: 'images/icons/moodle.png'),
    ];
    if (model.userType == EnumUserType.student) {
      tiles += [
        profileTiles(context, onPressed: () {
          model.navigateRosScreen(context);
        }, title: Localizable.mainRos, imageSource: 'images/icons/search.png'),
        profileTiles(context, onPressed: () {
          model.navigateInfoView(context);
        }, title: Localizable.mainInfo, imageSource: 'images/icons/book.png'),
        profileTiles(context, onPressed: () {
          model.navigatePgasScreen(context);
        }, title: Localizable.mainPgas, imageSource: 'images/icons/invoice.png'),
        profileTiles(context, onPressed: () {
          model.navigateDebtsView(context);
        }, title: Localizable.mainDebts, imageSource: 'images/icons/exclamation_circle.png'),
        profileTiles(context, onPressed: () {
          model.navigateOrderingInformationMainView(context);
        }, title: Localizable.mainOrderingInformation, imageSource: 'images/icons/group.png'),
        profileTiles(context, onPressed: () {
          model.navigateCheckListView(context);
        }, title: Localizable.mainCheckList, imageSource: 'images/icons/layers.png')
      ];
    }
    tiles += [
      profileTiles(context, onPressed: () {
        model.navigatePaymentWebView(context, model);
      }, title: Localizable.mainPayment, imageSource: 'images/icons/money.png'),
      profileTiles(context, onPressed: () {
        model.navigateMainBugReportScreen(context);
      }, title: Localizable.mainSupport, imageSource: 'images/icons/shield.png')
    ];

    List<Widget> moreViews = [];

    moreViews += [
      Text(Localizable.mainDetails,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center),
      const SizedBox(height: 5),
    ];
    if (model.userType == EnumUserType.student) {
      moreViews += [
        Text(model.speciality,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            textAlign: TextAlign.center),
        const SizedBox(height: 5),
        Text(model.faculty,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            textAlign: TextAlign.center),
        const SizedBox(height: 5),
      ];
    }
    moreViews += [
      if (model.learnForm.isNotEmpty)
        Text(
          '${model.learnForm} форма обучения',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      const SizedBox(height: 5),
      if (model.finForm.isNotEmpty)
        Text(
          '${capitalizeFirstLetter(model.finForm)} форма финансирования',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      if (model.department.isNotEmpty)
        SizedBox(
          width: 300,
          child: Text(
            model.department,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      const SizedBox(height: 5),
      Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, child) {
          return Text(
            userProfileProvider.email.isNotEmpty ? userProfileProvider.email : "Почта не указана",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
      const SizedBox(height: 5),
      Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, child) {
          return Text(
            userProfileProvider.phone.isNotEmpty ? userProfileProvider.phone : "Номер телефона не указан",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          );
        },
      )
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: model.isExpanded ? 550 : 350,            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [HexColor("#DC1554"), Colors.blueAccent, Theme.of(context).colorScheme.background],
                stops: const [0.5, 0.95, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      const SizedBox(height: 75),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 55,
                            child: InkWell(
                              onTap: () {
                                // avatarChoice(context, model);
                                model.navigateEditScreen(context);
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
                              model.navigateEditScreen(context);
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 14,
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('${model.lastName} ${model.firstName} ${model.middleName}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22), textAlign: TextAlign.center),
                      const SizedBox(height: 5),
                      Text(model.userType == EnumUserType.student ? Localizable.mainStudent : Localizable.mainTeacher,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
                      const SizedBox(height: 5),
                      Text(model.userType == EnumUserType.student ? model.group : model.faculty,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
                      const SizedBox(height: 30),
                      Visibility(
                        visible: model.isExpanded,
                        child: Column(
                          children: moreViews,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 20,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        model.isExpanded = !model.isExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(24.0),
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            model.isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.white,
                            size: 24.0,
                            key: ValueKey<bool>(model.isExpanded),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          Localizable.mainMore,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
                padding: EdgeInsets.zero,
                childAspectRatio: 1.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: tiles),
          ),
          const SizedBox(height: 20),
          Center(
              child: mainButton(
            context,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  title: Text(Localizable.mainWarning, textAlign: TextAlign.center),
                  actions: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          mainButton(context, onPressed: () {
                            Navigator.pop(context);
                          }, title: Localizable.cancel, isPrimary: true),
                          const SizedBox(height: 15),
                          mainButton(context, onPressed: () {
                            model.exit(context);
                          }, title: Localizable.yes, isPrimary: false),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            title: Localizable.mainExit,
            isPrimary: false,
          )),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
