import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final contribuableRepositoryProvider = Provider((ref) {
  return ContribuableRepositoryImpl(remoteClient: ref.read(remoteClientProvider));
});

abstract class ContribuableRepository {
  Future<ApiResponse<Contribuable>> getContribuables();

  Future<ApiResponse<Contribuable>> getContribuable(String id);

  Future<ApiResponse> create({
    required String nom,
    required String prenoms,
    required String adresse,
    required String telephone,
    required String numeroPiece,
    required int tax,
    required int quartier,
    required int activite,
    required int identityId,
    required double latitude,
    required double longitude,
    required String typeContribuable,
    int? superficie,
  });

  Future<ApiResponse<Coordinate>> updateLocation(double latitude, double longitude, int contribuableId);
}

class ContribuableRepositoryImpl extends ContribuableRepository {
  final RemoteClient _remoteClient;

  ContribuableRepositoryImpl({required RemoteClient remoteClient}) : _remoteClient = remoteClient;

  final Faker _faker = Faker();

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
    required String numeroPiece,
    required int tax,
    required int quartier,
    required int activite,
    required int identityId,
    required double latitude,
    required double longitude,
    required String typeContribuable,
    int? superficie,
  }) {
    return runBlock(() async {
      var result = await _remoteClient.createContribuable({
        "firstname": nom,
        "lastname": prenoms,
        "address": adresse == "N/A" ? "N/A-${_faker.address.buildingNumber()}" : adresse,
        "ville": "",
        "phoneNumber": telephone == "N/A" ? "0${_faker.phoneNumber.random.fromCharSet("0123456789", 9)}" : telephone,
        "latitude": "$latitude",
        "longitude": "$longitude",
        "photoPath": "null",
        "idIdentity": numeroPiece == "N/A" ? "N/A-${_faker.guid.guid()}" : numeroPiece,
        "identityTypeId": identityId,
        "activite": activite,
        "quartier": quartier,
        "tax": tax,
        if (superficie != null) "superficie": superficie,
        "typeContribuable": [typeContribuable.toUpperCase()],
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

  @override
  Future<ApiResponse<Coordinate>> updateLocation(double latitude, double longitude, int contribuableId) {
    return runBlock(() async {
      var item = await _remoteClient.updateContribuableLocation(
        Coordinate(latitude: "$latitude", longitude: "$longitude"),
        contribuableId,
      );
      return ApiResponse<Coordinate>(items: [item]);
    });
  }
}
