import 'package:intl/intl.dart';

class Utilidades {
  static String capitalize(final String texto) {
    return "${texto[0].toUpperCase()}${texto.substring(1).toLowerCase()}";
  }

  static String nombreJuegoCompleto(final String? titulo, final String? subtitulo) {
    return "${titulo ?? ''} ${subtitulo ?? ''}";
  }

  static List<String> obtenerFiltroFechas(String? fechaUltimaPartida, final bool esReload) {
    DateTime fechaOriginal = DateTime.now();

    if (!esReload && fechaUltimaPartida != null) {
      final DateTime fechaParsed = DateTime.parse(fechaUltimaPartida);
      final int numeroDia = fechaParsed.day;
      fechaOriginal = fechaParsed.subtract(Duration(days: numeroDia));
    }

    String primeraFechaDelMes = DateFormat('yyyy-MM-dd').format(DateTime(fechaOriginal.year, fechaOriginal.month, 1));
    String ultimaFechaDelMes = DateFormat('yyyy-MM-dd').format(DateTime(fechaOriginal.year, fechaOriginal.month + 1, 0));

    return [primeraFechaDelMes, ultimaFechaDelMes];
  }
}
