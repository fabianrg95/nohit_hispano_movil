import 'package:intl/intl.dart';

class HumanFormat {
  static String number(double number) {
    return NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: 'en').format(number);
  }

  static String fecha(String fecha) {
    var parsedDate = DateTime.parse(fecha);
    return DateFormat.yMMMMd('es-CO').format(parsedDate).toString();
  }
}
