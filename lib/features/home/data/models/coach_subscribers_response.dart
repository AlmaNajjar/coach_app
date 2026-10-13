import 'package:coach_app/features/home/domain/entities/coach_subscriber.dart';

class CoachSubscribersResponse {
  const CoachSubscribersResponse({required this.data});

  final CoachSubscribersData data;

  factory CoachSubscribersResponse.fromJson(Map<String, dynamic> json) {
    final root = _asStringMap(json['data']);
    if (root == null) {
      throw const FormatException(
        'Coach subscribers response has no data object.',
      );
    }

    // 1) المصفوفة المسطحة
    final rawList = <dynamic>[];
    final flat = root['all_subscriptions'];
    if (flat is List) rawList.addAll(flat);

    // 2) fallback: نجمعها من الخطط
    if (rawList.isEmpty) {
      final plans = root['plans'];
      if (plans is List) {
        for (final plan in plans) {
          final planMap = _asStringMap(plan);
          final subs = planMap?['subscriptions'];
          if (subs is List) rawList.addAll(subs);
        }
      }
    }

    final subscribers = rawList
        .map(_asStringMap)
        .whereType<Map<String, dynamic>>()
        .map(_subscriberFromJson)
        .toList(growable: false);

    final summary = _asStringMap(root['summary']);
    final activeFallback = subscribers
        .where((s) => s.status == SubscriptionStatus.active)
        .length;

    return CoachSubscribersResponse(
      data: CoachSubscribersData(
        subscribers: subscribers,
        totalSubscribers:
            _intValue(summary?['total_subscribers']) ?? subscribers.length,
        activeSubscribers:
            _intValue(summary?['total_active_subscribers']) ?? activeFallback,
      ),
    );
  }

  static CoachSubscriber _subscriberFromJson(Map<String, dynamic> json) {
    final firstName = _stringValue(json['first_name']);
    final lastName = _stringValue(json['last_name']);

    return CoachSubscriber(
      id: _intValue(json['subscription_id'] ?? json['id']) ?? 0,
      memberName: _firstNonEmpty([
            json['member_name'],
            json['full_name'],
            [firstName, lastName].whereType<String>().join(' '),
          ]) ??
          '—',
      memberNumber: _stringValue(json['member_number']),
      phone: _firstNonEmpty([json['phone'], json['phone_number']]),
      photoUrl: _stringValue(json['photo_url']),
      planName: _stringValue(json['plan_name']),
      status: _statusValue(json['subscription_status'] ?? json['status']),
      startDate: _dateValue(json['start_date']),
      endDate: _dateValue(json['end_date']),
      totalAmount: _doubleValue(json['total_amount']),
      paidAmount: _doubleValue(json['paid_amount']),
      remainingAmount: _doubleValue(json['remaining_amount']),
      currency: _stringValue(json['currency']) ?? '',
    );
  }

  static SubscriptionStatus _statusValue(dynamic value) {
    switch (value?.toString().trim().toLowerCase()) {
      case 'active':
        return SubscriptionStatus.active;
      case 'pending':
        return SubscriptionStatus.pending;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'cancelled':
      case 'canceled':
        return SubscriptionStatus.cancelled;
      default:
        return SubscriptionStatus.unknown;
    }
  }

  static Map<String, dynamic>? _asStringMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return (text.isEmpty || text == 'null') ? null : text;
  }

  static String? _firstNonEmpty(Iterable<dynamic> values) {
    for (final value in values) {
      final text = _stringValue(value);
      if (text != null) return text;
    }
    return null;
  }

  static int? _intValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static double _doubleValue(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _dateValue(dynamic value) {
    final text = _stringValue(value);
    return text == null ? null : DateTime.tryParse(text);
  }
}