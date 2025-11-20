import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final taxCollectRepositoryProvider = Provider((ref) {
  return TaxCollectRepositoryImpl(remoteClient: ref.read(remoteClientProvider));
});

abstract class TaxCollectRepository {
  Future<ApiResponse<TaxCollect>> getTaxCollects();

  Future<ApiResponse<num>> getTotalCollect();
}

class TaxCollectRepositoryImpl extends TaxCollectRepository {
  final RemoteClient _remoteClient;

  TaxCollectRepositoryImpl({required RemoteClient remoteClient}) : _remoteClient = remoteClient;

  @override
  Future<ApiResponse<TaxCollect>> getTaxCollects() {
    return runBlock(() async {
      var items = await _remoteClient.getTaxCollects();
      return ApiResponse<TaxCollect>(items: items);
    });
  }

  @override
  Future<ApiResponse<num>> getTotalCollect() {
    return runBlock(() async {
      var totalCollect = await _remoteClient.getAmountCollector();
      return ApiResponse<num>(items: [totalCollect]);
    });
  }
}