import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(num amount) {
    return _formatter.format(amount);
  }

  static String formatShort(num amount) {
    if (amount >= 1000) {
      final inK = amount / 1000;
      if (inK == inK.roundToDouble()) {
        return '₹${inK.toInt()}k';
      }
      return '₹${inK.toStringAsFixed(1)}k';
    }
    return '₹$amount';
  }
}
