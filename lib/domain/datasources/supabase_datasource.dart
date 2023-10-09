import 'package:no_hit/domain/entities/entities.dart';

abstract class SupabaseDatasource {
  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless);

  Future<List<JugadorEntity>> obtenerJugadores();

  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador);

  Future<List<PartidaEntity>> obtenerPartidasPorJuego(int idJuego);

  Future<List<PartidaEntity>> obtenerUltimasPartidas();
}
