import 'package:coach_app/features/clients/domain/repo/clients_repo.dart';

import '../../data/models/client_model.dart';

class GetClientsUseCase {
  final ClientsRepository _repository;

  const GetClientsUseCase(this._repository);

  Future<List<ClientModel>> call({String? status, String? search}) {
    return _repository.getClients(status: status, search: search);
  }
}
