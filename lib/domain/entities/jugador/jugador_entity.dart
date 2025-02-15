import 'package:no_hit/domain/entities/entities.dart';

class JugadorEntity {
  final int id;
  final String? nombre;
  final PronombreEntity? pronombre;
  final String? anioNacimiento;
  final NacionalidadEntity? nacionalidad;
  final String? urlYoutube;
  final String? urlTwitch;
  final String? fechaPrimeraPartida;
  final List<PartidaEntity>? partidas;

  JugadorEntity(
      {required this.id,
      this.nombre,
      this.pronombre,
      this.anioNacimiento,
      this.nacionalidad,
      this.urlYoutube,
      this.urlTwitch,
      this.fechaPrimeraPartida,
      this.partidas});

  factory JugadorEntity.fromJsonBasico(Map<String, dynamic> json) => JugadorEntity(
      id: json['id'],
      nombre: json['nombre_usuario'],
      pronombre: json['pronombre'] != null ? PronombreEntity.fromJson(json['pronombre']) : null,
      nacionalidad: json['nacionalidad'] != null ? NacionalidadEntity.fromJson(json['nacionalidad']) : null);

  factory JugadorEntity.fromJsonDetalle(Map<String, dynamic> json) => JugadorEntity(
      id: json['id'],
      nombre: json['nombre_usuario'],
      pronombre: json['pronombre'] != null ? PronombreEntity.fromJson(json['pronombre']) : null,
      anioNacimiento: json['anio_nacimiento'],
      nacionalidad: json['nacionalidad'] != null ? NacionalidadEntity.fromJson(json['nacionalidad']) : null,
      urlYoutube: json['url_canal_youtube'],
      urlTwitch: json['url_canal_twitch'],
      fechaPrimeraPartida: json['fecha_primera_partida'],
      partidas: json['partidas'] != null ? PartidaEntity.listFromJson(json['partidas']) : null);
}
