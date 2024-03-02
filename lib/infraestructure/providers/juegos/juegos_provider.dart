import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';
import 'package:no_hit/infraestructure/mapper/juego/juego_mapper.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final juegosProvider = StateNotifierProvider<JuegosNotifier, Map<bool, List<JuegoDto>>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return JuegosNotifier(hitlessRepository.obtenerJuegos);
});

typedef GetJuegosCallback = Future<List<JuegoEntity>> Function(bool oficialTeamHitless);

class JuegosNotifier extends StateNotifier<Map<bool, List<JuegoDto>>> {
  GetJuegosCallback obtenerJuegos;

  JuegosNotifier(this.obtenerJuegos) : super({});

  Future<void> loadData({required bool oficialTeamHitless}) async {
    if (state[oficialTeamHitless] == null || state[oficialTeamHitless]!.isEmpty) {
      state = {...state, oficialTeamHitless: JuegoMapper.mapearListaJuegos(await obtenerJuegos(oficialTeamHitless))};
    }
  }

  void reloadData({required bool oficialTeamHitless}) {
    state[oficialTeamHitless] = [];
  }
}
