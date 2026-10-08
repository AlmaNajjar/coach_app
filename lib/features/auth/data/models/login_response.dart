import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String status,
    required String message,
    LoginResponseData? data,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
abstract class LoginResponseData with _$LoginResponseData {
  const factory LoginResponseData({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'token_type') required String tokenType,
    required UserModel user,
  }) = _LoginResponseData;

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);
}
