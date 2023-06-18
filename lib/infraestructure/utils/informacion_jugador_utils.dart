import 'package:no_hit/domain/entities/detalle_jugador.dart';

class InformacionJugadorUtils {
  static bool validarInformacionJugador(DetalleJugador jugador) {
    bool respuesta = false;

    respuesta = jugador.genero != null ||
        jugador.pais != null ||
        jugador.urlYoutube != null ||
        jugador.urlTwitch != null;

    return respuesta;
  }
}
