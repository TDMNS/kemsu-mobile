import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kemsu_app/Configurations/hex.dart';
import 'package:kemsu_app/UI/common_views/capitalize_first_letter.dart';
import 'package:kemsu_app/UI/views/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../../Configurations/localizable.dart';
import '../../common_views/primary_button.dart';
import '../../common_views/profile_tiles.dart';
import '../../widgets.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

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
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              appBar: customAppBar(context, model, Localizable.mainTitle),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: model.isExpanded ? 525 : 325,
            width: MediaQuery.of(context).size.width,
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
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: InkWell(
                          onTap: () {
                            avatarChoice(context, model);
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                            child: model.file != null
                                ? Image.file(model.file!, fit: BoxFit.cover, width: 80, height: 80)
                                : const Icon(Icons.person, size: 80, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${model.lastName} ${model.firstName} ${model.middleName}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        model.userType == EnumUserType.student ? Localizable.mainStudent : Localizable.mainTeacher,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        model.userType == EnumUserType.student ? model.group : model.faculty,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 50),
                      Visibility(
                        visible: model.isExpanded,
                        child: Column(
                          children: [
                            Text(
                              Localizable.mainDetails,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              model.speciality,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${model.learnForm} форма обучения',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${capitalizeFirstLetter(model.finForm)} форма финансирования',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              model.email,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              model.phone,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 20,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            model.isExpanded = !model.isExpanded;
                          });
                        },
                        child: Icon(
                          model.isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.white,
                          size: 24.0
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
                children: [
                  profileTiles(context, onPressed: () {
                    model.navigateRosView(context, model);
                  }, title: Localizable.mainRos, imageSource: 'images/icons/search.png'),
                  profileTiles(context, onPressed: () {
                    model.navigatePgasScreen(context, model);
                  }, title: Localizable.mainPgas, imageSource: 'images/icons/invoice.png'),
                  profileTiles(context, onPressed: () {
                    model.navigateInfoView(context);
                  }, title: Localizable.mainInfo, imageSource: 'images/icons/book.png'),
                  profileTiles(context, onPressed: () {
                    model.navigateDebtsView(context);
                  }, title: Localizable.mainDebts, imageSource: 'images/icons/exclamation_circle.png'),
                  profileTiles(context, onPressed: () {
                    model.navigateOrderingInformationMainView(context);
                  }, title: Localizable.mainOrderingInformation, imageSource: 'images/icons/group.png'),
                  profileTiles(context, onPressed: () {
                    model.navigateCheckListView(context);
                  }, title: Localizable.mainCheckList, imageSource: 'images/icons/layers.png'),
                  profileTiles(context, onPressed: () {
                    model.navigateWebView(context, model);
                  }, title: Localizable.mainPayment, imageSource: 'images/icons/money.png'),
                  profileTiles(context, onPressed: () {
                    model.navigateMainBugReportScreen(context, model);
                  }, title: Localizable.mainSupport, imageSource: 'images/icons/shield.png'),
                ]),
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
