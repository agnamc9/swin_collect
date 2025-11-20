import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepositoryImpl(remoteClient: ref.read(remoteClientProvider), localStorage: ref.read(localStorageProvider));
});

abstract class UserRepository {
  Future<ApiResponse<User>> signin(String username, String password);

  User? getUser();

  deleteUser();
}

class UserRepositoryImpl extends UserRepository {
  final RemoteClient _remoteClient;
  final LocalStorage _localStorage;

  UserRepositoryImpl({required RemoteClient remoteClient, required LocalStorage localStorage})
    : _remoteClient = remoteClient,
      _localStorage = localStorage;

  @override
  Future<ApiResponse<User>> signin(String username, String password) {
    return runBlock(() async {
      var response = await _remoteClient.authenticate(User(username: username, password: password));
      _localStorage.saveToken(response.token!);
      _localStorage.saveUser(response.user!);
      return ApiResponse();
    });
  }

  @override
  deleteUser() => _localStorage.deleteSession();

  @override
  User? getUser() => _localStorage.getUser();
}
