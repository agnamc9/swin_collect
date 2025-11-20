import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tax_collect/src/presentation/tax_collect/controllers/controllers.dart';
import 'package:tax_collect/src/utils/date_utils.dart';
import 'package:tax_collect/src/widgets/api_response_view.dart';

class TaxCollectScreen extends ConsumerStatefulWidget {
  const TaxCollectScreen({super.key});

  @override
  ConsumerState<TaxCollectScreen> createState() => _TaxCollectScreenState();
}

class _TaxCollectScreenState extends ConsumerState<TaxCollectScreen> {
  late TaxCollectController _taxCollectController;

  @override
  void initState() {
    _taxCollectController = ref.read(taxCollectControllerProvider);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTaxes();
      _getTotalCollect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.attach_money_rounded),
                  Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Collecte total de la période"),
                        Gap(4),
                        Consumer(
                          builder: (context, ref, child) {
                            _taxCollectController = ref.watch(taxCollectControllerProvider);
                            var totalCollectResponse = _taxCollectController.totalCollectResponse;
                            return ApiResponseView(
                              response: totalCollectResponse,
                              showErrorMessage: false,
                              responseBuilder: (items) {
                                var totalCollect = items.first;
                                return Text(
                                  "${totalCollect} Fcfa",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(8),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                _taxCollectController = ref.watch(taxCollectControllerProvider);
                var response = _taxCollectController.collectsResponse;
                return ApiResponseView(
                  response: response,
                  retry: _getTaxes,
                  responseBuilder: (items) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        var item = items.elementAt(index);
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Paiement N°${item.paymentNumber}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Gap(4),
                                      Text(item.collectedAt!.toDisplayDate),
                                    ],
                                  ),
                                ),
                                Gap(8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${item.amountCollected!} Fcfa",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Gap(8),
                      itemCount: items.length,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _getTaxes() {
    _taxCollectController.getTaxCollects();
  }

  void _getTotalCollect() {
    _taxCollectController.getTotalCollect();
  }
}
