import 'package:coach_app/features/clients/data/datasource/health_profile_remote_data_source.dart';
import 'package:coach_app/features/clients/data/models/health_profile_model.dart';
import 'package:coach_app/features/clients/domain/entities/health_profile_entity.dart';
import 'package:coach_app/features/clients/domain/repo/health_profile_repo.dart';

class HealthProfileRepositoryImpl implements HealthProfileRepository {
  final HealthProfileRemoteDataSource _remoteDataSource;

  const HealthProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<HealthProfileEntity?> getHealthProfile(int memberId) {
    return _remoteDataSource.getHealthProfile(memberId);
  }

  @override
  Future<HealthProfileEntity> saveHealthProfile(HealthProfileEntity profile) {
    final model = HealthProfileModel(
      id: profile.id,
      memberId: profile.memberId,
      allergies: profile.allergies,
      organicDiseases: profile.organicDiseases,
      physicalInjuries: profile.physicalInjuries,
      medications: profile.medications,
      bloodType: profile.bloodType,
      emergencyContactName: profile.emergencyContactName,
      emergencyContactPhone: profile.emergencyContactPhone,
      emergencyContactCountryCode: profile.emergencyContactCountryCode,
      sportGoal: profile.sportGoal,
      fitnessLevel: profile.fitnessLevel,
    );
    return _remoteDataSource.saveHealthProfile(model);
  }
}
