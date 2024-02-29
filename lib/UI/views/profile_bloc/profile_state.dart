part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool showAddInfo;
  final Lce<AuthModel> userData;
  final Lce<StudCardModel> studCard;
  final String avatar;

  const ProfileState({
    this.isLoading = true,
    this.showAddInfo = false,
    this.userData = const Lce.loading(),
    this.studCard = const Lce.loading(),
    this.avatar = '',
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? showAddInfo,
    Lce<AuthModel>? userData,
    Lce<StudCardModel>? studCard,
    String? avatar,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      showAddInfo: showAddInfo ?? this.showAddInfo,
      userData: userData ?? this.userData,
      studCard: studCard ?? this.studCard,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => [isLoading, showAddInfo, userData, studCard, avatar];
}

class EnumUserType {
  static String get student => "обучающийся";
  static String get employee => "сотрудник";
}
