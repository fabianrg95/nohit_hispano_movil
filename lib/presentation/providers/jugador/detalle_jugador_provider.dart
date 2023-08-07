import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/providers/providers.dart';

final detalleJugadorProvider =
    StateNotifierProvider<DetalleJugadorNotifier, DetalleJugador>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return DetalleJugadorNotifier(hitlessRepository.obtenerInfromacionJugador);
});

typedef GetJugadorCallback = Future<DetalleJugador> Function(int idJugador);

class DetalleJugadorNotifier extends StateNotifier<DetalleJugador> {
  final GetJugadorCallback obtenerInformacionJugador;

  DetalleJugadorNotifier(this.obtenerInformacionJugador)
      : super(DetalleJugador(
            id: 0,
            nombre: '',
            pronombre: '',
            pais: '',
            cantidadPartidas: 0,
            fechaPrimeraPartida: DateTime.now().toString(),
            partidas: []));

  Future<void> loadData(int idJugador) async {
    if (state.id != idJugador) {
      final DetalleJugador detalleJugador =
          await obtenerInformacionJugador(idJugador);
      state = detalleJugador;
    }
  }
}
