import '../../data/models/client_model.dart';

abstract interface class ClientsRepository {
  Future<List<ClientModel>> getClients({String? status, String? search});
}
