import 'package:coach_app/core/networking/api_constants.dart';
import 'package:coach_app/features/clients/data/models/health_profile_model.dart';
import 'package:dio/dio.dart';

abstract class HealthProfileRemoteDataSource {
  Future<HealthProfileModel?> getHealthProfile(int memberId);
  Future<HealthProfileModel> saveHealthProfile(HealthProfileModel model);
}

class HealthProfileRemoteDataSourceImpl
    implements HealthProfileRemoteDataSource {
  final Dio _dio;
  const HealthProfileRemoteDataSourceImpl(this._dio);
  @override
  Future<HealthProfileModel?> getHealthProfile(int memberId) async {
    try {
      final response = await _dio.get(
        ApiConstants.memberHealthProfiles,
        queryParameters: {'member_id': memberId},
      );
      if (response.data != null && response.data['data'] != null) {
        final data = response.data['data'];
        if (data is List && data.isNotEmpty) {
          return HealthProfileModel.fromJson(
            Map<String, dynamic>.from(data.first),
          );
        } else if (data is Map) {
          return HealthProfileModel.fromJson(Map<String, dynamic>.from(data));
        }
      }
      return null;
    } catch (_) {
      return null; // إذا كان المشترك جديداً ولا يملك سجلاً بعد
    }
  }

  @override
  Future<HealthProfileModel> saveHealthProfile(HealthProfileModel model) async {
    final response = await _dio.post(
      ApiConstants.memberHealthProfiles,
      data: model.toJson(),
    );
    final data = response.data['data'] ?? response.data;
    return HealthProfileModel.fromJson(Map<String, dynamic>.from(data));
  }
}
