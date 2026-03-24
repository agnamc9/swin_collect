import 'package:flutter/services.dart';
import 'package:tax_collect/src/utils/date_utils.dart';

import '../data/data.dart';

class PrintUtils {
  PrintUtils._();

  static startPrint(TaxCollect taxCollect, User user) async {
    String content =
        "Date :\n${taxCollect.collectedAt!.toDisplayDateTime}\n\nNumero :\n${taxCollect.paymentNumber!}\n\nMontant :\n${taxCollect.amountCollected!} Fcfa\n\nAgent de collecte :\n${user.fullname}";
    return const MethodChannel('androidChannel').invokeMethod('wiseasyPrint', content);
  }
}
