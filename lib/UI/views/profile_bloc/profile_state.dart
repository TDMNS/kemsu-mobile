part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool showAddInfo;
  final Lce<UserInfo> userData;
  final Lce<StudCardModel> studCard;
  final Lce<EmpCardModel> empCard;
  final String avatar;
  final bool needUpdate;
  final bool isTestUser;

  const ProfileState({
    this.isLoading = true,
    this.showAddInfo = false,
    this.userData = const Lce.loading(),
    this.studCard = const Lce.loading(),
    this.empCard = const Lce.loading(),
    this.avatar = '',
    this.needUpdate = false,
    this.isTestUser = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? showAddInfo,
    Lce<UserInfo>? userData,
    Lce<StudCardModel>? studCard,
    Lce<EmpCardModel>? empCard,
    String? avatar,
    bool? needUpdate,
    bool? isTestUser,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      showAddInfo: showAddInfo ?? this.showAddInfo,
      userData: userData ?? this.userData,
      studCard: studCard ?? this.studCard,
      empCard: empCard ?? this.empCard,
      avatar: avatar ?? this.avatar,
      needUpdate: needUpdate ?? this.needUpdate,
      isTestUser: isTestUser ?? this.isTestUser,
    );
  }

  @override
  List<Object?> get props => [isLoading, showAddInfo, userData, studCard, empCard, avatar, needUpdate, isTestUser];
}

final Map<String, String> studMenuTiles = {
  Localizable.mainRos: 'images/icons/search.png',
  Localizable.mainInfo: 'images/icons/book.png',
  Localizable.mainDebts: 'images/icons/exclamation_circle.png',
  Localizable.mainOrderingInformation: 'images/icons/group.png',
  Localizable.mainCheckList: 'images/icons/layers.png',
  Localizable.mainPayment: 'images/icons/money.png',
  Localizable.mainSupport: 'images/icons/shield.png',
  Localizable.pageCourses: 'images/icons/courses.png',
};

final List<void Function()> studRoutes = [
  AppRouting.toRos,
  AppRouting.toInfOUPro,
  AppRouting.toDebts,
  AppRouting.toOrderInformation,
  AppRouting.toCheckList,
  AppRouting.toPayment,
  AppRouting.toSupport,
  AppRouting.toCourses,
];

final Map<String, String> teacherMenuTiles = {
  Localizable.mainPayment: 'images/icons/money.png',
  Localizable.mainSupport: 'images/icons/shield.png',
};

final List<void Function()> teacherRoutes = [
  AppRouting.toPayment,
  AppRouting.toSupport,
];

enum UserType {
  student('обучающийся'),
  teacher('сотрудник');

  final String typeName;

  const UserType(this.typeName);
}
