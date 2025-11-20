import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final contribuableRepositoryProvider = Provider((ref) {
  return ContribuableRepositoryImpl(remoteClient: ref.read(remoteClientProvider));
});

abstract class ContribuableRepository {
  Future<ApiResponse<Contribuable>> getContribuables();
}

class ContribuableRepositoryImpl extends ContribuableRepository {
  final RemoteClient _remoteClient;

  ContribuableRepositoryImpl({required RemoteClient remoteClient}) : _remoteClient = remoteClient;

  @override
  Future<ApiResponse<Contribuable>> getContribuables() {
    return runBlock(() async {
      var items = await _remoteClient.getContribuables();
      return ApiResponse<Contribuable>(items: items);
    });
  }
}