import 'package:no_hit/infraestructure/dto/dtos.dart';

class ResumenJuegoDto {
  int cantidadPartidas = 0;
  int cantidadJugadores = 0;
  PartidaDto? primeraPartida;
  PartidaDto? ultimaPartida;

  List<PartidaDto> partidas = [];

  ResumenJuegoDto();
}
