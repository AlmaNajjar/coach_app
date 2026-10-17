class HealthProfileEntity {
  final int? id;
  final int memberId;
  final String? allergies;
  final String? organicDiseases;
  final String? physicalInjuries;
  final String? medications;
  final String? bloodType;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactCountryCode;
  final String? sportGoal;
  final String? fitnessLevel;

  const HealthProfileEntity({
    this.id,
    required this.memberId,
    this.allergies,
    this.organicDiseases,
    this.physicalInjuries,
    this.medications,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactCountryCode = '+963',
    this.sportGoal,
    this.fitnessLevel,
  });
}
