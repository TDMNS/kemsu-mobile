// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      success: json['success'] as bool,
      userInfo: UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'success': instance.success,
      'userInfo': instance.userInfo,
      'accessToken': instance.accessToken,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['id'] as int,
      login: json['login'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      job: json['job'],
      org: json['org'],
      sciGrad: json['sciGrad'],
      sciName: json['sciName'],
      town: json['town'] as String,
      country: json['country'] as String,
      homePhone: json['homePhone'],
      fax: json['fax'],
      keywords: json['keywords'],
      messages: json['messages'] as int,
      address: json['address'],
      userType: json['userType'] as String,
      blocked: json['blocked'] as int,
      twoFactorAuth: json['twoFactorAuth'] as bool,
      twoFactorAuthConfirmed: json['twoFactorAuthConfirmed'] as bool,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'email': instance.email,
      'phone': instance.phone,
      'job': instance.job,
      'org': instance.org,
      'sciGrad': instance.sciGrad,
      'sciName': instance.sciName,
      'town': instance.town,
      'country': instance.country,
      'homePhone': instance.homePhone,
      'fax': instance.fax,
      'keywords': instance.keywords,
      'messages': instance.messages,
      'address': instance.address,
      'userType': instance.userType,
      'blocked': instance.blocked,
      'twoFactorAuth': instance.twoFactorAuth,
      'twoFactorAuthConfirmed': instance.twoFactorAuthConfirmed,
    };
