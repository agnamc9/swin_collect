import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tax_collect/src/data/data.dart';

import '../../../data/repository/repository.dart';

final taxCollectControllerProvider = ChangeNotifierProvider((ref) {
  return TaxCollectController(taxCollectRepository: ref.read(taxCollectRepositoryProvider));
});

class TaxCollectController extends ChangeNotifier {
  final TaxCollectRepository _taxCollectRepository;

  TaxCollectController({required TaxCollectRepository taxCollectRepository})
    : _taxCollectRepository = taxCollectRepository;

  ApiResponse<TaxCollect>? _collectsResponse;

  ApiResponse<TaxCollect>? get collectsResponse => _collectsResponse;

  getTaxCollects() async {
    _collectsResponse = null;
    notifyListeners();
    _collectsResponse = await _taxCollectRepository.getTaxCollects();
    notifyListeners();
  }

  ApiResponse<num>? _totalCollectResponse;

  ApiResponse<num>? get totalCollectResponse => _totalCollectResponse;

  late TaxCollect _taxCollect;

  TaxCollect get taxCollect => _taxCollect;

  set taxCollect(TaxCollect value) {
    _taxCollect = value;
  }

  void getTotalCollect() async {
    _totalCollectResponse = null;
    notifyListeners();
    _totalCollectResponse = await _taxCollectRepository.getTotalCollect();
    notifyListeners();
  }
}
