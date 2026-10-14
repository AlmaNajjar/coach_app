import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';

class MeasurementsResponse {
  const MeasurementsResponse({required this.page});

  final MeasurementsPage page;

  /// الشكل المتوقع: { data: { current_page, last_page, total, data: [ ... ] } }
  factory MeasurementsResponse.fromJson(Map<String, dynamic> json) {
    final paginated = _asMap(json['data']);
    if (paginated == null) {
      throw const FormatException('Measurements response has no data object.');
    }

    final rawItems = paginated['data'];
    if (rawItems != null && rawItems is! List) {
      throw const FormatException('Measurements data must be a list.');
    }

    final items = (rawItems as List? ?? const [])
        .map(_asMap)
        .whereType<Map<String, dynamic>>()
        .map(measurementFromJson)
        .toList(growable: false);

    return MeasurementsResponse(
      page: MeasurementsPage(
        items: items,
        currentPage: _int(paginated['current_page']) ?? 1,
        lastPage: _int(paginated['last_page']) ?? 1,
        total: _int(paginated['total']) ?? items.length,
      ),
    );
  }

  static MemberMeasurement measurementFromJson(Map<String, dynamic> json) {
    return MemberMeasurement(
      id: _int(json['id']) ?? 0,
      memberId: _int(json['member_id']),
      measurementDate: _date(json['measurement_date']),
      weight: _double(json['weight']),
      height: _double(json['height']),
      bodyFatPercentage: _double(json['body_fat_percentage']),
      muscleMass: _double(json['muscle_mass']),
      waistCircumference: _double(json['waist_circumference']),
      neckCircumference: _double(json['neck_circumference']),
      shoulderCircumference: _double(json['shoulder_circumference']),
      rightBicep: _double(json['right_bicep']),
      leftBicep: _double(json['left_bicep']),
      hipCircumference: _double(json['hip_circumference']),
      chestCircumference: _double(json['chest_circumference']),
      rightThighMid: _double(json['right_thigh_mid']),
      leftThigh: _double(json['left_thigh']),
      rightCalf: _double(json['right_calf']),
      leftCalf: _double(json['left_calf']),
      fatFreeMassPercentage: _double(json['fat_free_mass_percentage']),
      bmi: _double(json['bmi']),
      bodyWaterPercentage: _double(json['body_water_percentage']),
      restingMetabolicRate: _double(json['resting_metabolic_rate']),
      totalDailyEnergyExpenditure:
          _double(json['total_daily_energy_expenditure']),
      physicalActivityLevel: _string(json['physical_activity_level']),
      buttocksCircumference: _double(json['buttocks_circumference']),
      aboveRightKnee: _double(json['above_right_knee']),
      aboveLeftKnee: _double(json['above_left_knee']),
      armCircumference: _double(json['arm_circumference']),
      lastUpdatedAt: _date(json['last_updated_at'] ?? json['updated_at']),
    );
  }

  // ───────────── Safe parsers ─────────────
  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String? _string(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return (text.isEmpty || text == 'null') ? null : text;
  }

  static int? _int(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static double? _double(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static DateTime? _date(dynamic value) {
    final text = _string(value);
    return text == null ? null : DateTime.tryParse(text);
  }
}