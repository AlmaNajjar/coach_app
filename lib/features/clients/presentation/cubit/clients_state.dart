import '../../data/models/client_model.dart';

enum ClientsStatus { initial, loading, success, failure }

class ClientsState {
  final ClientsStatus status;
  final List<ClientModel> clients;
  final String? errorMessage;
  final String selectedFilter;

  const ClientsState({
    this.status = ClientsStatus.initial,
    this.clients = const [],
    this.errorMessage,
    this.selectedFilter = 'All',
  });

  bool get isLoading => status == ClientsStatus.loading;
  bool get isSuccess => status == ClientsStatus.success;
  bool get isFailure => status == ClientsStatus.failure;

  ClientsState copyWith({
    ClientsStatus? status,
    List<ClientModel>? clients,
    String? errorMessage,
    String? selectedFilter,
  }) {
    return ClientsState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
