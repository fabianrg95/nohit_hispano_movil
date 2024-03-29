import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/hitless_repository_provider.dart';
import 'package:no_hit/infraestructure/repositories/local_repository_impl.dart';

final juegosFavoritosLocalProvider = StateNotifierProvider<JuegosFavoritosLocalNotifier, List<int>>((ref) {
  final localRepository = ref.watch(localRepositoryProvider);
  return JuegosFavoritosLocalNotifier(localRepository);
});

typedef GetJuegosFavoritosLocalCallback = Future<List<int>> Function();

// Controller o Notifier
class JuegosFavoritosLocalNotifier extends StateNotifier<List<int>> {
  LocalRepositoryImpl localStorage;

  JuegosFavoritosLocalNotifier(this.localStorage) : super([]);

  void guardarJuegoFavorito(int idJuego) async {
    await localStorage.guardarJuegoFavorito(idJuego, true);
    obtenerJuegosFavoritos();
  }

  void eliminarJuegoFavorito(int idJuego) async {
    await localStorage.guardarJuegoFavorito(idJuego, false);
    obtenerJuegosFavoritos();
  }

  void obtenerJuegosFavoritos() async {
    List<int> juegosFavoritos = await localStorage.obtenerJuegosFavoritos();
    state = [...juegosFavoritos];
  }
}
