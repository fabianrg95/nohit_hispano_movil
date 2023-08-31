import 'package:no_hit/infraestructure/dto/dtos.dart';

class JugadorDto {
  final int? id;
  final String? nombre;
  final String? pronombre;
  final String? anioNacimiento;
  final String? nacionalidad;
  final String? codigoBandera;
  final String? urlYoutube;
  final String? urlTwitch;

  PartidaDto? primeraPartida;
  PartidaDto? ultimaPartida;

  String? gentilicio;

  List<PartidaDto> partidas = [];
  List<JuegoDto> juegos = [];
  int cantidadPartidas = 0;

  bool mostrarInformacion = false;

  JugadorDto({this.id, this.nombre, this.pronombre, this.anioNacimiento, this.nacionalidad, this.codigoBandera, this.urlYoutube, this.urlTwitch});
}
