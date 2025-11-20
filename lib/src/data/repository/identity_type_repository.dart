import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final identityTypeRepositoryProvider = Provider((ref) {
  return IdentityTypeRepositoryImpl(remoteClient: ref.read(remoteClientProvider));
});

abstract class IdentityTypeRepository {
  Future<ApiResponse<IdentityType>> getIdentityTypes();
}

class IdentityTypeRepositoryImpl extends IdentityTypeRepository {
  final RemoteClient _remoteClient;

  IdentityTypeRepositoryImpl({required RemoteClient remoteClient}) : _remoteClient = remoteClient;

  @override
  Future<ApiResponse<IdentityType>> getIdentityTypes() {
    return runBlock(() async {
      var items = await _remoteClient.getIdentityTypes();
      return ApiResponse<IdentityType>(items: items);
    });
  }
}
