import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tax_collect/src/data/data.dart';

final signinControllerProvider = ChangeNotifierProvider((ref) {
  return SigninController(userRepository: ref.read(userRepositoryProvider));
});

class SigninController extends ChangeNotifier {
  final UserRepository _userRepository;

  SigninController({required UserRepository userRepository}) : _userRepository = userRepository;

  Future<ApiResponse> signin(String username, String password){
    return _userRepository.signin(username, password);
  }
}
