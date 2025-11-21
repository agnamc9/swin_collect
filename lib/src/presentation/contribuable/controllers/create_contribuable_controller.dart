import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tax_collect/src/data/data.dart';

import '../../../data/repository/repository.dart';

final createContribuableControllerProvider = ChangeNotifierProvider((ref) {
  return CreateContribuableController(
    contribuableRepository: ref.read(contribuableRepositoryProvider),
    taxRepository: ref.read(taxRepositoryProvider),
    identityTypeRepository: ref.read(identityTypeRepositoryProvider),
  );
});

class CreateContribuableController extends ChangeNotifier {
  final ContribuableRepository _contribuableRepository;
  final TaxRepository _taxRepository;
  final IdentityTypeRepository _identityTypeRepository;

  CreateContribuableController({
    required ContribuableRepository contribuableRepository,
    required TaxRepository taxRepository,
    required IdentityTypeRepository identityTypeRepository,
  }) : _contribuableRepository = contribuableRepository,
       _taxRepository = taxRepository,
       _identityTypeRepository = identityTypeRepository;

  ApiResponse<Tax>? _taxesResponse;

  ApiResponse<Tax>? get taxesResponse => _taxesResponse;

  Tax? _tax;

  Tax? get tax => _tax;

  set tax(Tax value) {
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
    required String activite,
    required String numeroPiece,
    required double latitude,
    required double longitude,
  }) {
    return _contribuableRepository.create(
      nom: nom.trim(),
      prenoms: prenoms.trim(),
      adresse: adresse.trim(),
      telephone: telephone.trim(),
      activite: activite.trim(),
      numeroPiece: numeroPiece.trim(),
      tax: tax!.id!,
      identityId: _identityType!.id!,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
