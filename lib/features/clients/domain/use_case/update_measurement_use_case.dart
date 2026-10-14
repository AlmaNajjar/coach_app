import 'package:coach_app/features/clients/domain/entities/measurement_input.dart';
import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';
import 'package:coach_app/features/clients/domain/repo/measurements_repo.dart';
import 'package:coach_app/features/clients/domain/use_case/add_measurement_use_case.dart';

class UpdateMeasurementUseCase {
  const UpdateMeasurementUseCase(this._repository);

  final MeasurementsRepository _repository;

  Future<MemberMeasurement> call(int id, MeasurementInput input) {
    final weight = input.weight;
    if (weight != null &&
        (weight < AddMeasurementUseCase.minWeight ||
            weight > AddMeasurementUseCase.maxWeight)) {
      throw const FormatException(
        'Weight must be between 20 and 300 kg.',
      );
    }
    return _repository.updateMeasurement(id, input);
  }
}