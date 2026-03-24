import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tax_collect/src/data/data.dart';
import 'package:tax_collect/src/utils/print_utils.dart';

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

  late DateTime _startDate;

  DateTime get startDate => _startDate;

  late DateTime _endDate;

  DateTime get endDate => _endDate;

  bool _hasDatesChanged = false;

  bool get hasDatesChanged => _hasDatesChanged;

  void initDates() {
    _endDate = DateTime.now();
    _startDate = DateTime.now().subtract(Duration(days: 1));
    _hasDatesChanged = false;
  }

  updateDates({DateTime? startDate, DateTime? endDate}) {
    if (startDate != null) _startDate = startDate;
    if (endDate != null) _endDate = endDate;
    _hasDatesChanged = true;
    notifyListeners();
  }

  List<TaxCollect> getFilteredCollects() {
    return (_collectsResponse!.items ?? []).where((collect) {
      var currentDate = DateTime.parse(collect.collectedAt!);
      return currentDate.isAfter(_startDate) && currentDate.isBefore(_endDate);
    }).toList();
  }

  int getTotalCollects() {
    if (_hasDatesChanged) {
      return getFilteredCollects().fold(0, (prev, curr) => prev + curr.amountCollected!);
    }
    return _totalCollectResponse!.items!.first.toInt();
  }

  void printReceipt() {
    PrintUtils.startPrint(_taxCollect.paymentNumber!);
  }
}
