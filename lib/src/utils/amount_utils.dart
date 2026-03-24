import 'package:currency_formatter/currency_formatter.dart';

CurrencyFormat _cs = CurrencyFormat(
  code: '',
  symbol: '',
  symbolSide: SymbolSide.left,
  thousandSeparator: ' ',
  decimalSeparator: ',',
  symbolSeparator: '',
);

extension SAmountUtils on String {
  String get formatAmount => CurrencyFormatter.format(this, _cs);
}

extension NAmountUtils on num {
  String get formatAmount => CurrencyFormatter.format(this, _cs);
}
