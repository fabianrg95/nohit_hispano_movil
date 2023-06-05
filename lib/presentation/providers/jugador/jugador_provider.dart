import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/providers/providers.dart';

final jugadorProvider =
    StateNotifierProvider<JugadorNotifier, List<Jugador>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return JugadorNotifier(hitlessRepository.obtenerJugadores);
});

typedef GetJugadoresCallback = Future<List<Jugador>> Function();

class JugadorNotifier extends StateNotifier<List<Jugador>> {
  bool loadingdata = false;
  int ultimoid = 0;
  GetJugadoresCallback obtenerJugadores;

  JugadorNotifier(this.obtenerJugadores) : super([]);

  Future<void> loadData() async {
    if (loadingdata == true) {
      return;
    }
    loadingdata = true;

    final List<Jugador> jugadores = await obtenerJugadores();
    state = jugadores;
    loadingdata = false;
  }
}
