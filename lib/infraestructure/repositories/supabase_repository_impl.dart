import 'package:no_hit/domain/datasources/supabase_datasource.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/domain/repositories/supabase_repository.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

class SupabaseRepositoryImpl extends SupabaseRepository {
  final SupabaseDatasource datasource;

  SupabaseRepositoryImpl(this.datasource);

  @override
  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless) {
    return datasource.obtenerJuegos(oficialTeamHitless);
  }

  @override
  Future<List<JuegoEntity>> buscarJuegos(String busqueda) {
    return datasource.buscarJuegos(busqueda);
  }

  @override
  Future<List<JugadorEntity>> obtenerJugadores(final List<String> letraInicial, final FiltroJugadoresDto? filtros) {
    return datasource.obtenerJugadores(letraInicial, filtros);
  }

  @override
  Future<List<JugadorEntity>> buscarJugadores(String busqueda) {
    return datasource.buscarJugadores(busqueda);
  }

  @override
  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador) {
    return datasource.obtenerInfromacionJugador(idJugador);
  }

  @override
  Future<List<PartidaEntity>> obtenerPartidasPorJuego(int idJuego) {
    return datasource.obtenerPartidasPorJuego(idJuego);
  }

  @override
  Future<List<PartidaEntity>> obtenerUltimasPartidas(String fechaInicio, String fechaFinal) {
    return datasource.obtenerUltimasPartidas(fechaInicio, fechaFinal);
  }

  @override
  Future<List<JugadorEntity>> obtenerUltimosJugadores() {
    return datasource.obtenerUltimosJugadores();
  }

  @override
  Future<PartidaEntity> obtenerInfromacionPartida(final int idPartida) {
    return datasource.obtenerInformacionPartida(idPartida);
  }

  @override
  Future<int> obtenerCantidadJugadores() {
    return datasource.obtenerCantidadJugadores();
  }

  @override
  Future<int> obtenerCantidadPartidas() {
    return datasource.obtenerCantidadPartidas();
  }

  @override
  Future<int> obtenerCantidadJuegos() {
    return datasource.obtenerCantidadJuegos();
  }

  @override
  Future<JuegoEntity> obtenerInformacionJuego(int idJuego) {
    return datasource.obtenerInformacionJuego(idJuego);
  }

  @override
  Future<List<NacionalidadEntity>> obtenerNacionalidades() {
    return datasource.obtenerNacionalidades();
  }

  @override
  Future<List<PronombreEntity>> obtenerPronombres() {
    return datasource.obtenerPronombres();
  }
}
