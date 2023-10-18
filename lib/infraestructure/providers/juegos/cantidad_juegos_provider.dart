import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final totalJuegosProvider = StateNotifierProvider<TotalJuegosNotifier, int>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return TotalJuegosNotifier(hitlessRepository.obtenerCantidadJuegos);
});

typedef GetTotalJuegosCallback = Future<int> Function();

class TotalJuegosNotifier extends StateNotifier<int> {
  bool loadingdata = false;
  GetTotalJuegosCallback obtenerTotalJuegos;

  TotalJuegosNotifier(this.obtenerTotalJuegos) : super(0);

  Future<void> loadData() async {
    if (loadingdata == true || state > 0) {
      return;
    }
    loadingdata = true;

    state = await obtenerTotalJuegos();
    loadingdata = false;
  }
}
