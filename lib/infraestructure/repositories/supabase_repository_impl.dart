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
  Future<List<PartidaEntity>> obtenerPartidasPorJuego(int idJuego) {
    return datasource.obtenerPartidasPorJuego(idJuego);
  }
  
  @override
  Future<List<PartidaEntity>> obtenerUltimasPartidas() {
    return datasource.obtenerUltimasPartidas();
  }
}
