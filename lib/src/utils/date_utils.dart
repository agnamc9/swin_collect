import 'package:intl/intl.dart';

final DateFormat _ddMMyyyyFormat = DateFormat("dd/MM/yyyy à HH:mm:ss");

extension SDateFormat on String {
  String get toDisplayDate {
    return _ddMMyyyyFormat.format(DateTime.parse(this));
  }
}