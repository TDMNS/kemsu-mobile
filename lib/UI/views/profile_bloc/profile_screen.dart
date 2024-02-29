import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:kemsu_app/UI/common_views/main_button.dart';
import 'package:kemsu_app/UI/common_widgets.dart';
import 'package:kemsu_app/UI/views/profile_bloc/profile_bloc.dart';
import 'package:kemsu_app/UI/views/profile_bloc/widgets/menu_tile.dart';
import 'package:kemsu_app/UI/views/profile_bloc/widgets/profile_add_info.dart';
import 'package:kemsu_app/UI/views/profile_bloc/widgets/profile_toolbar.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileBloc = ProfileBloc(
    const ProfileState(),
    authRepository: GetIt.I<AbstractAuthRepository>(),
  );
  final Map<String, String> menuTiles = {
    Localizable.mainRos: 'images/icons/search.png',
    Localizable.mainInfo: 'images/icons/book.png',
    Localizable.mainDebts: 'images/icons/exclamation_circle.png',
    Localizable.mainOrderingInformation: 'images/icons/group.png',
    Localizable.mainCheckList: 'images/icons/layers.png',
    Localizable.mainPayment: 'images/icons/money.png',
    Localizable.mainSupport: 'images/icons/shield.png',
  };

  final List<void Function()> routes = [
    AppRouting.toRos,
    AppRouting.toInfOUPro,
    AppRouting.toDebts,
    AppRouting.toOrderInformation,
    AppRouting.toCheckList,
    AppRouting.toPayment,
    AppRouting.toSupport,
  ];

  @override
  void initState() {
    _profileBloc.add(LoadStudData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, Localizable.mainTitle),
      body: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          builder: (context, state) {
            if (state.studCard.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            return Stack(
              children: [
                ListView(
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    ProfileToolbar(
                      showAddInfo: () => _profileBloc.add(ShowAddInfo(isShow: true)),
                      userData: state.userData.content,
                      studCard: state.studCard.content,
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
                      itemCount: menuTiles.length,
                      itemBuilder: (context, index) {
                        final entry = menuTiles.entries.toList()[index];
                        final title = entry.key;
                        final iconPath = entry.value;
                        return MenuTile(
                          title: title,
                          iconPath: iconPath,
                          onTap: routes[index],
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    mainButton(
                      context,
                      onPressed: () => _profileBloc.add(Logout()),
                      title: Localizable.mainExit,
                      isPrimary: false,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
                if (state.showAddInfo)
                  ProfileAdditionalInformation(
                    closeInfo: () => _profileBloc.add(ShowAddInfo(isShow: false)),
                    userData: state.userData.content,
                    studCard: state.studCard.content,
                    avatar: state.avatar,
                  ),
              ],
            );
          }),
    );
  }
}
