import 'package:no_hit/domain/entities/entities.dart';

class Partidas {
  final String nombreJuego;
  List<DetallePartida> partidas;

  Partidas({required this.nombreJuego, required this.partidas});
}
