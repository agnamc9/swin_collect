import 'package:flutter/services.dart';
import 'package:tax_collect/src/utils/amount_utils.dart';
import 'package:tax_collect/src/utils/date_utils.dart';

import '../data/data.dart';

class PrintUtils {
  PrintUtils._();

  static startPrint(TaxCollect taxCollect, User user, [Contribuable? contribuable]) async {
    String content =
        "Date :\n${taxCollect.collectedAt!.toDisplayDateTime}\n\nNumero :\n${taxCollect.paymentNumber!}\n\nMontant :\n${taxCollect.amountCollected!.formatAmount} Fcfa\n\n";
    if (contribuable != null) {
      content += "Matricule contribuable :\n${contribuable.matricule}\n\nNom contribuable :\n${contribuable.fullname}\n\n";
    }
    content += "Agent de collecte :\n${user.fullname}";
    return const MethodChannel('androidChannel').invokeMethod('wiseasyPrint', content);
  }
}
