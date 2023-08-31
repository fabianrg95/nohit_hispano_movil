import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/jugador/jugador_dto.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final jugadorProvider = StateNotifierProvider<JugadorNotifier, List<JugadorDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return JugadorNotifier(hitlessRepository.obtenerJugadores);
});

typedef GetJugadoresCallback = Future<List<JugadorEntity>> Function();

class JugadorNotifier extends StateNotifier<List<JugadorDto>> {
  bool loadingdata = false;
  int ultimoid = 0;
  GetJugadoresCallback obtenerJugadores;

  JugadorNotifier(this.obtenerJugadores) : super([]);

  Future<void> loadData() async {
    if (loadingdata == true) {
      return;
    }
    loadingdata = true;

    if (state.isEmpty) {
      state = JugadorMapper.mapearListaJugadores(await obtenerJugadores());
    }
    loadingdata = false;
  }
}
