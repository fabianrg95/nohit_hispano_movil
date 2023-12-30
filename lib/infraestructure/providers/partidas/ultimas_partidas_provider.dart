import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final ultimasPartidasProvider = StateNotifierProvider<UltimasPartidasNotifier, List<PartidaDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return UltimasPartidasNotifier(hitlessRepository.obtenerUltimasPartidas);
});

typedef GetUltimasPartidasCallback = Future<List<PartidaEntity>> Function(int? id);

class UltimasPartidasNotifier extends StateNotifier<List<PartidaDto>> {
  GetUltimasPartidasCallback obtenerUltimasPartidas;
  bool cargando = false;

  UltimasPartidasNotifier(this.obtenerUltimasPartidas) : super([]);

  Future<void> loadData() async {
    if (cargando) return;

    cargando = true;
    final int? ultimoId = state.isEmpty ? null : state.last.id;
    final List<PartidaEntity> lista = await obtenerUltimasPartidas(ultimoId);
    List<PartidaDto> listaPartidas = PartidaMapper.mapearListaPartidas(lista);
    for (var partida in listaPartidas) {
      state = [...state, partida];
    }
    cargando = false;
  }

  Future<void> reloadData() async {
    if (cargando) return;

    cargando = true;
    final List<PartidaEntity> lista = await obtenerUltimasPartidas(null);
    state = PartidaMapper.mapearListaPartidas(lista);
    cargando = false;
  }
}
