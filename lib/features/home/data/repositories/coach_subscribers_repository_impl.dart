import 'package:coach_app/features/home/data/datasources/coach_subscribers_remote_data_source.dart';
import 'package:coach_app/features/home/domain/entities/coach_subscriber.dart';
import 'package:coach_app/features/home/domain/repositories/coach_subscribers_repository.dart';

class CoachSubscribersRepositoryImpl implements CoachSubscribersRepository {
  const CoachSubscribersRepositoryImpl(this._remoteDataSource);

  final CoachSubscribersRemoteDataSource _remoteDataSource;

  @override
  Future<CoachSubscribersData> getCurrentCoachSubscribers() async {
    final response = await _remoteDataSource.getCurrentCoachSubscribers();
    return response.data;
  }
}