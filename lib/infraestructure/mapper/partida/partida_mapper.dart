import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

class PartidaMapper {
  static PartidaDto entityToDto(final PartidaEntity partidaEntity) {
    final PartidaDto partidas = PartidaDto(
        id: partidaEntity.id,
        idJuego: partidaEntity.juego == null ? 0 : partidaEntity.juego!.id,
        idJugador: partidaEntity.jugador == null ? 0 : partidaEntity.jugador!.id,
        nombre: partidaEntity.nombrePartida,
        fecha: partidaEntity.fechaPartida,
        nombreJugador: partidaEntity.jugador?.nombre,
        tituloJuego: partidaEntity.juego?.nombre,
        subtituloJuego: partidaEntity.juego?.subtitulo,
        urlImagenJuego: partidaEntity.juego?.urlImagen,
        primeraPartidaHispano: partidaEntity.primeraPartidaHispano,
        primeraPartidaJugador: partidaEntity.primeraPartidaPersonal,
        primeraPartidaMundo: partidaEntity.primeraPartidaMundial);

    List<String>? links = partidaEntity.videosClips?.split(",");

    List<String>? videosCompletos = [];
    List<String>? videosClips = [];

    if (links != null && links.isNotEmpty) {
      for (final link in links) {
        link.contains("clip") ? videosClips.add(link) : videosCompletos.add(link);
      }
      partidas.listaVideosCompletos = videosCompletos;
      partidas.listaVideosClips = videosClips;
    }

    return partidas;
  }

  static List<PartidaDto> mapearListaPartidas(final List<PartidaEntity> partidas) {
    return partidas.map((entity) => entityToDto(entity)).toList();
  }
}
