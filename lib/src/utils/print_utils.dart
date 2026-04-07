import 'package:flutter/services.dart';
import 'package:tax_collect/src/utils/amount_utils.dart';
import 'package:tax_collect/src/utils/date_utils.dart';

import '../data/data.dart';

class PrintUtils {
  PrintUtils._();

  static startPrint(
    TaxCollect taxCollect,
    User user, [
    Contribuable? contribuable,
  ]) async {
    String content =
        "Date : ${taxCollect.collectedAt!.toDisplayDateTime}\nNumero : ${taxCollect.paymentNumber!}\nMontant : ${taxCollect.amountCollected!.formatAmount} Fcfa\n";
    if (contribuable != null) {
      content +=
          "Matricule contribuable : ${contribuable.matricule}\nNom contribuable : ${contribuable.fullname}\n";
    }
    content += "Agent de collecte : ${user.fullname}";
    return const MethodChannel(
      'androidChannel',
    ).invokeMethod('wiseasyPrint', content);
  }
}
