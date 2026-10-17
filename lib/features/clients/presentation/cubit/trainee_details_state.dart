import 'package:coach_app/features/clients/domain/entities/member_measurement.dart';

abstract class TraineeDetailsState {}

class TraineeDetailsInitial extends TraineeDetailsState {}

class TraineeDetailsLoading extends TraineeDetailsState {}

class TraineeDetailsLoaded extends TraineeDetailsState {
  final MemberMeasurement? latestMeasurement;
  TraineeDetailsLoaded(this.latestMeasurement);
}

class TraineeDetailsSaving extends TraineeDetailsState {}

class TraineeDetailsSaveSuccess extends TraineeDetailsState {}

class TraineeDetailsError extends TraineeDetailsState {
  final String message;
  TraineeDetailsError(this.message);
}
