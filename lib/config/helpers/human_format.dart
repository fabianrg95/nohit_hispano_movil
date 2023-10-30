import 'package:intl/intl.dart';

class HumanFormat {
  static String number(double number) {
    return NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: 'en').format(number);
  }

  static String fecha(String fecha) {
    var parsedDate = DateTime.parse(fecha);
    return DateFormat.yMMMMd('es-CO').format(parsedDate).toString();
  }

  static String fechaDia(String fecha) {
    var parsedDate = DateTime.parse(fecha);
    return DateFormat.d('es-CO').format(parsedDate).toString();
  }

  static String fechaMes(String fecha) {
    var parsedDate = DateTime.parse(fecha);
    return capitalize(DateFormat.MMM('es-CO').format(parsedDate).toString());
  }

  static String capitalize(final String texto) {
    return "${texto[0].toUpperCase()}${texto.substring(1).toLowerCase()}";
  }
}
