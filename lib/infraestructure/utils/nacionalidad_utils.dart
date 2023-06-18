import 'package:no_hit/domain/entities/entities.dart';

class Nacionalidad {
  static String obtenerGentilicioJugador(DetalleJugador jugador) {
    switch (jugador.genero) {
      case 'Neutro':
        {
          return jugador.gentilicioNeutro.toString();
        }

      case 'Femenino':
        {
          return jugador.gentilicioFemenino.toString();
        }

      case 'Masculino':
        {
          return jugador.gentilicioMasculino.toString();
        }
    }
    return '';
  }
}
