import 'package:no_hit/domain/entities/entities.dart';

class JugadorMapper {
  static List<Jugador> supabaseToEntity(List<Map<String, dynamic>> respuesta) {
    final List<Jugador> jugadores = [];
    for (var element in respuesta) {
      final List partidas = element['partidas'];
      jugadores.add(Jugador(
          id: element['id'],
          nombre: element['nombre_usuario'],
          pronombre: element['pronombre'] != null
              ? element['pronombre']['pronombre']
              : null,
          pais: element['nacionalidad'] != null
              ? element['nacionalidad']['pais']
              : null,
          codigoBandera: element['nacionalidad'] != null
              ? element['nacionalidad']['codigo_bandera']
              : null,
          continente: element['nacionalidad'] != null &&
                  element['nacionalidad']['continente'] != null
              ? element['nacionalidad']['continente']['nombre']
              : null,
          cantidadPartidas: partidas.length));
    }
    return jugadores;
  }

  static DetalleJugador detalleJugadorToEntity(
      List<Map<String, dynamic>> respuesta) {
    for (var detalle in respuesta) {
      final List partidasSupa = detalle['partidas'];

      final List<Partidas> partidas = [];
      Map<String, Partidas> mapaPartidas = {};
      partidasSupa.sort((a, b) =>
          a['juegos']['nombre'].toString().compareTo(b['juegos']['nombre']));
      for (var run in partidasSupa) {
        var nombreJuego = run['juegos']['nombre'];
        if (!mapaPartidas.containsKey(nombreJuego)) {
          var listaPartidasAgrupadas = Partidas(
              juego: Juego(
                  id: run['juegos']['id'],
                  nombre: run['juegos']['nombre'],
                  subtitulo: run['juegos']['subtitulo'],
                  oficialTeamHitles: run['juegos']['oficial_team_hitless'],
                  urlImagen: run['juegos']['url_imagen']),
              partidas: _obtenerPartidas(nombreJuego, partidasSupa));
          mapaPartidas = {...mapaPartidas, nombreJuego: listaPartidasAgrupadas};
          partidas.add(listaPartidasAgrupadas);
        }
      }

      return DetalleJugador(
          id: detalle['id'],
          nombre: detalle['nombre_usuario'],
          anioNacimiento: detalle['anio_nacimiento'],
          urlTwitch: detalle['url_canal_twitch'],
          urlYoutube: detalle['url_canal_youtube'],
          pronombre: detalle['pronombre'] != null
              ? detalle['pronombre']['pronombre']
              : null,
          genero: detalle['pronombre'] != null
              ? detalle['pronombre']['genero']
              : null,
          pais: detalle['nacionalidad'] != null
              ? detalle['nacionalidad']['pais']
              : null,
          gentilicioFemenino: detalle['nacionalidad'] != null
              ? detalle['nacionalidad']['gentilicio_femenino']
              : null,
          gentilicioMasculino: detalle['nacionalidad'] != null
              ? detalle['nacionalidad']['gentilicio_masculino']
              : null,
          gentilicioNeutro: detalle['nacionalidad'] != null
              ? detalle['nacionalidad']['neutro']
              : null,
          codigoBandera: detalle['nacionalidad'] != null
              ? detalle['nacionalidad']['codigo_bandera']
              : null,
          continente: detalle['nacionalidad'] != null &&
                  detalle['nacionalidad']['continente'] != null
              ? detalle['nacionalidad']['continente']['nombre']
              : null,
          cantidadPartidas: partidas.length,
          partidas: partidas);
    }

    return DetalleJugador(
        id: 0,
        nombre: '',
        pronombre: '',
        pais: '',
        cantidadPartidas: 0,
        partidas: []);
  }

  static _obtenerPartidas(String nombreJuego, List partidasSupa) {
    final List<DetallePartida> partidas = [];

    for (var run in partidasSupa) {
      if (nombreJuego == run['juegos']['nombre']) {
        partidas
            .add(DetallePartida(id: run['id'], nombre: run['nombre_partida']));
      }
    }
    return partidas;
  }
}
