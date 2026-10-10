import 'package:coach_app/features/home/domain/entities/coach_profile.dart';

enum CoachProfileStatus { initial, loading, success, failure }

class CoachProfileState {
  const CoachProfileState({
    this.status = CoachProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  final CoachProfileStatus status;
  final CoachProfile? profile;
  final String? errorMessage;

  bool get isLoading => status == CoachProfileStatus.loading;
}
