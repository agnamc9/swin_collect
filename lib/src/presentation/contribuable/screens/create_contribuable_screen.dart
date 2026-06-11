import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tax_collect/src/data/data.dart';
import 'package:tax_collect/src/presentation/contribuable/contribuable.dart';
import 'package:tax_collect/src/utils/amount_utils.dart';
import 'package:tax_collect/src/utils/location_utils.dart';
import 'package:tax_collect/src/widgets/dialogs.dart';

class CreateContribuableScreen extends ConsumerStatefulWidget {
  const CreateContribuableScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateContribuableScreen> createState() => _CreateContribuableScreenState();
}

class _CreateContribuableScreenState extends ConsumerState<CreateContribuableScreen> {
  final _formKey = GlobalKey<FormState>();
  AppLocation? _currentPosition;
  late CreateContribuableController _contribuableController;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController numeroPieceController = TextEditingController();
  final TextEditingController superficieCtrl = TextEditingController();

  @override
  void initState() {
    _contribuableController = ref.read(createContribuableControllerProvider);
    if (kDebugMode) {
      nomController.text = "Tony";
      prenomController.text = "Herb";
      adresseController.text = "2 Plateaux";
      telephoneController.text = "0748229444";
      numeroPieceController.text = "CI14393";
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTaxes();
      _getIdentityTypes();
      _getNeighborHoods();
      _getActivities();
    });
  }

  Future<void> _getCurrentPosition() async {
    showLoadingDialog(context);
    final position = await LocationUtils.getLocation();
    Navigator.pop(context);
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nouveau contribuable"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(16),
                TextFormField(
                  controller: nomController,
                  decoration: InputDecoration(
                    labelText: "Nom",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le nom est requis";
                    }
                    return null;
                  },
                ),
                Gap(16),
                TextFormField(
                  controller: prenomController,
                  decoration: InputDecoration(
                    labelText: "Prénoms",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le prénom est requis";
                    }
                    return null;
                  },
                ),
                Gap(16),
                Consumer(
                  builder: (context, ref, child) {
                    _contribuableController = ref.watch(createContribuableControllerProvider);
                    var response = _contribuableController.neighborHoodResponse;
                    var item = _contribuableController.neighborHood;
                    return DropdownButtonFormField<Neighborhood>(
                      initialValue: item,
                      decoration: InputDecoration(
                        labelText: "Quartier",
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                        suffixIcon: response == null
                            ? SizedBox(width: 5, height: 5, child: CircularProgressIndicator(strokeWidth: 1))
                            : (!response.success!
                                  ? InkWell(onTap: _getIdentityTypes, child: Icon(Icons.refresh_rounded))
                                  : null),
                      ),
                      items: (response?.items ?? [])
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.label!)))
                          .toList(),
                      onChanged: (value) {
                        if (response == null) return;
                        if (value == null) return;
                        _contribuableController.neighborHood = value;
                      },
                      isExpanded: true,
                      validator: (value) {
                        if (value == null) {
                          return "Veuillez sélectionner le quartier";
                        }
                        return null;
                      },
                    );
                  },
                ),
                Gap(16),
                TextFormField(
                  controller: adresseController,
                  decoration: InputDecoration(
                    labelText: "Adresse",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "L'adresse est requise";
                    }
                    return null;
                  },
                ),
                Gap(16),
                TextFormField(
                  controller: telephoneController,
                  decoration: InputDecoration(
                    labelText: "Numéro de téléphone",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le numéro de téléphone est requis";
                    }
                    try {
                      int.parse(value.trim());
                    } catch (e) {
                      return "Le numéro est invalide";
                    }
                    return null;
                  },
                ),
                Gap(16),
                Consumer(
                  builder: (context, ref, child) {
                    _contribuableController = ref.watch(createContribuableControllerProvider);
                    var response = _contribuableController.activityResponse;
                    var item = _contribuableController.activity;
                    return DropdownButtonFormField<BusinessActivity>(
                      initialValue: item,
                      decoration: InputDecoration(
                        labelText: "Activité",
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                        suffixIcon: response == null
                            ? SizedBox(width: 5, height: 5, child: CircularProgressIndicator(strokeWidth: 1))
                            : (!response.success!
                                  ? InkWell(onTap: _getIdentityTypes, child: Icon(Icons.refresh_rounded))
                                  : null),
                      ),
                      items: (response?.items ?? [])
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.label!)))
                          .toList(),
                      onChanged: (value) {
                        if (response == null) return;
                        if (value == null) return;
                        _contribuableController.activity = value;
                      },
                      isExpanded: true,
                      validator: (value) {
                        if (value == null) {
                          return "Veuillez sélectionner l'activité";
                        }
                        return null;
                      },
                    );
                  },
                ),
                Gap(16),
                Consumer(
                  builder: (context, ref, child) {
                    _contribuableController = ref.watch(createContribuableControllerProvider);
                    var response = _contribuableController.identityResponse;
                    var item = _contribuableController.identityType;
                    return DropdownButtonFormField<IdentityType>(
                      initialValue: item,
                      decoration: InputDecoration(
                        labelText: "Type de pièce",
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                        suffixIcon: response == null
                            ? SizedBox(width: 5, height: 5, child: CircularProgressIndicator(strokeWidth: 1))
                            : (!response.success!
                                  ? InkWell(onTap: _getIdentityTypes, child: Icon(Icons.refresh_rounded))
                                  : null),
                      ),
                      items: (response?.items ?? [])
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.label!)))
                          .toList(),
                      onChanged: (value) {
                        if (response == null) return;
                        if (value == null) return;
                        _contribuableController.identityType = value;
                      },
                      isExpanded: true,
                      validator: (value) {
                        if (value == null) {
                          return "Le type de pièce est requis";
                        }
                        return null;
                      },
                    );
                  },
                ),
                Gap(16),
                Consumer(
                  builder: (context, ref, child) {
                    _contribuableController = ref.watch(createContribuableControllerProvider);
                    var item = _contribuableController.identityType;
                    numeroPieceController.text = (item?.isAutre ?? false) ? "N/A" : "";
                    return TextFormField(
                      controller: numeroPieceController,
                      enabled: !(item?.isAutre ?? true),
                      decoration: InputDecoration(
                        labelText: "Numéro de pièce",
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.work_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Le numéro de pièce est requis";
                        }
                        return null;
                      },
                    );
                  },
                ),
                Gap(16),
                Consumer(
                  builder: (context, ref, child) {
                    _contribuableController = ref.watch(createContribuableControllerProvider);
                    var response = _contribuableController.taxesResponse;
                    var item = _contribuableController.tax;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<TaxType>(
                          initialValue: item,
                          decoration: InputDecoration(
                            labelText: "Nature de la taxe",
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                            suffixIcon: response == null
                                ? SizedBox(width: 5, height: 5, child: CircularProgressIndicator(strokeWidth: 1))
                                : (!response.success!
                                      ? InkWell(onTap: _getIdentityTypes, child: Icon(Icons.refresh_rounded))
                                      : null),
                          ),
                          isExpanded: true,
                          items: (response?.items ?? [])
                              .map((e) => DropdownMenuItem(value: e, child: Text("${e.typeTaxe!} | ${e.periodicite!}")))
                              .toList(),
                          onChanged: (value) {
                            if (response == null) return;
                            if (value == null) return;
                            _contribuableController.tax = value;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "La nature de la taxe est requise";
                            }
                            return null;
                          },
                        ),
                        if (item != null) ...[
                          Gap(8),
                          Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    text: "Périodicité : ",
                                    children: [
                                      TextSpan(
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                        text: item.periodicite!,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    text: "Type : ",
                                    children: [
                                      TextSpan(
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                        text: item.typeTaux!,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              text: "Valeur : ",
                              children: [
                                TextSpan(
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                  text: item.typeTaux == "POURCENTAGE"
                                      ? "${item.taux!}%"
                                      : "${item.taux!.toInt()} Fcfa",
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (item != null && item.isOdp) ...[
                          Gap(16),
                          TextFormField(
                            controller: superficieCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Superficie (m²)",
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.pin_drop_outlined),
                            ),
                            validator: (value) {
                              if (!item.isOdp) return null;
                              if (value == null || value.isEmpty) return "La superficie est requise";
                              try {
                                final int superficie = int.parse(superficieCtrl.text.trim());
                                if (superficie <= 0) {
                                  return "La superficie doit-être supérieure à 0";
                                }
                              } catch (e) {
                                return "La superficie est invalide";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _contribuableController.superficie = value;
                            },
                          ),
                          Gap(8),
                          Text(
                            "Montant calculé : ${_contribuableController.taxOdpAmount == 0 ? '-' : '${_contribuableController.taxOdpAmount.formatAmount} Fcfa'}",
                          ),
                        ],
                      ],
                    );
                  },
                ),
                Gap(16),
                Text("Type de contribuable", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Consumer(
                  builder: (context, ref, child) {
                    _contribuableController = ref.watch(createContribuableControllerProvider);
                    return RadioGroup<String>(
                      onChanged: (value) {
                        _contribuableController.contribuableType = value;
                      },
                      groupValue: _contribuableController.contribuableType,
                      child: Row(
                        children: [
                          Radio<String>(value: "Fixe"),
                          Expanded(child: Text("Fixe")),
                          Radio<String>(value: "Ambulant"),
                          Expanded(child: Text("Ambulant")),
                        ],
                      ),
                    );
                  },
                ),
                Gap(16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Position GPS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _currentPosition == null
                                    ? "Position non définie"
                                    : "${_currentPosition!.lat};${_currentPosition!.lng}",
                                style: TextStyle(color: _currentPosition == null ? Colors.grey : Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _getCurrentPosition();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Icon(Icons.location_searching_outlined), Gap(4), Text("Obtenir position")],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(24),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.validate();
                    if (_checkForm()) _submit();
                  },
                  child: Text("Enregistrer"),
                ),
                Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _checkForm() {
    if (nomController.text.isEmpty) {
      showInfoDialog(context, message: "Le nom est requis");
      return false;
    }

    if (prenomController.text.isEmpty) {
      showInfoDialog(context, message: "Le prénom est requis");
      return false;
    }

    if (_contribuableController.neighborHood == null) {
      showInfoDialog(context, message: "Veuillez sélectionner le quartier");
      return false;
    }

    if (adresseController.text.isEmpty) {
      showInfoDialog(context, message: "L'adresse est requise");
      return false;
    }

    if (telephoneController.text.isEmpty) {
      showInfoDialog(context, message: "Le téléphone est requis");
      return false;
    }

    try {
      int.parse(telephoneController.text.trim());
    } catch (e) {
      showInfoDialog(context, message: "Le téléphone est invalide");
      return false;
    }

    if (_contribuableController.activity == null) {
      showInfoDialog(context, message: "Veuillez sélectionner l'activité");
      return false;
    }

    if (_contribuableController.identityType == null) {
      showInfoDialog(context, message: "Veuillez sélectionner le type de pièce");
      return false;
    }

    if (numeroPieceController.text.isEmpty) {
      showInfoDialog(context, message: "Le numéro de pièce est requis");
      return false;
    }

    if (_contribuableController.tax == null) {
      showInfoDialog(context, message: "Veuillez sélectionner la nature de la taxe");
      return false;
    }

    if (_contribuableController.tax!.isOdp) {
      if (superficieCtrl.text.isEmpty) {
        showInfoDialog(context, message: "La superficie est requise");
        return false;
      }
      try {
        final int superficie = int.parse(superficieCtrl.text.trim());
        if (superficie <= 0) {
          showInfoDialog(context, message: "La superficie doit-être supérieure à 0");
          return false;
        }
      } catch (e) {
        showInfoDialog(context, message: "La superficie est invalide");
        return false;
      }
    }

    if (_contribuableController.contribuableType == null) {
      showInfoDialog(context, message: "Veuillez sélectionner le type de contribuable");
      return false;
    }

    if (_currentPosition == null) {
      showInfoDialog(context, message: "La position est requise");
      return false;
    }

    return true;
  }

  void _getTaxes() {
    _contribuableController.getTaxes();
  }

  void _getIdentityTypes() {
    _contribuableController.getIdentityTypes();
  }

  _submit() async {
    showLoadingDialog(context);
    var response = await _contribuableController.createContribuable(
      nom: nomController.text,
      prenoms: prenomController.text,
      adresse: adresseController.text,
      telephone: telephoneController.text,
      numeroPiece: numeroPieceController.text,
      latitude: _currentPosition!.lat,
      longitude: _currentPosition!.lng,
    );
    Navigator.pop(context);
    if (!response.success!) {
      showInfoDialog(context, message: response.message ?? '');
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Contribuable crée avec succès"), backgroundColor: Colors.green));
    Navigator.pop(context, true);
  }

  void _getNeighborHoods() {
    _contribuableController.getNeighborHoods();
  }

  void _getActivities() {
    _contribuableController.getActivities();
  }
}
