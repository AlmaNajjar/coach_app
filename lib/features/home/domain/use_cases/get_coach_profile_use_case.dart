import '../entities/coach_profile.dart';
import '../repositories/coach_profile_repository.dart';

class GetCoachProfileUseCase {
  const GetCoachProfileUseCase(this._repository);

  final CoachProfileRepository _repository;

  Future<CoachProfile> call() => _repository.getCurrentCoachProfile();
}
