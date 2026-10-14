import 'package:coach_app/features/clients/domain/entities/measurement_input.dart';

extension MeasurementInputJson on MeasurementInput {
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'member_id': memberId,
      'measurement_date': _formatDate(measurementDate),
      'weight': weight,
      'height': height,
      'neck_circumference': neckCircumference,
      'shoulder_circumference': shoulderCircumference,
      'chest_circumference': chestCircumference,
      'waist_circumference': waistCircumference,
      'hip_circumference': hipCircumference,
      'buttocks_circumference': buttocksCircumference,
      'right_thigh_mid': rightThighMid,
      'left_thigh': leftThigh,
      'above_right_knee': aboveRightKnee,
      'above_left_knee': aboveLeftKnee,
      'right_calf': rightCalf,
      'left_calf': leftCalf,
      'right_bicep': rightBicep,
      'left_bicep': leftBicep,
      'arm_circumference': armCircumference,
      'physical_activity_level': physicalActivityLevel,
    };
    map.removeWhere((_, value) => value == null);
    return map;
  }

  static String? _formatDate(DateTime? d) {
    if (d == null) return null;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year.toString().padLeft(4, '0')}-$m-$day';
  }
}