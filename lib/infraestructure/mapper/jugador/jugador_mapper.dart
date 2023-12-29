import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/partida/partida_mapper.dart';

class JugadorMapper {
  static JugadorDto entityToDtoBasico(final JugadorEntity jugadorEntity) =>
      JugadorDto(id: jugadorEntity.id, nombre: jugadorEntity.nombre, codigoBandera: jugadorEntity.nacionalidad?.codigoBandera);

  static JugadorDto entityToDtoDetalle(final JugadorEntity jugadorEntity) {
    JugadorDto jugadorDto = JugadorDto(
        id: jugadorEntity.id,
        nombre: jugadorEntity.nombre,
        pronombre: jugadorEntity.pronombre?.pronombre,
        urlYoutube: jugadorEntity.urlYoutube,
        urlTwitch: jugadorEntity.urlTwitch,
        codigoBandera: jugadorEntity.nacionalidad?.codigoBandera);

    jugadorDto.mostrarInformacion =
        jugadorDto.gentilicio != null || jugadorDto.pronombre != null || jugadorDto.urlYoutube != null || jugadorDto.urlTwitch != null;

    jugadorDto.gentilicio = JugadorMapper.obtenerGentilicio(jugadorEntity.pronombre, jugadorEntity.nacionalidad);

    if (jugadorEntity.partidas != null) {
      jugadorDto.partidas = jugadorEntity.partidas!.map((partidaEntity) => PartidaMapper.entityToDto(partidaEntity)).toList();

      _definirAnalisisPartidas(jugadorDto);
    }

    return jugadorDto;
  }

  static List<JugadorDto> mapearListaJugadores(final List<JugadorEntity> jugadores) {
    return jugadores.map((entity) => entityToDtoBasico(entity)).toList();
  }

  static List<JugadorDto> mapearListaJugadoresDetalle(final List<JugadorEntity> jugadores) {
    return jugadores.map((entity) => entityToDtoDetalle(entity)).toList();
  }

  static String obtenerGentilicio(final PronombreEntity? pronombre, final NacionalidadEntity? nacionalidad) {
    if (pronombre != null && nacionalidad != null) {
      if (pronombre.genero == 'Neutro') return nacionalidad.gentilicioNeutro!;
      if (pronombre.genero == 'Femenino') return nacionalidad.gentilicioFemenino!;
      if (pronombre.genero == 'Masculino') return nacionalidad.gentilicioMasculino!;
      return '';
    } else {
      return '';
    }
  }

  static void _definirAnalisisPartidas(final JugadorDto jugadorDto) {
    jugadorDto.cantidadPartidas = jugadorDto.partidas.length;
    Map<int, int> mapaJuegos = {};
    List<JuegoDto> juegos = [];

    if (jugadorDto.partidas.isNotEmpty) {
      for (var partida in jugadorDto.partidas) {
        int juego = partida.idJuego;
        if (!mapaJuegos.containsKey(juego)) {
          juegos.add(_agruparPartidas(partida, jugadorDto.partidas));
          mapaJuegos = {...mapaJuegos, juego: juego};
        }
      }
    }

    jugadorDto.juegos = juegos;
    jugadorDto.primeraPartida = jugadorDto.partidas.first;
    jugadorDto.ultimaPartida = jugadorDto.partidas.last;
  }

  static JuegoDto _agruparPartidas(final PartidaDto partida, final List<PartidaDto> partidas) {
    JuegoDto juego = JuegoDto(
        id: partida.idJuego, nombre: partida.tituloJuego.toString(), subtitulo: partida.subtituloJuego.toString(), urlImagen: partida.urlImagenJuego);
    juego.partidas = partidas.where((filtro) => filtro.idJuego == partida.idJuego).toList();

    return juego;
  }

  static List<JugadorDto> mapearListaJugadoresJuego(List<PartidaEntity> partidas) {
    Map<int, JugadorDto> listaJugadores = {};

    for (var partida in partidas) {
      if (listaJugadores[partida.jugador!.id] == null) {
        listaJugadores = {...listaJugadores, partida.jugador!.id: entityToDtoBasico(partida.jugador!)};
      }
    }

    return listaJugadores.values.toList();
  }
}
