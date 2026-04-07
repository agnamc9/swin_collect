import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tax_collect/src/data/data.dart';

import '../../../data/repository/repository.dart';
import '../../../utils/print_utils.dart';

final contribuableControllerProvider = ChangeNotifierProvider((ref) {
  return ContribuableController(
    contribuableRepository: ref.read(contribuableRepositoryProvider),
    taxCollectRepository: ref.read(taxCollectRepositoryProvider),
    userRepository: ref.read(userRepositoryProvider),
  );
});

class ContribuableController extends ChangeNotifier {
  final ContribuableRepository _contribuableRepository;
  final TaxCollectRepository _taxCollectRepository;
  final UserRepository _userRepository;

  ContribuableController({
    required ContribuableRepository contribuableRepository,
    required TaxCollectRepository taxCollectRepository,
    required UserRepository userRepository,
  }) : _contribuableRepository = contribuableRepository,
       _taxCollectRepository = taxCollectRepository,
       _userRepository = userRepository;

  ApiResponse<Contribuable>? _contribuableResponse;

  ApiResponse<Contribuable>? get contribuableResponse => _contribuableResponse;

  late Contribuable _contribuable;

  Contribuable get contribuable => _contribuable;

  set contribuable(Contribuable value) {
    _contribuable = value;
  }

  getContribuables() async {
    _contribuableResponse = null;
    notifyListeners();
    _contribuableResponse = await _contribuableRepository.getContribuables();
    notifyListeners();
  }

  late TaxCollect _taxCollect;

  TaxCollect get taxCollect => _taxCollect;

  Future<ApiResponse> collectTax() async {
    var response = await _taxCollectRepository.collectTax(_contribuable.id!);
    if (response.success!) {
      _taxCollect = response.items!.first;
    }
    final user = _userRepository.getUser()!;
    PrintUtils.startPrint(_taxCollect, user, _contribuable);
    return response;
  }

  late String _query;

  String get query => _query;

  set query(String? value) {
    _query = value ?? '';
    notifyListeners();
  }

  void initQuery() {
    _query = '';
  }

  List<Contribuable> getFilteredContribuables() {
    var results = _contribuableResponse!.items ?? [];

    if (_query.isEmpty) {
      return results;
    }

    String _queryLower = _query.toLowerCase();

    return results
        .where(
          (c) =>
              c.fullname.toLowerCase().contains(_queryLower) ||
              (c.matricule ?? '').toLowerCase().contains(_queryLower),
        )
        .toList();
  }

  Future<ApiResponse<Contribuable>> searchContribuable(String text) async {
    return _contribuableRepository.searchContribuable(text);
  }
}
