import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';
import 'package:coach_app/features/clients/domain/repo/measurements_repo.dart';

class GetMemberMeasurementsUseCase {
  const GetMemberMeasurementsUseCase(this._repository);

  final MeasurementsRepository _repository;

  Future<MeasurementsPage> call({int page = 1, int? memberId}) =>
      _repository.getMeasurements(page: page, memberId: memberId);
}