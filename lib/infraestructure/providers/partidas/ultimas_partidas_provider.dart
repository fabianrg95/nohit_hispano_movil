import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final ultimasPartidasProvider = StateNotifierProvider<UltimasPartidasNotifier, List<PartidaDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return UltimasPartidasNotifier(hitlessRepository.obtenerUltimasPartidas);
});

typedef GetUltimasPartidasCallback = Future<List<PartidaEntity>> Function();

class UltimasPartidasNotifier extends StateNotifier<List<PartidaDto>> {
  GetUltimasPartidasCallback obtenerUltimasPartidas;

  UltimasPartidasNotifier(this.obtenerUltimasPartidas) : super([]);

  Future<void> loadData(final bool reload) async {
    if (state.isNotEmpty && reload == false) return;
    final List<PartidaEntity> lista = await obtenerUltimasPartidas();
    state = PartidaMapper.mapearListaPartidas(lista);
  }
}
