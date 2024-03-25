import 'package:no_hit/domain/datasources/supabase_datasource.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatasourceImpl extends SupabaseDatasource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<JuegoEntity>> obtenerJuegos(final bool oficialTeamHitless) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('juegos')
        .select('id, nombre, subtitulo, url_imagen, oficial_team_hitless')
        .eq('oficial_team_hitless', oficialTeamHitless)
        .order('nombre', ascending: true);

    return respuesta.map((juego) => JuegoEntity.fromJson(juego)).toList();
  }

  @override
  Future<List<JuegoEntity>> buscarJuegos(String busqueda) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('juegos')
        .select('id, nombre, subtitulo, url_imagen, oficial_team_hitless')
        .or('nombre.ilike.%$busqueda%, subtitulo.ilike.%$busqueda%')
        .order('nombre', ascending: true);

    return respuesta.map((juego) => JuegoEntity.fromJson(juego)).toList();
  }

  @override
  Future<List<JugadorEntity>> obtenerJugadores(final List<String> letraInicial, final FiltroJugadoresDto? filtros) async {
    PostgrestFilterBuilder query = supabase.from('jugadores').select('''id, nombre_usuario, nacionalidad!left(id, codigo_bandera))''');

    if (filtros == null ||
        ((filtros.listaNacionalidades == null || filtros.listaNacionalidades!.isEmpty) &&
            (filtros.listaGeneros == null || filtros.listaGeneros!.isEmpty))) {
      query = query.ilikeAnyOf('nombre_usuario', letraInicial);
    }

    if (filtros != null && filtros.listaNacionalidades != null && filtros.listaNacionalidades!.isNotEmpty) {
      query = query.inFilter('nacionalidad_id', filtros.listaNacionalidades!);
    }

    if (filtros != null && filtros.listaGeneros != null && filtros.listaGeneros!.isNotEmpty) {
      query = query.inFilter('pronombre_id', filtros.listaGeneros!);
      print('consultando generos' + filtros.listaGeneros.toString());
    }

    final List<Map<String, dynamic>> respuesta = await query.order('nombre_usuario', ascending: true);
    return respuesta.map((jugador) => JugadorEntity.fromJsonBasico(jugador)).toList();
  }

  @override
  Future<List<JugadorEntity>> buscarJugadores(String busqueda) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('jugadores')
        .select('id, nombre_usuario, nacionalidad(codigo_bandera))')
        .ilike('nombre_usuario', '%$busqueda%')
        .order('nombre_usuario', ascending: true);
    return respuesta.map((jugador) => JugadorEntity.fromJsonBasico(jugador)).toList();
  }

  @override
  Future<JugadorEntity> obtenerInfromacionJugador(final int idJugador) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('jugadores')
        .select('id, nombre_usuario, url_canal_youtube, url_canal_twitch, fecha_primera_partida, '
            'pronombre(pronombre, genero), '
            'nacionalidad(pais, codigo_bandera, gentilicio_masculino, gentilicio_femenino, neutro), '
            'partidas(id, fecha_partida, nombre_partida, juegos(id, nombre, subtitulo, url_imagen, oficial_team_hitless), jugadores(id)))')
        .eq('id', idJugador)
        .order('id', referencedTable: 'partidas', ascending: true);
    return respuesta.map((jugador) => JugadorEntity.fromJsonDetalle(jugador)).first;
  }

  @override
  Future<List<PartidaEntity>> obtenerPartidasPorJuego(final int idJuego) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('partidas')
        .select(
            'id, fecha_partida, nombre_partida, primera_partida_personal, primera_partida_hispano, primera_partida_mundial, offstream, videos_clips, '
            'jugadores(id, nombre_usuario, fecha_primera_partida, nacionalidad(pais, codigo_bandera, gentilicio_masculino, gentilicio_femenino, neutro)), '
            'juegos(id, nombre, subtitulo)')
        .eq('juego_id', idJuego)
        .order('id', ascending: true);
    return respuesta.map((partida) => PartidaEntity.fromJson(partida)).toList();
  }

  @override
  Future<List<PartidaEntity>> obtenerUltimasPartidas(String fechaInicio, String fechaFinal) async {
    final List<Map<String, dynamic>> respuesta = await supabase
            .from('partidas')
            .select(
                'id, fecha_partida, nombre_partida, primera_partida_personal, primera_partida_hispano, primera_partida_mundial, offstream, videos_clips, '
                'jugadores(id, nombre_usuario, nacionalidad(pais, codigo_bandera) ), '
                'juegos(id, nombre, subtitulo, url_imagen, oficial_team_hitless)')
            .gte('fecha_partida', fechaInicio)
            .lte('fecha_partida', fechaFinal)
            .order('fecha_partida', ascending: false)
            .order('id', ascending: false)
        //.limit(10)
        ;
    return respuesta.map((partida) => PartidaEntity.fromJson(partida)).toList();
  }

  @override
  Future<List<JugadorEntity>> obtenerUltimosJugadores() async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('jugadores')
        .select('id, nombre_usuario, anio_nacimiento,'
            ' pronombre(pronombre, genero),'
            ' nacionalidad(pais, codigo_bandera, gentilicio_masculino, gentilicio_femenino, neutro))')
        .order('fecha_creacion', ascending: false)
        .limit(10);
    return respuesta.map((jugador) => JugadorEntity.fromJsonBasico(jugador)).toList();
  }

  @override
  Future<PartidaEntity> obtenerInformacionPartida(final int idPartida) async {
    final List<Map<String, dynamic>> respuesta = await supabase
        .from('partidas')
        .select(
            'id, fecha_partida, nombre_partida, primera_partida_personal, primera_partida_hispano, primera_partida_mundial, offstream, videos_clips, '
            'jugadores(id, nombre_usuario, fecha_primera_partida), '
            'juegos(id, nombre, subtitulo, url_imagen, oficial_team_hitless)')
        .eq('id', idPartida)
        .limit(1);
    return PartidaEntity.fromJson(respuesta.first);
  }

  @override
  Future<int> obtenerCantidadJugadores() async {
    final respuesta = await supabase.from('jugadores').select('id').count();
    return respuesta.count;
  }

  @override
  Future<int> obtenerCantidadPartidas() async {
    final respuesta = await supabase.from('partidas').select('id').count();
    return respuesta.count;
  }

  @override
  Future<int> obtenerCantidadJuegos() async {
    final respuesta = await supabase.from('juegos').select('id').count();
    return respuesta.count;
  }

  @override
  Future<JuegoEntity> obtenerInformacionJuego(final int idJuego) async {
    final respuesta = await supabase
        .from('juegos')
        .select('id, nombre, subtitulo, url_imagen, oficial_team_hitless')
        .eq('id', idJuego)
        .order('nombre', ascending: true)
        .single();

    return JuegoEntity.fromJson(respuesta);
  }

  @override
  Future<List<NacionalidadEntity>> obtenerNacionalidades() async {
    final List<Map<String, dynamic>> respuesta =
        await supabase.from('nacionalidad').select('id, pais, codigo_bandera').order('pais', ascending: true);

    return respuesta.map((nacionalidad) => NacionalidadEntity.basicFromJson(nacionalidad)).toList();
  }

  @override
  Future<List<PronombreEntity>> obtenerPronombres() async {
    final List<Map<String, dynamic>> respuesta = await supabase.from('pronombre').select('id, pronombre, genero').order('genero', ascending: true);

    return respuesta.map((pronombre) => PronombreEntity.fromJson(pronombre)).toList();
  }
}
