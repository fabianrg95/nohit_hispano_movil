import 'package:intl/intl.dart';

class Utilidades {
  static String capitalize(final String texto) {
    return "${texto[0].toUpperCase()}${texto.substring(1).toLowerCase()}";
  }

  static String nombreJuegoCompleto(final String? titulo, final String? subtitulo) {
    return "${titulo ?? ''} ${subtitulo ?? ''}";
  }

  static List<String> obtenerFiltroFechas(String? fechaUltimaPartida) {
    DateTime fechaOriginal = DateTime.now();

    if (fechaUltimaPartida != null) {
      fechaOriginal = DateTime.parse(fechaUltimaPartida).subtract(const Duration(days: 1));
    }

    String primeraFechaDelMes = DateFormat('yyyy-MM-dd').format(DateTime(fechaOriginal.year, fechaOriginal.month, 1));
    String ultimaFechaDelMes = DateFormat('yyyy-MM-dd').format(DateTime(fechaOriginal.year, fechaOriginal.month + 1, 0));

    return [primeraFechaDelMes, ultimaFechaDelMes];
  }
}
