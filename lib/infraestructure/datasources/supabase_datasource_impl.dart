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
  Future<List<PartidaEntity>> obtenerPartidasPorJuego(int idJuego) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('partidas')
        .select<List<Map<String, dynamic>>>(
            'id, fecha_partida, nombre_partida, primera_partida_personal, primera_partida_hispano, primera_partida_mundial, offstream, videos_clips, '
            'jugadores(id, nombre_usuario, fecha_primera_partida), '
            'juegos(id, nombre, subtitulo)')
        .eq('juego_id', idJuego)
        .order('id', ascending: true);
    return respuesta.map((partida) => PartidaEntity.fromJson(partida)).toList();
  }

  @override
  Future<List<PartidaEntity>> obtenerUltimasPartidas() async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('partidas')
        .select<List<Map<String, dynamic>>>(
            'id, fecha_partida, nombre_partida, primera_partida_personal, primera_partida_hispano, primera_partida_mundial, offstream, videos_clips, '
            'jugadores(id, nombre_usuario, nacionalidad(pais, codigo_bandera) ), '
            'juegos(id, nombre, subtitulo, url_imagen, oficial_team_hitless)')
        .order('id', ascending: false)
        .limit(5);
    return respuesta.map((partida) => PartidaEntity.fromJson(partida)).toList();
  }
}
