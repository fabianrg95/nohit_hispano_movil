import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final totalJugadoresProvider = StateNotifierProvider<TotalJugadoresNotifier, int>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return TotalJugadoresNotifier(hitlessRepository.obtenerCantidadJugadores);
});

typedef GetTotalJugadoresCallback = Future<int> Function();

class TotalJugadoresNotifier extends StateNotifier<int> {
  bool loadingdata = false;
  GetTotalJugadoresCallback obtenerTotalJugadores;

  TotalJugadoresNotifier(this.obtenerTotalJugadores) : super(0);

  Future<void> loadData() async {
    if (loadingdata == true) {
      return;
    }
    loadingdata = true;

    state = await obtenerTotalJugadores();
    loadingdata = false;
  }
}
