import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

class JuegoMapper {
  static JuegoDto entityToDto(final JuegoEntity juegoEntity) => JuegoDto(
      id: juegoEntity.id,
      nombre: juegoEntity.nombre,
      subtitulo: juegoEntity.subtitulo,
      urlImagen: juegoEntity.urlImagen,
      oficialTeamHistless: juegoEntity.oficialTeamHitless);

  static List<JuegoDto> mapearListaJuegos(final List<JuegoEntity> juegos) {
    return juegos.map((entity) => entityToDto(entity)).toList();
  }
}
