import 'package:coach_app/features/auth/data/models/login_request.dart';
import 'package:coach_app/features/auth/data/models/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginRequest', () {
    test(
      'serializes the required credentials and omits absent optional data',
      () {
        const request = LoginRequest(
          username: 'coach@example.com',
          password: 'hashed-password',
        );

        expect(request.toJson(), {
          'username': 'coach@example.com',
          'password': 'hashed-password',
        });
      },
    );

    test('serializes optional device fields using backend keys', () {
      const request = LoginRequest(
        username: 'coach@example.com',
        password: 'hashed-password',
        fcmToken: 'device-token',
        deviceInfo: {'platform': 'android'},
      );

      expect(request.toJson(), {
        'username': 'coach@example.com',
        'password': 'hashed-password',
        'fcm_token': 'device-token',
        'device_info': {'platform': 'android'},
      });
    });
  });

  test('parses and preserves the backend user payload', () {
    final response = LoginResponse.fromJson({
      'status': 'success',
      'message': 'Signed in',
      'data': {
        'access_token': 'access-token',
        'token_type': 'Bearer',
        'user': {
          'id': 12,
          'name': 'Coach',
          'branch_id': 4,
          'custom_attribute': 'preserved',
        },
      },
    });

    expect(response.data?.accessToken, 'access-token');
    expect(response.data?.tokenType, 'Bearer');
    expect(response.data?.user.branchId, 4);
    expect(response.data?.user.toJson()['custom_attribute'], 'preserved');
  });
}
