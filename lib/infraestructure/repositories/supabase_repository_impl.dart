import 'package:no_hit/domain/datasources/supabase_datasource.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/domain/repositories/supabase_repository.dart';

class SupabaseRepositoryImpl extends SupabaseRepository {
  final SupabaseDatasource datasource;

  SupabaseRepositoryImpl(this.datasource);

  @override
  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless) {
    return datasource.obtenerJuegos(oficialTeamHitless);
  }

  @override
  Future<List<JugadorEntity>> obtenerJugadores() {
    return datasource.obtenerJugadores();
  }

  @override
  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador) {
    return datasource.obtenerInfromacionJugador(idJugador);
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
