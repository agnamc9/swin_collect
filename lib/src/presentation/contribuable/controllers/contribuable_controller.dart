import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tax_collect/src/data/data.dart';

import '../../../data/repository/repository.dart';

final contribuableControllerProvider = ChangeNotifierProvider((ref) {
  return ContribuableController(
    contribuableRepository: ref.read(contribuableRepositoryProvider),
    taxCollectRepository: ref.read(taxCollectRepositoryProvider),
  );
});

class ContribuableController extends ChangeNotifier {
  final ContribuableRepository _contribuableRepository;
  final TaxCollectRepository _taxCollectRepository;

  ContribuableController({
    required ContribuableRepository contribuableRepository,
    required TaxCollectRepository taxCollectRepository,
  }) : _contribuableRepository = contribuableRepository,
       _taxCollectRepository = taxCollectRepository;

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
    return response;
  }
}
