import 'package:coach_app/features/home/domain/entities/coach_subscriber.dart';

enum CoachSubscribersStatus { initial, loading, success, failure }

class CoachSubscribersState {
  const CoachSubscribersState({
    this.status = CoachSubscribersStatus.initial,
    this.subscribers = const [],
    this.totalSubscribers = 0,
    this.activeSubscribers = 0,
    this.errorMessage,
  });

  final CoachSubscribersStatus status;
  final List<CoachSubscriber> subscribers;
  final int totalSubscribers;
  final int activeSubscribers;
  final String? errorMessage;

  bool get isFirstLoad =>
      status == CoachSubscribersStatus.initial ||
      status == CoachSubscribersStatus.loading;

  CoachSubscribersState copyWith({
    CoachSubscribersStatus? status,
    List<CoachSubscriber>? subscribers,
    int? totalSubscribers,
    int? activeSubscribers,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CoachSubscribersState(
      status: status ?? this.status,
      subscribers: subscribers ?? this.subscribers,
      totalSubscribers: totalSubscribers ?? this.totalSubscribers,
      activeSubscribers: activeSubscribers ?? this.activeSubscribers,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}