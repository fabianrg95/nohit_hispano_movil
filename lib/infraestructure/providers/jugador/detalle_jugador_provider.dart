import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final detalleJugadorProvider = StateNotifierProvider<DetalleJugadorNotifier, JugadorDto>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return DetalleJugadorNotifier(hitlessRepository.obtenerInfromacionJugador);
});

typedef GetJugadorCallback = Future<JugadorEntity> Function(int idJugador);

class DetalleJugadorNotifier extends StateNotifier<JugadorDto> {
  final GetJugadorCallback obtenerInformacionJugador;

  DetalleJugadorNotifier(this.obtenerInformacionJugador) : super(JugadorDto());

  Future<void> loadData(int idJugador) async {
    if (state.id != idJugador) {
      state = JugadorMapper.entityToDtoDetalle(await obtenerInformacionJugador(idJugador));
    }
  }
}
