import '../../data/models/member_shift_model.dart';

abstract class MemberShiftsRepository {
  // 1. تثبيت جدول الشهر
  Future<List<MemberShiftModel>> createShiftSchedule(
    CreateShiftScheduleRequest request,
  );

  // 2. جلب قائمة المواعيد
  Future<List<MemberShiftModel>> getMemberShifts(int memberId, {String? month});

  // 3. جلب بيانات التقويم (الرزنامة)
  Future<Map<String, dynamic>> getShiftsCalendar(
    int memberId, {
    required String month,
  });
}
