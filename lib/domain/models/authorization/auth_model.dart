import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "userInfo")
  final UserInfo userInfo;
  @JsonKey(name: "accessToken")
  final String accessToken;

  AuthModel({
    required this.success,
    required this.userInfo,
    required this.accessToken,
  });

  AuthModel copyWith({
    bool? success,
    UserInfo? userInfo,
    String? accessToken,
  }) =>
      AuthModel(
        success: success ?? this.success,
        userInfo: userInfo ?? this.userInfo,
        accessToken: accessToken ?? this.accessToken,
      );

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}

@JsonSerializable()
class UserInfo {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "login")
  final String login;
  @JsonKey(name: "firstName")
  final String firstName;
  @JsonKey(name: "lastName")
  final String lastName;
  @JsonKey(name: "middleName")
  final String middleName;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "phone")
  final String phone;
  @JsonKey(name: "job")
  final dynamic job;
  @JsonKey(name: "org")
  final dynamic org;
  @JsonKey(name: "sciGrad")
  final dynamic sciGrad;
  @JsonKey(name: "sciName")
  final dynamic sciName;
  @JsonKey(name: "town")
  final String town;
  @JsonKey(name: "country")
  final String country;
  @JsonKey(name: "homePhone")
  final dynamic homePhone;
  @JsonKey(name: "fax")
  final dynamic fax;
  @JsonKey(name: "keywords")
  final dynamic keywords;
  @JsonKey(name: "messages")
  final int messages;
  @JsonKey(name: "address")
  final dynamic address;
  @JsonKey(name: "userType")
  final String userType;
  @JsonKey(name: "blocked")
  final int blocked;
  @JsonKey(name: "twoFactorAuth")
  final bool twoFactorAuth;
  @JsonKey(name: "twoFactorAuthConfirmed")
  final bool twoFactorAuthConfirmed;

  UserInfo({
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

  UserInfo copyWith({
    int? id,
    String? login,
    String? firstName,
    String? lastName,
    String? middleName,
    String? email,
    String? phone,
    dynamic job,
    dynamic org,
    dynamic sciGrad,
    dynamic sciName,
    String? town,
    String? country,
    dynamic homePhone,
    dynamic fax,
    dynamic keywords,
    int? messages,
    dynamic address,
    String? userType,
    int? blocked,
    bool? twoFactorAuth,
    bool? twoFactorAuthConfirmed,
  }) =>
      UserInfo(
        id: id ?? this.id,
        login: login ?? this.login,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        job: job ?? this.job,
        org: org ?? this.org,
        sciGrad: sciGrad ?? this.sciGrad,
        sciName: sciName ?? this.sciName,
        town: town ?? this.town,
        country: country ?? this.country,
        homePhone: homePhone ?? this.homePhone,
        fax: fax ?? this.fax,
        keywords: keywords ?? this.keywords,
        messages: messages ?? this.messages,
        address: address ?? this.address,
        userType: userType ?? this.userType,
        blocked: blocked ?? this.blocked,
        twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
        twoFactorAuthConfirmed: twoFactorAuthConfirmed ?? this.twoFactorAuthConfirmed,
      );

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
