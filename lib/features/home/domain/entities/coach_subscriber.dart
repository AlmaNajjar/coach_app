enum SubscriptionStatus { active, pending, expired, cancelled, unknown }

class CoachSubscriber {
  const CoachSubscriber({
    required this.id,
    required this.memberName,
    required this.status,
    this.memberNumber,
    this.phone,
    this.photoUrl,
    this.planName,
    this.startDate,
    this.endDate,
    this.totalAmount = 0,
    this.paidAmount = 0,
    this.remainingAmount = 0,
    this.currency = '',
  });

  final int id;
  final String memberName;
  final SubscriptionStatus status;
  final String? memberNumber;
  final String? phone;
  final String? photoUrl;
  final String? planName;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String currency;

  bool get hasRemaining => remainingAmount > 0;
}

class CoachSubscribersData {
  const CoachSubscribersData({
    required this.subscribers,
    required this.totalSubscribers,
    required this.activeSubscribers,
  });

  final List<CoachSubscriber> subscribers;
  final int totalSubscribers;
  final int activeSubscribers;
}