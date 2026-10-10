import '../entities/coach_profile.dart';

abstract interface class CoachProfileRepository {
  Future<CoachProfile> getCurrentCoachProfile();
}
