import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/common_widgets.dart';
import 'package:kemsu_app/UI/views/profile_bloc/profile_bloc.dart';
import 'package:kemsu_app/UI/views/profile_bloc/widgets/menu_tile.dart';
import 'package:kemsu_app/UI/views/profile_bloc/widgets/profile_add_info.dart';
import 'package:kemsu_app/UI/views/profile_bloc/widgets/profile_toolbar.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Configurations/navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final bool needUpdate;
  final _profileBloc = ProfileBloc(
    const ProfileState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );

  @override
  void initState() {
    _profileBloc.add(OnInit());
    Future.delayed(const Duration(seconds: 2), () => needUpdate = _profileBloc.state.needUpdate);
    _inAppReview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, Localizable.mainTitle),
      body: Builder(builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (needUpdate) {
            _showUpdateAlert();
          }
        });
        return BlocBuilder<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            builder: (context, state) {
              if (state.studCard.isLoading && state.empCard.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }

              final studMenuTilesFiltered = Map.of(studMenuTiles);
              final studRoutesFiltered = List.of(studRoutes);

              if (state.isTestUser) {
                studMenuTilesFiltered.remove(Localizable.mainPayment);
                studRoutesFiltered.remove(AppRouting.toPayment);
              }

              return Stack(
                children: [
                  ListView(
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      ProfileToolbar(
                        showAddInfo: () => _profileBloc.add(ShowAddInfo(isShow: true)),
                        userInfo: state.userData.content,
                        studCard: state.studCard.content,
                        empCard: state.empCard.content,
                        avatar: state.avatar,
                      ),
                      const SizedBox(height: 16.0),
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: state.userData.requiredContent.currentUserType == UserType.student
                            ? studMenuTilesFiltered.length
                            : teacherMenuTiles.length,
                        itemBuilder: (context, index) {
                          final entry = state.userData.requiredContent.currentUserType == UserType.student
                              ? studMenuTilesFiltered.entries.toList()[index]
                              : teacherMenuTiles.entries.toList()[index];
                          final title = entry.key;
                          final iconPath = entry.value;
                          return MenuTile(
                            title: title,
                            iconPath: iconPath,
                            onTap: state.userData.requiredContent.currentUserType == UserType.student
                                ? studRoutesFiltered[index]
                                : teacherRoutes[index],
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                  if (state.showAddInfo)
                    ProfileAdditionalInformation(
                      closeInfo: () => _profileBloc.add(ShowAddInfo(isShow: false)),
                      userData: state.userData.content,
                      studCard: state.studCard.content,
                      empCard: state.empCard.content,
                      avatar: state.avatar,
                    ),
                ],
              );
            });
      }),
    );
  }

  void _showUpdateAlert() {
    String link = Platform.isIOS
        ? 'https://apps.apple.com/ru/app/%D0%BA%D0%B5%D0%BC%D0%B3%D1%83/id6444271769'
        : 'https://www.kemsu.ru/education/app-kemsu/';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            title: Text(Localizable.mainUpdateTitle),
            content: Text(Localizable.mainUpdateContent),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await launchUrl(Uri.parse(link));
                  } catch (e) {
                    throw 'Could not launch ${Uri.parse(link)}';
                  }
                },
                child: Text(Localizable.mainUpdateButtonTitle),
              )
            ],
          );
        });
  }

  Future<void> _inAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      Future.delayed(const Duration(seconds: 2), () {
        inAppReview.requestReview();
      });
    }
  }
}
