import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coach_app/core/networking/api_error_handler.dart';
import '../../domain/use_case/get_clients_use_case.dart';
import 'clients_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  final GetClientsUseCase _getClientsUseCase;

  ClientsCubit(this._getClientsUseCase) : super(const ClientsState());

  // دالة تحميل المتدربين مع دعم الفلترة والبحث
  Future<void> loadClients({String? status, String? search}) async {
    emit(state.copyWith(status: ClientsStatus.loading));

    try {
      final clients = await _getClientsUseCase(status: status, search: search);

      emit(
        state.copyWith(
          status: ClientsStatus.success,
          clients: clients,
          selectedFilter: status ?? state.selectedFilter,
        ),
      );
    } on DioException catch (error) {
      emit(
        state.copyWith(
          status: ClientsStatus.failure,
          errorMessage: ErrorHandler.handle(error).failure.message,
        ),
      );
    } on FormatException catch (error) {
      emit(
        state.copyWith(
          status: ClientsStatus.failure,
          errorMessage: error.message,
        ),
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('Unexpected clients error: $error\n$stackTrace');
      emit(
        state.copyWith(
          status: ClientsStatus.failure,
          errorMessage: 'Unable to load clients. Please try again.',
        ),
      );
    }
  }
}
