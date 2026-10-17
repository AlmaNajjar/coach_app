class MemberShiftModel {
  final int id;
  final int memberId;
  final String date;
  final int dayOfWeek;
  final String dayNameAr;
  final String dayNameEn;
  final String startTime;
  final String? endTime;
  final String scheduleType;
  final String? month;
  final String status;
  final String? notes;

  const MemberShiftModel({
    required this.id,
    required this.memberId,
    required this.date,
    required this.dayOfWeek,
    required this.dayNameAr,
    required this.dayNameEn,
    required this.startTime,
    this.endTime,
    required this.scheduleType,
    this.month,
    required this.status,
    this.notes,
  });

  factory MemberShiftModel.fromJson(Map<String, dynamic> json) {
    return MemberShiftModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      memberId: (json['member_id'] as num?)?.toInt() ?? 0,
      date: json['date']?.toString() ?? '',
      dayOfWeek: (json['day_of_week'] as num?)?.toInt() ?? 0,
      dayNameAr: json['day_name_ar']?.toString() ?? '',
      dayNameEn: json['day_name_en']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString(),
      scheduleType: json['schedule_type']?.toString() ?? 'custom',
      month: json['month']?.toString(),
      status: json['status']?.toString() ?? 'scheduled',
      notes: json['notes']?.toString(),
    );
  }
}

// 2. كائن الطلب (Request) الذي نرسله للباك إند لتوليد وتثبيت جدول الشهر
class CreateShiftScheduleRequest {
  final int memberId;
  final String scheduleType;
  final String month;
  final List<int>? selectedDays;
  final String startTime;
  final String? endTime;
  final bool overwrite;
  final String? notes;

  const CreateShiftScheduleRequest({
    required this.memberId,
    required this.scheduleType,
    required this.month,
    this.selectedDays,
    required this.startTime,
    this.endTime,
    this.overwrite = true,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'member_id': memberId,
      'schedule_type': scheduleType,
      'month': month,
      if (selectedDays != null && selectedDays!.isNotEmpty)
        'selected_days': selectedDays,
      'start_time': startTime,
      if (endTime != null && endTime!.isNotEmpty) 'end_time': endTime,
      'overwrite': overwrite,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

// مساعدة ذكية لتحويل أسماء الأيام لأرقام يفهمها السيرفر (0: الأحد .. 6: السبت)
extension ShiftDayHelper on String {
  int toDayInt() {
    switch (this) {
      case 'Sun':
        return 0;
      case 'Mon':
        return 1;
      case 'Tue':
        return 2;
      case 'Wed':
        return 3;
      case 'Thu':
        return 4;
      case 'Fri':
        return 5;
      case 'Sat':
        return 6;
      default:
        return 0;
    }
  }
}
