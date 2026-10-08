// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : LoginResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_LoginResponseData _$LoginResponseDataFromJson(Map<String, dynamic> json) =>
    _LoginResponseData(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseDataToJson(_LoginResponseData instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'user': instance.user,
    };
