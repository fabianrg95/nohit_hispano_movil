import 'package:no_hit/domain/datasources/supabase_datasource.dart';
import 'package:no_hit/domain/entities/detalle_jugador.dart';
import 'package:no_hit/domain/entities/juego.dart';
import 'package:no_hit/domain/entities/jugador.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatasourceImpl extends SupabaseDatasource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Juego>> obtenerJuegos(bool oficialTeamHitless) async {
    final respuesta = await supabase
        .from('juegos')
        .select<List<Map<String, dynamic>>>(
            'id, nombre, subtitulo, url_imagen, oficial_team_hitless')
        .eq('oficial_team_hitless', oficialTeamHitless). order('nombre', ascending: true);
    return JuegoMapper.supabaseToEntity(respuesta);
  }

  @override
  Future<List<Jugador>> obtenerJugadores() async {
    final respuesta = await supabase
        .from('jugadores')
        .select<List<Map<String, dynamic>>>(
            'id, nombre_usuario, pronombre(pronombre), nacionalidad(pais, codigo_bandera, continente(nombre)), partidas(id))')
        .order('id', ascending: true);
    return JugadorMapper.supabaseToEntity(respuesta);
  }

  @override
  Future<DetalleJugador> obtenerInfromacionJugador(int idJugador) async {
    final respuesta = await supabase
        .from('jugadores')
        .select<List<Map<String, dynamic>>>(
            'id, nombre_usuario, anio_nacimiento, url_canal_youtube, url_canal_twitch, '
            'pronombre(pronombre, genero), '
            'nacionalidad(pais, codigo_bandera, gentilicio_masculino, gentilicio_femenino, neutro, continente(nombre)), '
            'partidas(id, nombre_partida, juegos(id, nombre, subtitulo, url_imagen, oficial_team_hitless)))')
        .eq('id', idJugador);
    return JugadorMapper.detalleJugadorToEntity(respuesta);
  }
}
