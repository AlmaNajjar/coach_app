import 'package:coach_app/features/clients/domain/entities/health_profile_entity.dart';

class HealthProfileModel extends HealthProfileEntity {
  final DateTime? createdAt;

  const HealthProfileModel({
    super.id,
    required super.memberId,
    super.allergies,
    super.organicDiseases,
    super.physicalInjuries,
    super.medications,
    super.bloodType,
    super.emergencyContactName,
    super.emergencyContactPhone,
    super.emergencyContactCountryCode = '+963',
    super.sportGoal,
    super.fitnessLevel,
    this.createdAt,
  });

  factory HealthProfileModel.fromJson(Map<String, dynamic> json) {
    return HealthProfileModel(
      id: (json['id'] as num?)?.toInt(),
      memberId: (json['member_id'] as num?)?.toInt() ?? 0,
      allergies: json['allergies']?.toString(),
      organicDiseases: json['organic_diseases']?.toString(),
      physicalInjuries: json['physical_injuries']?.toString(),
      medications: json['medications']?.toString(),
      bloodType: json['blood_type']?.toString(),
      emergencyContactName: json['emergency_contact_name']?.toString(),
      emergencyContactPhone: json['emergency_contact_phone']?.toString(),
      emergencyContactCountryCode:
          json['emergency_contact_country_code']?.toString() ?? '+963',
      sportGoal: json['sport_goal']?.toString(),
      fitnessLevel: json['fitness_level']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member_id': memberId,
      if (allergies != null && allergies!.isNotEmpty) 'allergies': allergies,
      if (organicDiseases != null && organicDiseases!.isNotEmpty)
        'organic_diseases': organicDiseases,
      if (physicalInjuries != null && physicalInjuries!.isNotEmpty)
        'physical_injuries': physicalInjuries,
      if (medications != null && medications!.isNotEmpty)
        'medications': medications,
      if (bloodType != null && bloodType!.isNotEmpty) 'blood_type': bloodType,
      if (emergencyContactName != null && emergencyContactName!.isNotEmpty)
        'emergency_contact_name': emergencyContactName,
      if (emergencyContactPhone != null && emergencyContactPhone!.isNotEmpty)
        'emergency_contact_phone': emergencyContactPhone,
      if (emergencyContactCountryCode != null)
        'emergency_contact_country_code': emergencyContactCountryCode,
      if (sportGoal != null && sportGoal!.isNotEmpty) 'sport_goal': sportGoal,
      if (fitnessLevel != null && fitnessLevel!.isNotEmpty)
        'fitness_level': fitnessLevel,
    };
  }
}
