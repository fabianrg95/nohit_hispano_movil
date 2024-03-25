import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/commons/filtro_jugadores_dto.dart';

abstract class SupabaseDatasource {
  Future<int> obtenerCantidadJugadores();
  Future<int> obtenerCantidadPartidas();
  Future<int> obtenerCantidadJuegos();

  Future<List<JuegoEntity>> obtenerJuegos(bool oficialTeamHitless);
  Future<List<JuegoEntity>> buscarJuegos(String busqueda);

  Future<List<JugadorEntity>> obtenerJugadores(List<String> letraInicial, final FiltroJugadoresDto? filtros);
  Future<List<JugadorEntity>> buscarJugadores(String busqueda);

  Future<JugadorEntity> obtenerInfromacionJugador(int idJugador);

  Future<List<PartidaEntity>> obtenerPartidasPorJuego(int idJuego);

  Future<JuegoEntity> obtenerInformacionJuego(int idJuego);

  Future<List<PartidaEntity>> obtenerUltimasPartidas(String fechaInicio, String fechaFinal);

  Future<List<JugadorEntity>> obtenerUltimosJugadores();

  Future<PartidaEntity> obtenerInformacionPartida(int idPartida);

  Future<List<NacionalidadEntity>> obtenerNacionalidades();
}
