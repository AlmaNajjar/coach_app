import 'package:coach_app/features/clients/data/datasource/clients_remote_data_source.dart';
import 'package:coach_app/features/clients/data/models/client_model.dart';
import 'package:coach_app/features/clients/domain/repo/clients_repo.dart';

class ClientsRepositoryImpl implements ClientsRepository {
  final ClientsRemoteDataSource _remoteDataSource;

  const ClientsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ClientModel>> getClients({String? status, String? search}) {
    return _remoteDataSource.getClients(status: status, search: search);
  }
}
