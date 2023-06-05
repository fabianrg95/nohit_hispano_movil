import 'package:no_hit/domain/datasources/supabase_datasource.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/domain/repositories/supabase_repository.dart';

class SupabaseRepositoryImpl extends SupabaseRepository {
  final SupabaseDatasource datasource;

  SupabaseRepositoryImpl(this.datasource);

  @override
  Future<List<Juego>> obtenerJuegos(bool oficialTeamHitless) {
    return datasource.obtenerJuegos(oficialTeamHitless);
  }

  @override
  Future<List<Jugador>> obtenerJugadores() {
    return datasource.obtenerJugadores();
  }

  @override
  Future<DetalleJugador> obtenerInfromacionJugador(int idJugador) {
    return datasource.obtenerInfromacionJugador(idJugador);
  }
}
