class ClientModel {
  final int id;
  final String name;
  final String? phone;
  final String? photoUrl;
  final String planName;
  final String status;
  final int sessionsAllocated;
  final int sessionsConsumed;

  const ClientModel({
    required this.id,
    required this.name,
    this.phone,
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

  // قراءة وتحويل الـ JSON القادم من /v1/player-subscriptions
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    // 1. استخراج بيانات المتدرب من كائن member -> person
    final member = json['member'] as Map<String, dynamic>?;
    final person = member?['person'] as Map<String, dynamic>?;

    final String clientName =
        person?['full_name']?.toString() ??
        member?['username']?.toString() ??
        'متدرب';

    final String? clientPhone = person?['phone']?.toString();
    final String? clientPhoto =
        person?['photo_url']?.toString() ?? member?['photo_url']?.toString();

    // 2. استخراج الجلسات من قائمة items
    int allocated = 0;
    int consumed = 0;
    final items = json['items'] as List<dynamic>?;
    if (items != null && items.isNotEmpty) {
      final firstItem = items.first as Map<String, dynamic>?;
      allocated = (firstItem?['sessions_allocated'] as num?)?.toInt() ?? 0;
      consumed = (firstItem?['sessions_consumed'] as num?)?.toInt() ?? 0;
    }

    return ClientModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: clientName,
      phone: clientPhone,
      photoUrl: clientPhoto,
      planName: json['plan_name']?.toString() ?? 'تدريب عام',
      status:
          json['status_label']?.toString() ??
          json['status']?.toString() ??
          'Active',
      sessionsAllocated: allocated,
      sessionsConsumed: consumed,
    );
  }
}
