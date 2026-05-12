import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tax_collect/src/data/data.dart';
import 'package:tax_collect/src/data/model/tax_collect.dart';
import 'package:tax_collect/src/presentation/contribuable/contribuable.dart';
import 'package:tax_collect/src/presentation/home/home.dart';
import 'package:tax_collect/src/presentation/tax_collect/controllers/controllers.dart';
import 'package:tax_collect/src/utils/amount_utils.dart';
import 'package:tax_collect/src/utils/date_utils.dart';
import 'package:tax_collect/src/widgets/api_response_view.dart';
import 'package:tax_collect/src/widgets/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/location_utils.dart';

class ContribuableDetailScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ContribuableDetailScreen> createState() => _ContribuableDetailScreenState();
}

class _ContribuableDetailScreenState extends ConsumerState<ContribuableDetailScreen> {
  late ContribuableController _contribuableController;
  late Contribuable _contribuable;

  @override
  void initState() {
    _contribuableController = ref.read(contribuableControllerProvider);
    _contribuable = _contribuableController.contribuable;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getContribuableInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détails contribuable"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer(
          builder: (context, ref, child) {
            _contribuableController = ref.watch(contribuableControllerProvider);
            final response = _contribuableController.contribuableResponse;
            return ApiResponseView(
              response: response,
              retry: () => _getContribuableInfo(true),
              responseBuilder: (items) {
                _contribuable = items.first;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 30,
                                  child: Icon(Icons.person_outline_outlined, color: Colors.grey, size: 30),
                                ),
                              ),
                              Gap(16),
                              _buildRowInfo("Nom et prénoms", _contribuable.fullname),
                              Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                              _buildRowInfo("Matricule", _contribuable.matricule ?? ''),
                              Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                              _buildRowInfo("Téléphone", _contribuable.phoneNumber ?? ''),
                              Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                              // _buildRowInfo("Nom du commerce", _contribuable.activite?.firstOrNull ?? ''),
                              // Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                              _buildRowInfo("Type de contribuable", _contribuable.typeContribuable?.firstOrNull ?? ''),
                              if (_contribuable.tax != null) ...[
                                Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                                _buildRowInfo(
                                  "Montant de la collecte",
                                  "${_contribuable.tax!.taux!.toInt().formatAmount} FCFA",
                                ),
                                Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                                _buildRowInfo("Periodicité", _contribuable.tax!.periodicite ?? ''),
                                Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                                Row(
                                  spacing: 8,
                                  children: [
                                    Expanded(
                                      child: Text("Localisation", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    if (_contribuable.hasLocation)
                                      InkWell(
                                        onTap: () {
                                          launchUrl(
                                            Uri.parse(
                                              "https://www.google.com/maps/search/?api=1&query=${_contribuable.latitude!},${_contribuable.longitude!}",
                                            ),
                                            mode: LaunchMode.externalApplication,
                                          );
                                        },
                                        child: Text(
                                          "Afficher",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.blue,
                                          ),
                                        ),
                                      )
                                    else
                                      Text("Inconnue", style: TextStyle(fontSize: 12)),
                                    InkWell(
                                      onTap: () async {
                                        showInfoDialog(
                                          context,
                                          message: "Voulez-vous mettre à jour la localisation ?",
                                          negativeLabel: "NON",
                                          positiveLabel: "OUI",
                                          positiveCallBack: () {
                                            _updateLocation();
                                          },
                                        );
                                      },
                                      child: Icon(Icons.edit_location_outlined, size: 24),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Gap(8),
                      ElevatedButton(
                        onPressed: () async {
                          var result = await showInfoDialog(
                            context,
                            message: "Confirmer la collecte de ${_contribuable.tax!.taux!.toInt()} Fcfa",
                            positiveLabel: "OUI",
                            negativeLabel: "NON",
                          );
                          if (result != null && result) {
                            _submit();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.attach_money_rounded, color: Colors.white),
                            Gap(4),
                            Text("Collecter la taxe"),
                          ],
                        ),
                      ),
                      Gap(16),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRowInfo(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Text(value, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  void _submit() async {
    showLoadingDialog(context);
    var response = await _contribuableController.collectTax();
    Navigator.pop(context);
    if (!response.success!) {
      showInfoDialog(context, message: response.message ?? '');
      return;
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
  }

  void _updateLocation() async {
    showLoadingDialog(context);
    final position = await LocationUtils.getLocation();
    var response = await _contribuableController.updateLocation(position!);
    Navigator.pop(context);
    if (!response.success!) {
      showInfoDialog(context, message: response.message ?? '');
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Localisation mise à jour avec succès"), backgroundColor: Colors.green));
    _getContribuableInfo(true);
  }

  void _getContribuableInfo([bool refresh = false]) {
    _contribuableController.getContribuableInfo(refresh);
  }
}
