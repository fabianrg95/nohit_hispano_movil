import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final detallePartidaProvider = StateNotifierProvider<DetallePartidaNotifier, Map<int, PartidaDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return DetallePartidaNotifier(hitlessRepository.obtenerInfromacionPartida);
});

typedef GetDetallePartidaCallback = Future<PartidaEntity> Function(int idPartida);

class DetallePartidaNotifier extends StateNotifier<Map<int, PartidaDto>> {
  GetDetallePartidaCallback obtenerDetallePartida;

  DetallePartidaNotifier(this.obtenerDetallePartida) : super({});

  Future<void> loadData(final int idPartida) async {
    if (state[idPartida] != null) return;
    state = {...state, idPartida: PartidaMapper.entityToDto(await obtenerDetallePartida(idPartida))};
  }
}
