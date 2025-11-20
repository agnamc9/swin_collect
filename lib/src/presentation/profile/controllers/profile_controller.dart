import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tax_collect/src/data/data.dart';

final profileControllerProvider = ChangeNotifierProvider((ref) {
  return ProfileController(userRepository: ref.read(userRepositoryProvider));
});

class ProfileController extends ChangeNotifier {
  final UserRepository _userRepository;

  ProfileController({required UserRepository userRepository}) : _userRepository = userRepository;

  User getUser() => _userRepository.getUser()!;

  void logout() => _userRepository.deleteSession();
}
