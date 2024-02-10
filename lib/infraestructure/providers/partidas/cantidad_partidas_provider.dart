import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final totalPartidasProvider = StateNotifierProvider<TotalPartidasNotifier, int>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return TotalPartidasNotifier(hitlessRepository.obtenerCantidadPartidas);
});

typedef GetTotalPartidasCallback = Future<int> Function();

class TotalPartidasNotifier extends StateNotifier<int> {
  bool loadingdata = false;
  GetTotalPartidasCallback obtenerTotalPartidas;

  TotalPartidasNotifier(this.obtenerTotalPartidas) : super(0);

  Future<void> loadData(bool reload) async {
    if (loadingdata == true) {
      return;
    }
    loadingdata = true;

    if (state == 0 || reload == true) {
      state = await obtenerTotalPartidas();
    }

    loadingdata = false;
  }
}
