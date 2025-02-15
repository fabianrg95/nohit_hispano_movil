import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/infraestructure/repositories/local_repository_impl.dart';

final juegosFavoritosProvider = StateNotifierProvider<JuegosFavoritosNotifier, List<JuegoDto>>((ref) {
  final localRepository = ref.watch(localRepositoryProvider);
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return JuegosFavoritosNotifier(hitlessRepository.obtenerJuegosFavoritos, localRepository);
});

typedef GetJuegosFavoritosCallback = Future<List<JuegoEntity>> Function(List<int>);

class JuegosFavoritosNotifier extends StateNotifier<List<JuegoDto>> {
  bool loadingdata = false;
  GetJuegosFavoritosCallback obtenerJuegos;
  LocalRepositoryImpl localStorage;

  JuegosFavoritosNotifier(this.obtenerJuegos, this.localStorage) : super([]);

  Future<void> loadData() async {
    if (loadingdata == true) {
      return;
    }
    loadingdata = true;

    List<int> listaIdJuegosFavoritos = await localStorage.obtenerJuegosFavoritos();

    if (listaIdJuegosFavoritos.isNotEmpty) {
      List<JuegoEntity> listaJugadoresEntity = await obtenerJuegos(listaIdJuegosFavoritos);

      List<JuegoDto> listaJugadores = JuegoMapper.mapearListaJuegos(listaJugadoresEntity);
      listaJugadores.sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
      state = [...listaJugadores];
    } else {
      state = [];
    }

    loadingdata = false;
  }
}
