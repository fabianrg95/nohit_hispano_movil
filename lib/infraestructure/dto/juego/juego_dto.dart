import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

class JuegoDto {
  final int id;
  final String nombre;
  final String? subtitulo;
  final String? urlImagen;
  final bool? oficialTeamHistless;

  List<PartidaDto> partidas = [];

  JuegoDto({required this.id, required this.nombre, this.subtitulo, this.urlImagen, this.oficialTeamHistless});

  factory JuegoDto.fromEntity(final JuegoEntity juegoEntity) => JuegoDto(
      id: juegoEntity.id,
      nombre: juegoEntity.nombre,
      subtitulo: juegoEntity.subtitulo,
      urlImagen: juegoEntity.urlImagen,
      oficialTeamHistless: juegoEntity.oficialTeamHitless);
}
