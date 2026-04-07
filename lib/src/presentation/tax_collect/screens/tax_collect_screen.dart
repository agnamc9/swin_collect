import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tax_collect/src/data/data.dart';
import 'package:tax_collect/src/presentation/contribuable/screens/contribuable_search_screen.dart';
import 'package:tax_collect/src/presentation/tax_collect/controllers/controllers.dart';
import 'package:tax_collect/src/presentation/tax_collect/screens/screens.dart';
import 'package:tax_collect/src/utils/amount_utils.dart';
import 'package:tax_collect/src/utils/date_utils.dart';
import 'package:tax_collect/src/widgets/api_response_view.dart';
import 'package:tax_collect/src/widgets/widgets.dart';

class TaxCollectScreen extends ConsumerStatefulWidget {
  const TaxCollectScreen({super.key});

  @override
  ConsumerState<TaxCollectScreen> createState() => _TaxCollectScreenState();
}

class _TaxCollectScreenState extends ConsumerState<TaxCollectScreen> {
  late TaxCollectController _taxCollectController;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    _taxCollectController = ref.read(taxCollectControllerProvider);
    _taxCollectController.initDates();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTaxes();
      _getTotalCollect();
      _getCashierStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer(
              builder: (_, ref, __) {
                _taxCollectController = ref.read(taxCollectControllerProvider);
                final cashierResponse =
                    _taxCollectController.cashierStatusResponse;
                final totalCollectResponse =
                    _taxCollectController.totalCollectResponse;
                final ApiResponse<dynamic>? response =
                    (cashierResponse == null || totalCollectResponse == null)
                    ? null
                    : ApiResponse(
                        success:
                            (cashierResponse.success ?? false) &&
                            (totalCollectResponse.success ?? false),
                      );
                return ApiResponseView(
                  response: response,
                  retry: _getCashierStatus,
                  responseBuilder: (items) {
                    final item = items.first;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.isOpen
                            ? Colors.grey.shade200
                            : null,
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: item.isOpen ? Colors.grey : Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (item.isOpen) return;
                        final response = await showInfoDialog(
                          context,
                          message: "Voulez-vous clôturer la caisse ?",
                          positiveLabel: "OUI",
                          negativeLabel: "NON",
                        );
                        if (response) {
                          _closeCashier();
                        }
                      },
                      child: Text(
                        item.isOpen ? "Caisse clôturée" : "Clôturer la caisse",
                      ),
                    );
                  },
                );
              },
            ),
            Gap(4),
            Text(
              DateFormat('EEEE dd MMMM yyyy').format(DateTime.now()),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_money_rounded),
                    Gap(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Collecte total du jour"),
                          Gap(4),
                          Consumer(
                            builder: (context, ref, child) {
                              _taxCollectController = ref.watch(
                                taxCollectControllerProvider,
                              );
                              var totalCollectResponse =
                                  _taxCollectController.totalCollectResponse;
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
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                          "${totalCollect.formatAmount} Fcfa",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: _getTotalCollect,
                                        child: Icon(Icons.refresh_rounded),
                                      ),
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
                  _taxCollectController = ref.watch(
                    taxCollectControllerProvider,
                  );
                  var response = _taxCollectController.collectsResponse;
                  return ApiResponseView(
                    response: response,
                    retry: _getTaxes,
                    responseBuilder: (items) {
                      var results = items;
                      if (results.isEmpty) {
                        return Center(child: Text("Aucune taxe"));
                      }
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          var item = results.elementAt(index);
                          return InkWell(
                            onTap: () {
                              _taxCollectController.taxCollect = item;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaxCollectDetailScreen(),
                                ),
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Paiement N°${item.paymentNumber}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Gap(4),
                                          Text(
                                            item.collectedAt!.toDisplayDateTime,
                                          ),
                                          Gap(4),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "${item.amountCollected!.formatAmount} Fcfa",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Gap(8),
                        itemCount: results.length,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContribuableSearchScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _getTaxes() {
    _taxCollectController.getTaxCollects();
  }

  void _getTotalCollect() {
    _taxCollectController.getTotalCollect();
  }

  void _getCashierStatus() {
    _taxCollectController.getCashierStatus();
  }

  void _closeCashier() async {
    showLoadingDialog(context);
    final response = await _taxCollectController.closeCashier();
    Navigator.pop(context);
    await showInfoDialog(context, message: response.message!);
    if (response.success!) _getCashierStatus();
  }
}
