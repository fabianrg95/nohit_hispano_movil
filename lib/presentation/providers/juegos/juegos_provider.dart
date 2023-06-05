import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/providers/providers.dart';

final juegosProvider =
    StateNotifierProvider<JuegosNotifier, Map<bool, List<Juego>>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return JuegosNotifier(hitlessRepository.obtenerJuegos);
});

typedef GetJuegosCallback = Future<List<Juego>> Function(
    bool oficialTeamHitless);

class JuegosNotifier extends StateNotifier<Map<bool, List<Juego>>> {
  GetJuegosCallback obtenerJuegos;

  JuegosNotifier(this.obtenerJuegos) : super({});

  Future<void> loadData({required bool oficialTeamHitless}) async {
    if (state[oficialTeamHitless] != null) return;

    final List<Juego> juegos = await obtenerJuegos(oficialTeamHitless);
    state = {...state, oficialTeamHitless: juegos};
  }
}
