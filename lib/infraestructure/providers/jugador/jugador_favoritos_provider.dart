import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/infraestructure/repositories/local_repository_impl.dart';

final jugadoresFavoritosProvider = StateNotifierProvider<JugadorFavoritosNotifier, List<JugadorDto>>((ref) {
  final localRepository = ref.watch(localRepositoryProvider);
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return JugadorFavoritosNotifier(hitlessRepository.obtenerJugadoresFavoritos, localRepository);
});

typedef GetJugadoresFavoritosCallback = Future<List<JugadorEntity>> Function(List<int>);

class JugadorFavoritosNotifier extends StateNotifier<List<JugadorDto>> {
  bool loadingdata = false;
  GetJugadoresFavoritosCallback obtenerJugadores;
  LocalRepositoryImpl localStorage;

  JugadorFavoritosNotifier(this.obtenerJugadores, this.localStorage) : super([]);

  Future<void> loadData() async {
    if (loadingdata == true) {
      return;
    }
    loadingdata = true;

    List<int> listaIdJugadoresFavoritos = await localStorage.obtenerJugadoresFavoritos();

    if (listaIdJugadoresFavoritos.isNotEmpty) {
      List<JugadorEntity> listaJugadoresEntity = await obtenerJugadores(listaIdJugadoresFavoritos);

      List<JugadorDto> listaJugadores = JugadorMapper.mapearListaJugadores(listaJugadoresEntity);
      listaJugadores.sort((a, b) => a.nombre!.toLowerCase().compareTo(b.nombre!.toLowerCase()));
      state = [...listaJugadores];
    } else {
      state = [];
    }

    loadingdata = false;
  }
}
