import 'package:coach_app/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import '../models/coach_private_subscriptions_response.dart';

abstract interface class CoachProfileRemoteDataSource {
  Future<CoachPrivateSubscriptionsResponse> getCurrentCoachProfile();
  Future<int> getExpiringSoonCount();
}

class CoachProfileRemoteDataSourceImpl implements CoachProfileRemoteDataSource {
  const CoachProfileRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CoachPrivateSubscriptionsResponse> getCurrentCoachProfile() async {
    final response = await _dio.get(ApiConstants.coachPrivateSubscriptions);
    if (response.data is! Map) {
      throw const FormatException(
        'Coach subscriptions response must be a JSON object.',
      );
    }

    return CoachPrivateSubscriptionsResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<int> getExpiringSoonCount() async {
    final Response = await _dio.get(
      ApiConstants.playerSubscriptions,
      queryParameters: {'status': 'expiring_soon'},
    );
    print('EXPIRING RESPONSE: ${Response.data}');
    final list = Response.data['data'];
    if (list is List) {
      return list.length;
    }
    return 0;
  }
}
