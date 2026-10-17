import 'package:coach_app/features/clients/domain/entities/health_profile_entity.dart';

abstract class HealthProfileRepository {
  Future<HealthProfileEntity?> getHealthProfile(int memberId);
  Future<HealthProfileEntity> saveHealthProfile(HealthProfileEntity profile);
}
