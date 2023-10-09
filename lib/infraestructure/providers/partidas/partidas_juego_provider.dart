import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final partidasJuegoProvider = StateNotifierProvider<PartidasJuegoNotifier, Map<int, ResumenJuegoDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return PartidasJuegoNotifier(hitlessRepository.obtenerPartidasPorJuego);
});

typedef GetJuegosCallback = Future<List<PartidaEntity>> Function(int idJuego);

class PartidasJuegoNotifier extends StateNotifier<Map<int, ResumenJuegoDto>> {
  GetJuegosCallback obtenerPartidasPorJuegos;

  PartidasJuegoNotifier(this.obtenerPartidasPorJuegos) : super({});

  Future<void> loadData(int idJuego) async {
    if (state[idJuego] != null) return;
    final List<PartidaEntity> lista = await obtenerPartidasPorJuegos(idJuego);
    state = {...state, idJuego: JuegoMapper.mapearResumenJuego(lista)};
  }
}
