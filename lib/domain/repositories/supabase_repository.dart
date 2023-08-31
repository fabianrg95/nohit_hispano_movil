import 'package:no_hit/domain/entities/entities.dart';

abstract class SupabaseRepository {
  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless);

  Future<List<JugadorEntity>> obtenerJugadores();

  Future<List<JugadorEntity>> obtenerUltimasPartidas(int cantidad);

  Future<JuegoEntity> obtenerInfromacionJuego(int idJuego);

  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador);

  Future<PartidaEntity> obtenerInformacionPartida(int idPartida);
}
