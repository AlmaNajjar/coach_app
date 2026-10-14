import 'package:coach_app/features/clients/domain/entities/measurement_input.dart';
import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';
import 'package:coach_app/features/clients/domain/repo/measurements_repo.dart';

class AddMeasurementUseCase {
  const AddMeasurementUseCase(this._repository);

  final MeasurementsRepository _repository;

  static const double minWeight = 20;
  static const double maxWeight = 300;

  Future<MemberMeasurement> call(MeasurementInput input) {
    if (input.memberId == null) {
      throw const FormatException('Please select a player first.');
    }
    final weight = input.weight;
    if (weight == null) {
      throw const FormatException('Weight is required.');
    }
    if (weight < minWeight || weight > maxWeight) {
      throw const FormatException(
        'Weight must be between 20 and 300 kg.',
      );
    }
    return _repository.addMeasurement(input);
  }
}