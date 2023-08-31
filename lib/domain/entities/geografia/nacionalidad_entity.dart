import 'package:no_hit/domain/entities/entities.dart';

class NacionalidadEntity {
  final int? id;
  final String? pais;
  final String? codigoBandera;
  final ContinenteEntity? continente;
  final String? gentilicioMasculino;
  final String? gentilicioFemenino;
  final String? gentilicioNeutro;

  NacionalidadEntity(
      {this.id,
      this.pais,
      this.codigoBandera,
      this.continente,
      this.gentilicioMasculino,
      this.gentilicioFemenino,
      this.gentilicioNeutro});

  factory NacionalidadEntity.basicFromJson(Map<String, dynamic> json) =>
      NacionalidadEntity(
          id: json['id'],
          pais: json['pais'],
          codigoBandera: json['codigo_bandera']);

  factory NacionalidadEntity.fromJson(Map<String, dynamic> json) =>
      NacionalidadEntity(
          id: json['id'],
          pais: json['pais'],
          codigoBandera: json['codigo_bandera'],
          continente: json['continente'] != null
              ? ContinenteEntity.fromJson(json['continente'])
              : null,
          gentilicioMasculino: json['gentilicio_masculino'],
          gentilicioFemenino: json['gentilicio_femenino'],
          gentilicioNeutro: json['neutro']);
}
