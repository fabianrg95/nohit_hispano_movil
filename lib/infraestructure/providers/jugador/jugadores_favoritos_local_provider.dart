import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/hitless_repository_provider.dart';
import 'package:no_hit/infraestructure/repositories/local_repository_impl.dart';

final jugadoresFavoritosLocalProvider = StateNotifierProvider<JugadoresFavoritosLocalNotifier, List<int>>((ref) {
  final localRepository = ref.watch(localRepositoryProvider);
  return JugadoresFavoritosLocalNotifier(localRepository);
});

typedef GetJugadoresFavoritosLocalCallback = Future<List<int>> Function();

// Controller o Notifier
class JugadoresFavoritosLocalNotifier extends StateNotifier<List<int>> {
  LocalRepositoryImpl localStorage;

  JugadoresFavoritosLocalNotifier(this.localStorage) : super([]);

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
