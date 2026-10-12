import 'package:coach_app/core/networking/api_error_handler.dart';
import 'package:coach_app/features/home/domain/entities/coach_subscriber.dart';
import 'package:coach_app/features/home/domain/use_cases/get_coach_subscribers_use_case.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_subscribers_state.dart';

class CoachSubscribersCubit extends Cubit<CoachSubscribersState> {
  CoachSubscribersCubit(this._getCoachSubscribers)
      : super(const CoachSubscribersState());

  final GetCoachSubscribersUseCase _getCoachSubscribers;
  bool _isFetching = false;

  /// [silent] = pull-to-refresh: نحافظ على الداتا الحالية بدون skeleton
  Future<void> load({bool silent = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (!silent) {
      emit(state.copyWith(
        status: CoachSubscribersStatus.loading,
        clearError: true,
      ));
    }

    try {
      final data = await _getCoachSubscribers();
      if (isClosed) return;
      emit(state.copyWith(
        status: CoachSubscribersStatus.success,
        subscribers: _sorted(data.subscribers),
        totalSubscribers: data.totalSubscribers,
        activeSubscribers: data.activeSubscribers,
        clearError: true,
      ));
    } on DioException catch (error) {
      if (isClosed) return;
      emit(state.copyWith(
        status: CoachSubscribersStatus.failure,
        errorMessage: ErrorHandler.handle(error).failure.message,
      ));
    } on FormatException catch (error) {
      if (isClosed) return;
      emit(state.copyWith(
        status: CoachSubscribersStatus.failure,
        errorMessage: error.message,
      ));
    } on Exception catch (error, stackTrace) {
      debugPrint('Unexpected coach subscribers error: $error\n$stackTrace');
      if (isClosed) return;
      emit(state.copyWith(
        status: CoachSubscribersStatus.failure,
        errorMessage: 'Unable to load subscribers. Please try again.',
      ));
    } finally {
      _isFetching = false;
    }
  }

  /// الفعّالين أولاً ثم المعلّقين، وكل مجموعة الأحدث تاريخاً
  List<CoachSubscriber> _sorted(List<CoachSubscriber> list) {
    int rank(SubscriptionStatus s) => switch (s) {
          SubscriptionStatus.active => 0,
          SubscriptionStatus.pending => 1,
          _ => 2,
        };

    final sorted = [...list];
    sorted.sort((a, b) {
      final byRank = rank(a.status).compareTo(rank(b.status));
      if (byRank != 0) return byRank;
      return (b.startDate ?? DateTime(0)).compareTo(a.startDate ?? DateTime(0));
    });
    return sorted;
  }
}