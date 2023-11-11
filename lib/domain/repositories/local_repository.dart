abstract class LocalRepository {
  Future<void> guardarEsTemaClaro(final bool temaClaroSeleccinado);
  Future<bool> obtenerEsTemaClaro();
}
