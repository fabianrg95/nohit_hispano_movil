import 'package:no_hit/infraestructure/dto/dtos.dart';

class ResumenJuegoDto {
  int cantidadPartidas = 0;
  int cantidadJugadores = 0;
  bool oficialTeamHitless = false;
  PartidaDto? primeraPartida;
  PartidaDto? ultimaPartida;

  List<PartidaDto> partidas = [];
  List<JugadorDto> jugadores = [];

  ResumenJuegoDto();
}
