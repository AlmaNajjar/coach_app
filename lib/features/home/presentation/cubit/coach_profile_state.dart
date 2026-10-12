import 'package:coach_app/features/home/domain/entities/coach_profile.dart';

enum CoachProfileStatus { initial, loading, success, failure }

class CoachProfileState {
  const CoachProfileState({
    this.status = CoachProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.expiringSoonCount = 0,
  });

  final CoachProfileStatus status;
  final CoachProfile? profile;
  final String? errorMessage;
  final int expiringSoonCount;

  bool get isLoading => status == CoachProfileStatus.loading;
}
