import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../model/user.dart';
import 'local_keys.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  final storage = GetStorage();
  return LocalStorageImpl(storage: storage);
});

abstract class LocalStorage {
  User? getUser();

  saveUser(User user);

  String? getToken();

  saveToken(String token);

  deleteSession();
}

class LocalStorageImpl implements LocalStorage {
  final GetStorage storage;

  LocalStorageImpl({required this.storage});

  @override
  deleteSession() {
    storage.erase();
  }

  @override
  User? getUser() {
    var result = storage.read(LocalKeys.userKey);
    if (result != null) {
      return User.fromJson(jsonDecode(result));
    }
    return null;
  }

  @override
  saveUser(User user) {
    storage.write(LocalKeys.userKey, jsonEncode(user.toJson()));
  }

  @override
  String? getToken() {
    return storage.read<String?>(LocalKeys.tokenKey);
  }

  @override
  saveToken(String token) {
    storage.write(LocalKeys.tokenKey, token);
  }
}
