import 'package:coach_app/features/clients/data/models/measurements_response.dart';
import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';

class MeasurementResponse {
  const MeasurementResponse({required this.measurement});

  final MemberMeasurement measurement;

  factory MeasurementResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map) {
      throw const FormatException('Measurement response has no data object.');
    }
    return MeasurementResponse(
      measurement: MeasurementsResponse.measurementFromJson(
        Map<String, dynamic>.from(data),
      ),
    );
  }
}