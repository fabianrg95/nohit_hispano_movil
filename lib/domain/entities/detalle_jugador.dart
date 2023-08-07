import 'package:no_hit/domain/entities/entities.dart';

class DetalleJugador extends Jugador {
  final String? anioNacimiento;
  final String? urlYoutube;
  final String? urlTwitch;
  final String? genero;
  final String? gentilicioMasculino;
  final String? gentilicioFemenino;
  final String? gentilicioNeutro;
  final List<Partidas> partidas;

  DetalleJugador(
      {required super.id,
      required super.nombre,
      required super.pronombre,
      required super.pais,
      required super.cantidadPartidas,
      required super.fechaPrimeraPartida,
      super.continente,
      super.codigoBandera,
      this.anioNacimiento,
      this.urlYoutube,
      this.urlTwitch,
      this.genero,
      this.gentilicioMasculino,
      this.gentilicioFemenino,
      this.gentilicioNeutro,
      required this.partidas});
}
