// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      success: json['success'] as bool,
      userInfo: UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'success': instance.success,
      'userInfo': instance.userInfo,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      middleName: json['middleName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      userType: json['userType'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'email': instance.email,
      'phone': instance.phone,
      'userType': instance.userType,
    };
