import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/health_profile_entity.dart';
import '../../domain/repo/health_profile_repo.dart';
import 'health_profile_state.dart';

class HealthProfileCubit extends Cubit<HealthProfileState> {
  final HealthProfileRepository _repository;

  HealthProfileCubit(this._repository) : super(HealthProfileInitial());

  @override
  void emit(HealthProfileState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  // جلب السجل الصحي الحالي للمتدرب
  Future<void> loadHealthProfile(int memberId) async {
    emit(HealthProfileLoading());
    try {
      final profile = await _repository.getHealthProfile(memberId);
      emit(HealthProfileLoaded(profile));
    } catch (e) {
      emit(HealthProfileError(e.toString()));
    }
  }

  // حفظ السجل الصحي في السيرفر
  Future<void> saveHealthProfile(HealthProfileEntity entity) async {
    emit(HealthProfileSaving());
    try {
      final saved = await _repository.saveHealthProfile(entity);
      emit(HealthProfileSaveSuccess(saved));
    } catch (e) {
      emit(HealthProfileError(e.toString()));
    }
  }
}
