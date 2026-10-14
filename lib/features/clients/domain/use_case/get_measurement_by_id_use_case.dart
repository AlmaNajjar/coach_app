import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';
import 'package:coach_app/features/clients/domain/repo/measurements_repo.dart';

class GetMeasurementByIdUseCase {
  const GetMeasurementByIdUseCase(this._repository);

  final MeasurementsRepository _repository;

  Future<MemberMeasurement> call(int id) => _repository.getMeasurementById(id);
}