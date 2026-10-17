class ClientModel {
  final int id;
  final String name;
  final String? phone;
  final String? photoUrl;
  final String planName;
  final String? startDate;

  final String? endDate;
  final String status;
  final int sessionsAllocated;
  final int sessionsConsumed;

  const ClientModel({
    required this.id,
    required this.name,
    this.phone,
    this.startDate,
    this.endDate,
    this.photoUrl,
    required this.planName,
    required this.status,
    this.sessionsAllocated = 0,
    this.sessionsConsumed = 0,
  });

  // حساب نسبة شريط الإنجاز تلقائياً (من 0.0 إلى 1.0)
  double get progress {
    final lower = status.toLowerCase();
    if (lower == 'finished' || lower == 'completed' || lower == 'منتهي') {
      return 1.0;
    }
    if (sessionsAllocated <= 0) return 0.0;
    return (sessionsConsumed / sessionsAllocated).clamp(0.0, 1.0);
  }

  // قراءة وتحويل الـ JSON القادم من /v1/coaches/private-subscriptions
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    // 1. استخراج اسم المشترك
    final String clientName =
        json['member_name']?.toString() ??
        json['full_name']?.toString() ??
        (json['first_name'] != null
            ? '${json['first_name']} ${json['last_name'] ?? ''}'.trim()
            : 'متدرب');

    // 2. استخراج رقم الهاتف ورابط الصورة
    final String? clientPhone =
        json['phone']?.toString() ?? json['phone_number']?.toString();
    final String? clientPhoto = json['photo_url']?.toString();

    // 3. استخراج الجلسات (المحددة والمستهلكة)
    final int allocated = (json['sessions_allocated'] as num?)?.toInt() ?? 0;
    final int consumed = (json['sessions_consumed'] as num?)?.toInt() ?? 0;
    final String? clientEndDate = json['end_date']?.toString();
    final String? clientStartDate = json['start_date']?.toString();

    // 4. استخراج معرّف العضو / الاشتراك
    final int memberId =
        (json['member_id'] as num?)?.toInt() ??
        (json['subscription_id'] as num?)?.toInt() ??
        (json['id'] as num?)?.toInt() ??
        0;

    return ClientModel(
      id: memberId,
      name: clientName,
      phone: clientPhone,
      photoUrl: clientPhoto,
      planName: json['plan_name']?.toString() ?? 'تدريب خاص',
      status:
          json['subscription_status']?.toString() ??
          json['status']?.toString() ??
          'active',
      sessionsAllocated: allocated,
      sessionsConsumed: consumed,
      endDate: clientEndDate,
      startDate: clientStartDate,
    );
  }
}
