import '../../data/datasource/member_shifts_remote_data_source.dart';
import '../../data/models/member_shift_model.dart';
import 'member_shifts_repo.dart';

class MemberShiftsRepositoryImpl implements MemberShiftsRepository {
  final MemberShiftsRemoteDataSource _remoteDataSource;

  const MemberShiftsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<MemberShiftModel>> createShiftSchedule(
    CreateShiftScheduleRequest request,
  ) {
    return _remoteDataSource.createShiftSchedule(request);
  }

  @override
  Future<List<MemberShiftModel>> getMemberShifts(
    int memberId, {
    String? month,
  }) {
    return _remoteDataSource.getMemberShifts(memberId, month: month);
  }

  @override
  Future<Map<String, dynamic>> getShiftsCalendar(
    int memberId, {
    required String month,
  }) {
    return _remoteDataSource.getShiftsCalendar(memberId, month: month);
  }
}
