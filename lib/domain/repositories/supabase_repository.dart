import 'package:no_hit/domain/entities/entities.dart';

abstract class SupabaseRepository {
  Future<int> obtenerCantidadJugadores();
  Future<int> obtenerCantidadPartidas();
  Future<int> obtenerCantidadJuegos();

  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless);

  Future<List<JugadorEntity>> obtenerJugadores();

  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador);

  Future<List<PartidaEntity>> obtenerPartidasPorJuego(int idJuego);

  Future<JuegoEntity> obtenerInformacionJuego(int idJuego);

  Future<List<PartidaEntity>> obtenerUltimasPartidas();

  Future<List<JugadorEntity>> obtenerUltimosJugadores();

  Future<PartidaEntity> obtenerInfromacionPartida(int idPartida);
}
