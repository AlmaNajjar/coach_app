import 'package:coach_app/features/home/domain/entities/coach_profile.dart';
import 'package:coach_app/features/home/domain/repositories/coach_profile_repository.dart';
import '../datasources/coach_profile_remote_data_source.dart';

class CoachProfileRepositoryImpl implements CoachProfileRepository {
  const CoachProfileRepositoryImpl(this._remoteDataSource);

  final CoachProfileRemoteDataSource _remoteDataSource;

  @override
  Future<CoachProfile> getCurrentCoachProfile() async {
    final response = await _remoteDataSource.getCurrentCoachProfile();
    return response.coach;
  }
}
