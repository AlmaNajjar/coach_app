import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coach_app/features/clients/domain/entities/measurement_input.dart';
import 'package:coach_app/features/clients/domain/use_case/add_measurement_use_case.dart';
import 'package:coach_app/features/clients/domain/use_case/get_member_measurements_use_case.dart';
import 'package:coach_app/features/clients/data/models/member_shift_model.dart';
import 'package:coach_app/features/clients/domain/repo/member_shifts_repo.dart';
import 'trainee_details_state.dart';
import 'package:dio/dio.dart';

class TraineeDetailsCubit extends Cubit<TraineeDetailsState> {
  final GetMemberMeasurementsUseCase _getMeasurementsUseCase;
  final AddMeasurementUseCase _addMeasurementUseCase;
  final MemberShiftsRepository _shiftsRepository;

  TraineeDetailsCubit(
    this._getMeasurementsUseCase,
    this._addMeasurementUseCase,
    this._shiftsRepository,
  ) : super(TraineeDetailsInitial());

  @override
  void emit(TraineeDetailsState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  // 1. جلب القياسات من الـ API
  Future<void> loadMeasurements(int memberId) async {
    emit(TraineeDetailsLoading());
    try {
      final page = await _getMeasurementsUseCase(memberId: memberId);
      final latest = page.items.isNotEmpty ? page.items.first : null;
      emit(TraineeDetailsLoaded(latest));
    } catch (e) {
      emit(TraineeDetailsError(e.toString()));
    }
  }

  // 2. حفظ القياسات وجدول الدوام معاً عند الضغط على Save Changes
  Future<void> saveChanges({
    MeasurementInput? measurement,
    CreateShiftScheduleRequest? shiftSchedule,
  }) async {
    emit(TraineeDetailsSaving());
    try {
      // حفظ القياسات إذا تم إدخالها
      if (measurement != null) {
        await _addMeasurementUseCase(measurement);
      }

      // حفظ جدول الدوام والورديات إذا تم تحديده
      if (shiftSchedule != null) {
        await _shiftsRepository.createShiftSchedule(shiftSchedule);
      }

      emit(TraineeDetailsSaveSuccess());
    } on DioException catch (e) {
      final serverMessage = e.response?.data?['message'] ?? e.message;
      emit(TraineeDetailsError(serverMessage.toString()));
    } catch (e) {
      emit(TraineeDetailsError(e.toString()));
    }
  }
}
