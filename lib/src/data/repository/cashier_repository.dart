import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final cashierRepositoryProvider = Provider((ref) {
  return CashierRepositoryImpl(remoteClient: ref.read(remoteClientProvider));
});

abstract class CashierRepository {
  Future<ApiResponse<CashierStatus>> getCashierStatus();

  Future<ApiResponse<CashierStatus>> closeCashier(num amount);
}

class CashierRepositoryImpl extends CashierRepository {
  final RemoteClient _remoteClient;

  CashierRepositoryImpl({required RemoteClient remoteClient})
    : _remoteClient = remoteClient;

  @override
  Future<ApiResponse<CashierStatus>> getCashierStatus() async {
    var item = await _remoteClient.getCashierStatus();
    return ApiResponse<CashierStatus>(items: [item]);
    return runBlock(() async {
      var item = await _remoteClient.getCashierStatus();
      return ApiResponse<CashierStatus>(items: [item]);
    });
  }

  @override
  Future<ApiResponse<CashierStatus>> closeCashier(num amount) {
    return runBlock(() async {
      var item = await _remoteClient.closeCashier({'montantPhysique': amount});
      return ApiResponse<CashierStatus>(
        items: [item],
        message: "Caisse clôturée avec succès",
      );
    });
  }
}
