import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final detalleJugadorProvider = StateNotifierProvider<DetalleJugadorNotifier, Map<int, JugadorDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return DetalleJugadorNotifier(hitlessRepository.obtenerInfromacionJugador);
});

typedef GetJugadorCallback = Future<JugadorEntity> Function(int idJugador);

class DetalleJugadorNotifier extends StateNotifier<Map<int, JugadorDto>> {
  final GetJugadorCallback obtenerInformacionJugador;

  DetalleJugadorNotifier(this.obtenerInformacionJugador) : super({});

  Future<void> loadData(int idJugador) async {
    if (state[idJugador] == null) {
      state = {...state, idJugador: JugadorMapper.entityToDtoDetalle(await obtenerInformacionJugador(idJugador))};
    }
  }
}
