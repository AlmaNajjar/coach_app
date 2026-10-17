import 'package:coach_app/features/clients/domain/entities/health_profile_entity.dart';

abstract class HealthProfileState {}

class HealthProfileInitial extends HealthProfileState {}

class HealthProfileLoading extends HealthProfileState {}

class HealthProfileLoaded extends HealthProfileState {
  final HealthProfileEntity? profile;
  HealthProfileLoaded(this.profile);
}

class HealthProfileSaving extends HealthProfileState {}

class HealthProfileSaveSuccess extends HealthProfileState {
  final HealthProfileEntity savedProfile;
  HealthProfileSaveSuccess(this.savedProfile);
}

class HealthProfileError extends HealthProfileState {
  final String message;
  HealthProfileError(this.message);
}
