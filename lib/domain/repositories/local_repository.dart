abstract class LocalRepository {
  Future<void> guardarEsTemaClaro(final bool temaClaroSeleccinado);
  Future<bool> obtenerEsTemaClaro();

  Future<void> guardarIntroduccionFinalizada(final bool introduccionFinalizada);
  Future<bool> obtenerIntroduccionFinalizada();

  Future<void> guardarJugadorFavorito(final int idJugador, final bool guardar);
  Future<List<int>> obtenerJugadoresFavoritos();

  Future<void> guardarJuegoFavorito(final int idJuego, final bool guardar);
  Future<List<int>> obtenerJuegosFavoritos();
}
