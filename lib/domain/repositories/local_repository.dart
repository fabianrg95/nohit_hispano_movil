abstract class LocalRepository {
  Future<void> guardarEsTemaClaro(final bool temaClaroSeleccinado);
  Future<bool> obtenerEsTemaClaro();

  Future<void> guardarIntroduccionFinalizada(final bool introduccionFinalizada);
  Future<bool> obtenerIntroduccionFinalizada();
}
