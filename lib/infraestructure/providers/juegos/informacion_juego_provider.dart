import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final informacionJuegoProvider = StateNotifierProvider<InformacionJuegoNotifier, Map<int, JuegoDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return InformacionJuegoNotifier(hitlessRepository.obtenerInformacionJuego);
});

typedef GetInformacionJuegoCallback = Future<JuegoEntity> Function(int idJuego);

class InformacionJuegoNotifier extends StateNotifier<Map<int, JuegoDto>> {
  GetInformacionJuegoCallback obtenerInformacionJuego;

  InformacionJuegoNotifier(this.obtenerInformacionJuego) : super({});

  Future<void> loadData({required int idJuego}) async {
    if (state[idJuego] != null) return;

    state = {...state, idJuego: JuegoMapper.entityToDto(await obtenerInformacionJuego(idJuego))};
  }

  void saveData({required JuegoDto juegoDto}) {
    if (state[juegoDto.id] == null) {
      state = {...state, juegoDto.id: juegoDto};
    }
  }
}
