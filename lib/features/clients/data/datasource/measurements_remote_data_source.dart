import 'package:coach_app/core/networking/api_constants.dart';
import 'package:coach_app/features/clients/data/models/measurement_response.dart';
import 'package:coach_app/features/clients/data/models/measurements_response.dart';
import 'package:dio/dio.dart';

abstract class MeasurementsRemoteDataSource {
  Future<MeasurementsResponse> getMeasurements({int page = 1, int? memberId});

  Future<MeasurementResponse> getMeasurementById(int id);

  Future<MeasurementResponse> addMeasurement(Map<String, dynamic> body);

  Future<MeasurementResponse> updateMeasurement(
    int id,
    Map<String, dynamic> body,
  );
}

class MeasurementsRemoteDataSourceImpl implements MeasurementsRemoteDataSource {
  const MeasurementsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MeasurementsResponse> getMeasurements({
    int page = 1,
    int? memberId,
  }) async {
    final response = await _dio.get(
      ApiConstants.memberMeasurements,
      queryParameters: {
        'page': page,
        // TODO: تأكد من اسم البارامتر مع الباك
        if (memberId != null) 'member_id': memberId,
      },
    );
    return MeasurementsResponse.fromJson(_asMap(response.data));
  }

  @override
  Future<MeasurementResponse> getMeasurementById(int id) async {
    final response = await _dio.get(ApiConstants.memberMeasurementById(id));
    return MeasurementResponse.fromJson(_asMap(response.data));
  }

  @override
  Future<MeasurementResponse> addMeasurement(Map<String, dynamic> body) async {
    final response = await _dio.post(
      ApiConstants.memberMeasurements,
      data: body,
    );
    return MeasurementResponse.fromJson(_asMap(response.data));
  }

  @override
  Future<MeasurementResponse> updateMeasurement(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put(
      ApiConstants.memberMeasurementById(id),
      data: body,
    );
    return MeasurementResponse.fromJson(_asMap(response.data));
  }

  Map<String, dynamic> _asMap(dynamic body) {
    if (body is! Map) {
      throw const FormatException('Invalid measurements response.');
    }
    return Map<String, dynamic>.from(body);
  }
}