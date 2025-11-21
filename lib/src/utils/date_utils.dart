import 'package:intl/intl.dart';

final DateFormat _ddMMyyyyHHmm = DateFormat("dd/MM/yyyy à HH:mm:ss");
final DateFormat _ddMMyyyy = DateFormat("dd/MM/yyyy");

extension SDateFormat on String {
  String get toDisplayDateTime {
    return _ddMMyyyyHHmm.format(DateTime.parse(this));
  }
}

extension DDateFormat on DateTime {
  String get toDisplayDate {
    return _ddMMyyyy.format(this);
  }
}
