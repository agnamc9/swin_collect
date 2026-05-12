import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tax_collect/src/data/data.dart';

import '../../../data/repository/repository.dart';

final createContribuableControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  return CreateContribuableController(
    contribuableRepository: ref.read(contribuableRepositoryProvider),
    taxRepository: ref.read(taxRepositoryProvider),
    identityTypeRepository: ref.read(identityTypeRepositoryProvider),
    generalParamRepository: ref.read(generalParamRepositoryProvider),
  );
});

class CreateContribuableController extends ChangeNotifier {
  final ContribuableRepository _contribuableRepository;
  final TaxRepository _taxRepository;
  final IdentityTypeRepository _identityTypeRepository;
  final GeneralParamRepository _generalParamRepository;

  ApiResponse<TaxType>? _taxesResponse;

  ApiResponse<TaxType>? get taxesResponse => _taxesResponse;

  TaxType? _tax;

  TaxType? get tax => _tax;

  set tax(TaxType value) {
    _tax = value;
    notifyListeners();
  }

  getTaxes() async {
    _taxesResponse = null;
    notifyListeners();
    _taxesResponse = await _taxRepository.getTaxes();
    notifyListeners();
  }

  ApiResponse<IdentityType>? _identityResponse;

  ApiResponse<IdentityType>? get identityResponse => _identityResponse;

  IdentityType? _identityType;

  CreateContribuableController({
    required ContribuableRepository contribuableRepository,
    required TaxRepository taxRepository,
    required IdentityTypeRepository identityTypeRepository,
    required GeneralParamRepository generalParamRepository,
  }) : _contribuableRepository = contribuableRepository,
       _taxRepository = taxRepository,
       _identityTypeRepository = identityTypeRepository,
       _generalParamRepository = generalParamRepository;

  IdentityType? get identityType => _identityType;

  set identityType(IdentityType value) {
    _identityType = value;
    notifyListeners();
  }

  getIdentityTypes() async {
    _identityResponse = null;
    notifyListeners();
    _identityResponse = await _identityTypeRepository.getIdentityTypes();
    notifyListeners();
  }

  resetSelections() {
    _tax = null;
    _identityType = null;
  }

  Future<ApiResponse> createContribuable({
    required String nom,
    required String prenoms,
    required String adresse,
    required String telephone,
    required String numeroPiece,
    required double latitude,
    required double longitude,
  }) {
    return _contribuableRepository.create(
      nom: nom.trim(),
      prenoms: prenoms.trim(),
      adresse: adresse.trim(),
      telephone: telephone.trim(),
      activite: _activity!.id!,
      numeroPiece: numeroPiece.trim(),
      tax: tax!.id!,
      identityId: _identityType!.id!,
      latitude: latitude,
      longitude: longitude,
      quartier: _neighborHood!.id!,
      typeContribuable: _contribuableType!,
    );
  }

  ApiResponse<Neighborhood>? _neighborHoodResponse;

  ApiResponse<Neighborhood>? get neighborHoodResponse => _neighborHoodResponse;

  getNeighborHoods() async {
    _neighborHoodResponse = null;
    notifyListeners();
    _neighborHoodResponse = await _generalParamRepository.getNeighborhoods();
    notifyListeners();
  }

  Neighborhood? _neighborHood;

  Neighborhood? get neighborHood => _neighborHood;

  set neighborHood(Neighborhood value) {
    _neighborHood = value;
    notifyListeners();
  }

  ApiResponse<BusinessActivity>? _activityResponse;

  ApiResponse<BusinessActivity>? get activityResponse => _activityResponse;

  getActivities() async {
    _activityResponse = null;
    notifyListeners();
    _activityResponse = await _generalParamRepository.getBusinessActivities();
    notifyListeners();
  }

  BusinessActivity? _activity;

  BusinessActivity? get activity => _activity;

  set activity(BusinessActivity value) {
    _activity = value;
    notifyListeners();
  }

  String? _contribuableType;

  String? get contribuableType => _contribuableType;

  set contribuableType(String? value) {
    _contribuableType = value;
    notifyListeners();
  }

  String _superficie = '';

  set superficie(String value) {
    _superficie = value;
    notifyListeners();
  }

  num get taxOdpAmount {
    return _superficie.isEmpty ? 0 : (int.tryParse(_superficie) ?? 0) * _tax!.taux!;
  }
}
