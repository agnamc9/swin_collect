import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tax_collect/src/data/model/tax_collect.dart';
import 'package:tax_collect/src/presentation/contribuable/controllers/contribuable_controller.dart';
import 'package:tax_collect/src/presentation/tax_collect/controllers/controllers.dart';
import 'package:tax_collect/src/utils/amount_utils.dart';
import 'package:tax_collect/src/utils/date_utils.dart';

class TaxCollectDetailScreen extends ConsumerStatefulWidget {
  const TaxCollectDetailScreen({super.key});

  @override
  ConsumerState<TaxCollectDetailScreen> createState() =>
      _TaxCollectDetailScreenState();
}

class _TaxCollectDetailScreenState
    extends ConsumerState<TaxCollectDetailScreen> {
  late TaxCollectController _taxCollectController;
  late TaxCollect _taxCollect;

  @override
  void initState() {
    _taxCollectController = ref.read(taxCollectControllerProvider);
    _taxCollect = _taxCollectController.taxCollect;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taxCollectController.getContribuable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détails collecte"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Informations du paiement",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(4),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildRowInfo(
                              "Numéro de paiement",
                              _taxCollect.paymentNumber!,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Divider(),
                            ),
                            _buildRowInfo(
                              "Date et heure",
                              _taxCollect.collectedAt!.toDisplayDateTime,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Divider(),
                            ),
                            _buildRowInfo(
                              "Montant",
                              "${_taxCollect.amountCollected!.formatAmount} Fcfa",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Divider(),
                    ),
                    Text(
                      "Informations du contribuable",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(4),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            _taxCollectController = ref.watch(
                              taxCollectControllerProvider,
                            );
                            var response =
                                _taxCollectController.contribuableResponse;
                            var contribuable = response?.items?.first;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildRowInfo(
                                  "Matricule",
                                  contribuable?.matricule ?? "",
                                  loading: response == null,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Divider(),
                                ),
                                _buildRowInfo(
                                  "Nom et prénoms",
                                  contribuable?.fullname ?? "",
                                  loading: response == null,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(8),
            ElevatedButton(
              onPressed: () {
                _taxCollectController.printReceipt();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.print, color: Colors.white),
                  Gap(8),
                  Text("Imprimer le reçu"),
                ],
              ),
            ),
            Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInfo(String title, String value, {bool loading = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        if (loading)
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: Text(
              "------",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          )
        else
          Text(value, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
