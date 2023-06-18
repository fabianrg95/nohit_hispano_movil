import 'package:no_hit/domain/entities/entities.dart';

class Partidas {
  final Juego juego;
  List<DetallePartida> partidas;

  Partidas({required this.juego, required this.partidas});
}
