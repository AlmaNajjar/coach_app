import 'package:coach_app/core/networking/api_constants.dart';
import 'package:coach_app/features/home/data/models/coach_subscribers_response.dart';
import 'package:dio/dio.dart';

abstract class CoachSubscribersRemoteDataSource {
  Future<CoachSubscribersResponse> getCurrentCoachSubscribers();
}

class CoachSubscribersRemoteDataSourceImpl
    implements CoachSubscribersRemoteDataSource {
  const CoachSubscribersRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CoachSubscribersResponse> getCurrentCoachSubscribers() async {
    final response = await _dio.get(ApiConstants.coachPrivateSubscriptions);

    final body = response.data;
    if (body is! Map) {
      throw const FormatException('Invalid coach subscribers response.');
    }
    return CoachSubscribersResponse.fromJson(Map<String, dynamic>.from(body));
  }
}