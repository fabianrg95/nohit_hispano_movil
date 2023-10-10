import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final ultimosJugadoresProvider = StateNotifierProvider<UltimosJugadoresNotifier, List<JugadorDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return UltimosJugadoresNotifier(hitlessRepository.obtenerUltimosJugadores);
});

typedef GetJugadoresCallback = Future<List<JugadorEntity>> Function();

class UltimosJugadoresNotifier extends StateNotifier<List<JugadorDto>> {
  GetJugadoresCallback obtenerUltimosJugadores;

  UltimosJugadoresNotifier(this.obtenerUltimosJugadores) : super([]);

  Future<void> loadData() async {
    if (state.isEmpty) {
      state = JugadorMapper.mapearListaJugadoresDetalle(await obtenerUltimosJugadores());
    }
  }
}
