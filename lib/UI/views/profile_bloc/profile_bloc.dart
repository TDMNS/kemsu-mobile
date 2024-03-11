import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:kemsu_app/UI/splash_screen.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/emp_card_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

part 'profile_events.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(super.initialState, {required this.authRepository}) {
    on<ShowAddInfo>(_showAddInfo);
    on<Logout>(_logout);
    on<LoadStudData>(_loadStudData);
    on<LoadEmpData>(_loadEmpData);
    on<OnInit>(_onInit);
  }

  final AbstractAuthRepository authRepository;

  Future<void> _showAddInfo(ShowAddInfo event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(showAddInfo: event.isShow));
  }

  Future<void> _logout(Logout event, Emitter<ProfileState> emit) async {
    await storage.delete(key: "tokenKey");
    AppRouting.toAuth();
  }

  Future<void> _onInit(OnInit event, Emitter<ProfileState> emit) async {
    var login = await storage.read(key: "login");
    var password = await storage.read(key: "password");
    await authRepository.postAuth(login: login ?? '', password: password ?? '');
    var userType = authRepository.userData.value.content?.userInfo.userType;
    UserType currentType = UserType.values.firstWhere((element) => element.typeName == userType);
    currentType == UserType.student ? add(LoadStudData()) : add(LoadEmpData());
  }

  Future<void> _loadStudData(LoadStudData event, Emitter<ProfileState> emit) async {
    var login = await storage.read(key: "login");
    var password = await storage.read(key: "password");
    if (login == 'stud00001' && password == 'cherrypie') {
      final userData = await authRepository.postAuth(login: login ?? '', password: password ?? '');
      emit(state.copyWith(userData: userData.asContent, studCard: const Lce(isLoading: false)));
    } else {
      final avatar = await authRepository.getUserAvatar();
      final studCard = await authRepository.getStudCardData();
      final userData = await authRepository.postAuth(login: login ?? '', password: password ?? '');
      emit(state.copyWith(studCard: studCard.asContent, userData: userData.asContent, avatar: avatar));
    }
  }

  Future<void> _loadEmpData(LoadEmpData event, Emitter<ProfileState> emit) async {
    var login = await storage.read(key: "login");
    var password = await storage.read(key: "password");
    final avatar = await authRepository.getUserAvatar();
    final empData = await authRepository.getEmpCardData();
    final userData = await authRepository.postAuth(login: login ?? '', password: password ?? '');
    emit(state.copyWith(empCard: empData.asContent, userData: userData.asContent, avatar: avatar));
  }
}
