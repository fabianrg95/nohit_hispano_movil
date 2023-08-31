import 'package:no_hit/domain/datasources/supabase_datasource.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatasourceImpl extends SupabaseDatasource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('juegos')
        .select<List<Map<String, dynamic>>>('id, nombre, subtitulo, url_imagen, oficial_team_hitless')
        .eq('oficial_team_hitless', oficialTeamHitless)
        .order('nombre', ascending: true);

    return respuesta.map((juego) => JuegoEntity.fromJson(juego)).toList();
  }

  @override
  Future<List<JugadorEntity>> obtenerJugadores() async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('jugadores')
        .select<List<Map<String, dynamic>>>('id, nombre_usuario, nacionalidad(codigo_bandera))')
        .order('id', ascending: true);
    return respuesta.map((jugador) => JugadorEntity.fromJsonBasico(jugador)).toList();
  }

  @override
  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('jugadores')
        .select<List<Map<String, dynamic>>>('id, nombre_usuario, url_canal_youtube, url_canal_twitch, fecha_primera_partida, '
            'pronombre(pronombre, genero), '
            'nacionalidad(pais, codigo_bandera, gentilicio_masculino, gentilicio_femenino, neutro), '
            'partidas(id, fecha_partida, nombre_partida, juegos(id, nombre, subtitulo, url_imagen, oficial_team_hitless)))')
        .eq('id', idJugador)
        .order('id', foreignTable: 'partidas', ascending: true);
    return respuesta.map((jugador) => JugadorEntity.fromJsonDetalle(jugador)).first;
  }

  @override
  Future<PartidaEntity> obtenerInformacionPartida(int idPartida) {
    // TODO: implement obtenerInformacionPartida
    throw UnimplementedError();
  }

  @override
  Future<JuegoEntity> obtenerInfromacionJuego(int idJuego) {
    // TODO: implement obtenerInfromacionJuego
    throw UnimplementedError();
  }

  @override
  Future<List<JugadorEntity>> obtenerUltimasPartidas(int cantidad) {
    // TODO: implement obtenerUltimasPartidas
    throw UnimplementedError();
  }
}
