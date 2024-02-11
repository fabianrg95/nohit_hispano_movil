import 'package:no_hit/domain/entities/entities.dart';

abstract class SupabaseDatasource {
  Future<int> obtenerCantidadJugadores();
  Future<int> obtenerCantidadPartidas();
  Future<int> obtenerCantidadJuegos();

  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless);

  Future<List<JugadorEntity>> obtenerJugadores();

  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador);

  Future<List<PartidaEntity>> obtenerPartidasPorJuego(int idJuego);

  Future<JuegoEntity> obtenerInformacionJuego(int idJuego);

  Future<List<PartidaEntity>> obtenerUltimasPartidas(String fechaInicio, String fechaFinal);

  Future<List<JugadorEntity>> obtenerUltimosJugadores();

  Future<PartidaEntity> obtenerInformacionPartida(int idPartida);
}
