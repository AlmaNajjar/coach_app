import 'package:coach_app/features/clients/data/datasource/measurements_remote_data_source.dart';
import 'package:coach_app/features/clients/data/models/measurement_request.dart';
import 'package:coach_app/features/clients/domain/entities/measurement_input.dart';
import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';
import 'package:coach_app/features/clients/domain/repo/measurements_repo.dart';

class MeasurementsRepositoryImpl implements MeasurementsRepository {
  const MeasurementsRepositoryImpl(this._remoteDataSource);

  final MeasurementsRemoteDataSource _remoteDataSource;

  @override
  Future<MeasurementsPage> getMeasurements({
    int page = 1,
    int? memberId,
  }) async {
    final response = await _remoteDataSource.getMeasurements(
      page: page,
      memberId: memberId,
    );
    return response.page;
  }

  @override
  Future<MemberMeasurement> getMeasurementById(int id) async {
    final response = await _remoteDataSource.getMeasurementById(id);
    return response.measurement;
  }

  @override
  Future<MemberMeasurement> addMeasurement(MeasurementInput input) async {
    final response = await _remoteDataSource.addMeasurement(input.toJson());
    return response.measurement;
  }

  @override
  Future<MemberMeasurement> updateMeasurement(
    int id,
    MeasurementInput input,
  ) async {
    final response = await _remoteDataSource.updateMeasurement(
      id,
      input.toJson(),
    );
    return response.measurement;
  }
}