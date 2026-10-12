import 'package:coach_app/core/networking/api_error_handler.dart';
import 'package:coach_app/features/home/data/datasources/coach_profile_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coach_app/features/home/domain/use_cases/get_coach_profile_use_case.dart';
import 'coach_profile_state.dart';

class CoachProfileCubit extends Cubit<CoachProfileState> {
  CoachProfileCubit(this._getCoachProfile, this._dataSource)
    : super(const CoachProfileState());

  final GetCoachProfileUseCase _getCoachProfile;
  final CoachProfileRemoteDataSource _dataSource;
  Future<void> load() async {
    if (state.isLoading) return;
    emit(const CoachProfileState(status: CoachProfileStatus.loading));

    try {
      final profile = await _getCoachProfile();
      final expiringCount = await _dataSource
          .getExpiringSoonCount(); // جلب العدد

      emit(
        CoachProfileState(
          status: CoachProfileStatus.success,
          profile: profile,
          expiringSoonCount: expiringCount,
        ),
      );
    } on DioException catch (error) {
      emit(
        CoachProfileState(
          status: CoachProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error).failure.message,
        ),
      );
    } on FormatException catch (error) {
      emit(
        CoachProfileState(
          status: CoachProfileStatus.failure,
          errorMessage: error.message,
        ),
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('Unexpected coach profile error: $error\n$stackTrace');
      emit(
        const CoachProfileState(
          status: CoachProfileStatus.failure,
          errorMessage: 'Unable to load coach information. Please try again.',
        ),
      );
    }
  }
}
