import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel extends Equatable {
  final bool success;
  final UserInfo userInfo;
  final String accessToken;

  const AuthModel({
    required this.success,
    required this.userInfo,
    required this.accessToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthModelToJson(this);

  @override
  List<Object?> get props => [
        success,
        userInfo,
        accessToken,
      ];
}

@JsonSerializable()
class UserInfo extends Equatable {
  final int id;
  final String login;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? email;
  final String? phone;
  final String? job;
  final String? org;
  final String? sciGrad;
  final String? sciName;
  final String? town;
  final String? country;
  final String? homePhone;
  final String? fax;
  final String? keywords;
  final int? messages;
  final String? address;
  final String userType;
  final int blocked;
  final bool twoFactorAuth;
  final bool twoFactorAuthConfirmed;

  String get fullName => '$lastName $firstName $middleName';

  const UserInfo({
    required this.id,
    required this.login,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.phone,
    required this.job,
    required this.org,
    required this.sciGrad,
    required this.sciName,
    required this.town,
    required this.country,
    required this.homePhone,
    required this.fax,
    required this.keywords,
    required this.messages,
    required this.address,
    required this.userType,
    required this.blocked,
    required this.twoFactorAuth,
    required this.twoFactorAuthConfirmed,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  @override
  List<Object?> get props => [
        id,
        login,
        firstName,
        lastName,
        middleName,
        email,
        phone,
        job,
        org,
        sciGrad,
        sciName,
        town,
        country,
        homePhone,
        fax,
        keywords,
        messages,
        address,
        userType,
        blocked,
        twoFactorAuth,
        twoFactorAuthConfirmed,
      ];
}
