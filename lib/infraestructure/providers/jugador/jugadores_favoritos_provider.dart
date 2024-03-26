import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/hitless_repository_provider.dart';
import 'package:no_hit/infraestructure/repositories/local_repository_impl.dart';

final jugadoresFavoritosProvider = StateNotifierProvider<JugadoresFavoritosNotifier, List<int>>((ref) {
  final localRepository = ref.watch(localRepositoryProvider);
  return JugadoresFavoritosNotifier(localRepository);
});

typedef GetJugadoresFavoritosCallback = Future<List<int>> Function();

// Controller o Notifier
class JugadoresFavoritosNotifier extends StateNotifier<List<int>> {
  LocalRepositoryImpl localStorage;

  JugadoresFavoritosNotifier(this.localStorage) : super([]);

  void guardarJugadorFavorito(int idJugador) async {
    await localStorage.guardarJugadorFavorito(idJugador, true);
    obtenerJugadoresFavoritos();
  }

  void eliminarJugadorFavorito(int idJugador) async {
    await localStorage.guardarJugadorFavorito(idJugador, false);
    obtenerJugadoresFavoritos();
  }

  void obtenerJugadoresFavoritos() async {
    List<int> jugadoresFavoritos = await localStorage.obtenerJugadoresFavoritos();
    state = [...jugadoresFavoritos];
  }
}
