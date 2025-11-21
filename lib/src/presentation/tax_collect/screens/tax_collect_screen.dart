import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tax_collect/src/presentation/tax_collect/controllers/controllers.dart';
import 'package:tax_collect/src/presentation/tax_collect/screens/screens.dart';
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
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                              loadingView: Align(
                                alignment: Alignment.centerLeft,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor: Colors.white,
                                  child: Text(
                                    '******',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              showErrorMessage: false,
                              responseBuilder: (items) {
                                var totalCollect = items.first;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${totalCollect} Fcfa",
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    InkWell(onTap: _getTotalCollect, child: Icon(Icons.refresh_rounded)),
                                  ],
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
                        return InkWell(
                          onTap: () {
                            _taxCollectController.taxCollect = item;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TaxCollectDetailScreen()));
                          },
                          child: Card(
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
                                    child: Text("${item.amountCollected!} Fcfa", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
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
