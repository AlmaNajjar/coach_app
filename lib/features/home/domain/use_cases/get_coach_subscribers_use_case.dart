import 'package:coach_app/features/home/domain/entities/coach_subscriber.dart';
import 'package:coach_app/features/home/domain/repositories/coach_subscribers_repository.dart';

class GetCoachSubscribersUseCase {
  const GetCoachSubscribersUseCase(this._repository);

  final CoachSubscribersRepository _repository;

  Future<CoachSubscribersData> call() =>
      _repository.getCurrentCoachSubscribers();
}