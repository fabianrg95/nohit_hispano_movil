import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

abstract class SupabaseRepository {
  Future<int> obtenerCantidadJugadores();
  Future<int> obtenerCantidadPartidas();
  Future<int> obtenerCantidadJuegos();

  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless);
  Future<List<JuegoEntity>> obtenerJuegosFavoritos(List<int> idsJuegos);
  Future<List<JuegoEntity>> buscarJuegos(String busqueda);

  Future<List<JugadorEntity>> obtenerJugadores(List<String> letraInicial, final FiltroJugadoresDto? filtros);
  Future<List<JugadorEntity>> obtenerJugadoresFavoritos(List<int> idsJugadores);
  Future<List<JugadorEntity>> buscarJugadores(String busqueda);

  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador);

  Future<List<PartidaEntity>> obtenerPartidasPorJuego(int idJuego);

  Future<JuegoEntity> obtenerInformacionJuego(int idJuego);

  Future<List<PartidaEntity>> obtenerUltimasPartidas(String fechaInicio, String fechaFinal);

  Future<List<JugadorEntity>> obtenerUltimosJugadores();

  Future<PartidaEntity> obtenerInfromacionPartida(int idPartida);

  Future<List<NacionalidadEntity>> obtenerNacionalidades();

  Future<List<PronombreEntity>> obtenerPronombres();
}
