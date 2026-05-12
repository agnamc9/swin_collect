import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final generalParamRepositoryProvider = Provider((ref) {
  return GeneralParamRepositoryImpl(remoteClient: ref.read(remoteClientProvider));
});

abstract class GeneralParamRepository {
  Future<ApiResponse<Neighborhood>> getNeighborhoods();

  Future<ApiResponse<BusinessActivity>> getBusinessActivities();
}

class GeneralParamRepositoryImpl extends GeneralParamRepository {
  final RemoteClient _remoteClient;

  GeneralParamRepositoryImpl({required RemoteClient remoteClient}) : _remoteClient = remoteClient;

  @override
  Future<ApiResponse<BusinessActivity>> getBusinessActivities() {
    return runBlock(() async {
      var items = await _remoteClient.getBusinessActivities();
      return ApiResponse<BusinessActivity>(items: items);
    });
  }

  @override
  Future<ApiResponse<Neighborhood>> getNeighborhoods() {
    return runBlock(() async {
      var items = await _remoteClient.getNeighborhoods();
      return ApiResponse<Neighborhood>(items: items);
    });
  }
}
