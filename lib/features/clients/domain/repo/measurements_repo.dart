import 'package:coach_app/features/clients/domain/entities/measurement_input.dart';
import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';

abstract class MeasurementsRepository {
  Future<MeasurementsPage> getMeasurements({int page = 1, int? memberId});

  Future<MemberMeasurement> getMeasurementById(int id);

  Future<MemberMeasurement> addMeasurement(MeasurementInput input);

  Future<MemberMeasurement> updateMeasurement(int id, MeasurementInput input);
}