import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final taxRepositoryProvider = Provider((ref) {
  return TaxRepositoryImpl(remoteClient: ref.read(remoteClientProvider));
});

abstract class TaxRepository {
  Future<ApiResponse<TaxType>> getTaxes();
}

class TaxRepositoryImpl extends TaxRepository {
  final RemoteClient _remoteClient;

  TaxRepositoryImpl({required RemoteClient remoteClient}) : _remoteClient = remoteClient;

  @override
  Future<ApiResponse<TaxType>> getTaxes() {
    return runBlock(() async {
      var items = await _remoteClient.getTaxTypes();
      return ApiResponse<TaxType>(items: items);
    });
  }
}
