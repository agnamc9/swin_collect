import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final contribuableRepositoryProvider = Provider((ref) {
  return ContribuableRepositoryImpl(
    remoteClient: ref.read(remoteClientProvider),
  );
});

abstract class ContribuableRepository {
  Future<ApiResponse<Contribuable>> getContribuables();

  Future<ApiResponse<Contribuable>> getContribuable(String id);

  Future<ApiResponse> create({
    required String nom,
    required String prenoms,
    required String adresse,
    required String telephone,
    required String activite,
    required String numeroPiece,
    required num tax,
    required int identityId,
    required double latitude,
    required double longitude,
  });
}

class ContribuableRepositoryImpl extends ContribuableRepository {
  final RemoteClient _remoteClient;

  ContribuableRepositoryImpl({required RemoteClient remoteClient})
    : _remoteClient = remoteClient;

  @override
  Future<ApiResponse<Contribuable>> getContribuables() {
    return runBlock(() async {
      var items = await _remoteClient.getContribuables();
      return ApiResponse<Contribuable>(items: items);
    });
  }

  @override
  Future<ApiResponse> create({
    required String nom,
    required String prenoms,
    required String adresse,
    required String telephone,
    required String activite,
    required String numeroPiece,
    required num tax,
    required int identityId,
    required double latitude,
    required double longitude,
  }) {
    return runBlock(() async {
      var result = await _remoteClient.createContribuable({
        "firstname": nom,
        "lastname": prenoms,
        "address": adresse,
        "ville": "",
        "phoneNumber": telephone,
        "latitude": "${latitude}",
        "longitude": "${longitude}",
        "idIdentity": numeroPiece,
        "identityTypeId": identityId,
        "activite": activite,
        "photoPath": "null",
        "tax": tax,
      });
      return ApiResponse<Contribuable>();
    });
  }

  @override
  Future<ApiResponse<Contribuable>> getContribuable(String id) {
    return runBlock(() async {
      var item = await _remoteClient.getContribuable(id);
      return ApiResponse<Contribuable>(items: [item]);
    });
  }
}
