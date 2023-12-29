import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';

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

  static ResumenJuegoDto mapearResumenJuego(final List<PartidaEntity> listaPartidas) {
    final ResumenJuegoDto resumen = ResumenJuegoDto();

    resumen.partidas = PartidaMapper.mapearListaPartidas(listaPartidas);
    resumen.jugadores = JugadorMapper.mapearListaJugadoresJuego(listaPartidas);

    resumen.cantidadPartidas = listaPartidas.length;
    resumen.cantidadJugadores = _contarJugadores(resumen.partidas);

    if (resumen.partidas.isNotEmpty) {
      resumen.primeraPartida = resumen.partidas.first;
      resumen.ultimaPartida = resumen.partidas.last;
    }

    return resumen;
  }

  static int _contarJugadores(final List<PartidaDto> listaPartidas) {
    Map<int, int> idsJugadores = {};

    for (var partida in listaPartidas) {
      int juego = partida.idJugador;
      if (!idsJugadores.containsKey(juego)) {
        idsJugadores = {...idsJugadores, juego: juego};
      }
    }
    return idsJugadores.length;
  }
}
