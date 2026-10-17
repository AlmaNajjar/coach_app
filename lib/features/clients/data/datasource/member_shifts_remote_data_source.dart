import 'package:dio/dio.dart';
import '../../../../core/networking/api_constants.dart';
import '../models/member_shift_model.dart';

abstract class MemberShiftsRemoteDataSource {
  // 1. توليد وتثبيت جدول دوام الشهر
  Future<List<MemberShiftModel>> createShiftSchedule(
    CreateShiftScheduleRequest request,
  );

  // 2. جلب قائمة مواعيد لاعب محدد
  Future<List<MemberShiftModel>> getMemberShifts(int memberId, {String? month});

  // 3. جلب مواعيد التقويم (الرزنامة) للشهر
  Future<Map<String, dynamic>> getShiftsCalendar(
    int memberId, {
    required String month,
  });
}

class MemberShiftsRemoteDataSourceImpl implements MemberShiftsRemoteDataSource {
  final Dio _dio;

  const MemberShiftsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<MemberShiftModel>> createShiftSchedule(
    CreateShiftScheduleRequest request,
  ) async {
    final response = await _dio.post(
      ApiConstants.memberShiftsSchedule,
      data: request.toJson(),
    );

    final data = response.data['data'];
    if (data != null && data['shifts'] != null) {
      final List shiftsJson = data['shifts'];
      return shiftsJson.map((e) => MemberShiftModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<MemberShiftModel>> getMemberShifts(
    int memberId, {
    String? month,
  }) async {
    final response = await _dio.get(
      ApiConstants.memberShifts,
      queryParameters: {
        'member_id': memberId,
        if (month != null) 'month': month,
      },
    );

    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => MemberShiftModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<Map<String, dynamic>> getShiftsCalendar(
    int memberId, {
    required String month,
  }) async {
    final response = await _dio.get(
      ApiConstants.memberShiftsCalendar,
      queryParameters: {'member_id': memberId, 'month': month},
    );

    return response.data['data'] ?? {};
  }
}
