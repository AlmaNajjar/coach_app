import 'package:coach_app/features/home/domain/entities/coach_subscriber.dart';

abstract class CoachSubscribersRepository {
  Future<CoachSubscribersData> getCurrentCoachSubscribers();
}