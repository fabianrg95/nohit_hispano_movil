import 'package:no_hit/domain/entities/entities.dart';

class PartidaEntity {
  final int id;
  final String? fechaPartida;
  final JuegoEntity? juego;
  final String? nombrePartida;
  final JugadorEntity? jugador;
  bool? primeraPartidaPersonal;
  bool? primeraPartidaHispano;
  bool? primeraPartidaMundial;
  final String? videosClips;
  final bool? offstream;
  final String? urlImagen;

  PartidaEntity({
    required this.id,
    this.fechaPartida,
    this.juego,
    this.nombrePartida,
    this.jugador,
    this.primeraPartidaPersonal = false,
    this.primeraPartidaHispano = false,
    this.primeraPartidaMundial = false,
    this.videosClips,
    this.offstream,
    this.urlImagen,
  });

  factory PartidaEntity.fromJson(Map<String, dynamic> json) => PartidaEntity(
      id: json['id'],
      fechaPartida: json['fecha_partida'],
      juego: json['juegos'] != null ? JuegoEntity.fromJson(json['juegos']) : null,
      nombrePartida: json['nombre_partida'],
      jugador: json['jugadores'] != null ? JugadorEntity.fromJsonBasico(json['jugadores']) : null,
      primeraPartidaPersonal: json['primera_partida_personal'],
      primeraPartidaHispano: json['primera_partida_hispano'],
      primeraPartidaMundial: json['primera_partida_mundia'],
      urlImagen: json['url_imagen'],
      offstream: json['offstream'],
      videosClips: json['videos_clips']);

  static List<PartidaEntity> listFromJson(List<dynamic> lista) {
    return lista.map((json) => PartidaEntity.fromJson(json)).toList();
  }
}
