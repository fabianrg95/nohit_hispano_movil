import 'package:no_hit/domain/datasources/local_storage.dart';
import 'package:no_hit/domain/repositories/local_repository.dart';

class LocalRepositoryImpl extends LocalRepository {
  final LocalStorage local;

  LocalRepositoryImpl(this.local);

  @override
  Future<void> guardarEsTemaClaro(bool temaClaroSeleccinado) async {
    local.guardarEsTemaClaro(temaClaroSeleccinado);
  }

  @override
  Future<bool> obtenerEsTemaClaro() {
    return local.obtenerEsTemaClaro();
  }

  @override
  Future<void> guardarIntroduccionFinalizada(bool introduccionFinalizada) async {
    local.guardarIntroduccionFinalizada(introduccionFinalizada);
  }

  @override
  Future<bool> obtenerIntroduccionFinalizada() {
    return local.obtenerIntroduccionFinalizada();
  }

  @override
  Future<void> guardarJugadorFavorito(final int idJugador, final bool guardar) async {
    local.guardarJugadorFavorito(idJugador, guardar);
  }

  @override
  Future<List<int>> obtenerJugadoresFavoritos() {
    return local.obtenerJugadoresFavoritos();
  }
}
