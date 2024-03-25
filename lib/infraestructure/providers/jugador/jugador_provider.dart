import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/commons/filtro_jugadores_dto.dart';
import 'package:no_hit/infraestructure/dto/jugador/jugador_dto.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final jugadorProvider = StateNotifierProvider<JugadorNotifier, List<JugadorDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return JugadorNotifier(hitlessRepository.obtenerJugadores);
});

typedef GetJugadoresCallback = Future<List<JugadorEntity>> Function(List<String> letraInicial, FiltroJugadoresDto? filtros);

class JugadorNotifier extends StateNotifier<List<JugadorDto>> {
  bool loadingdata = false;
  int ultimaLetraConsultada = 96;
  List<String> valornumerico = ['0%', '1%', '2%', '3%', '4%', '5%', '6%', '7%', '8%', '9%'];
  GetJugadoresCallback obtenerJugadores;

  JugadorNotifier(this.obtenerJugadores) : super([]);

  Future<void> loadData(final FiltroJugadoresDto? filtros) async {
    if (loadingdata == true) {
      return;
    }
    loadingdata = true;

    if (filtros == null) {
      if (state.isNotEmpty) {
        ultimaLetraConsultada = state.last.nombre?.toLowerCase().codeUnitAt(0) ?? 96;
      }

      await validarYConsultar(ultimaLetraConsultada, filtros);
    } else {
      consultarJugadores([], filtros);
    }

    loadingdata = false;
  }

  Future<void> validarYConsultar(final int numeroLetra, final FiltroJugadoresDto? filtros) async {
    if (numeroLetra >= 96 && numeroLetra <= 122) {
      List<String> letraConsultar = numeroLetra == 122 ? valornumerico : [definirLetraConsultar(numeroLetra)];

      await consultarJugadores(letraConsultar, filtros);
    }
  }

  Future<void> reloadData() async {
    if (loadingdata == true) {
      return;
    }
    loadingdata = true;

    state = [];

    ultimaLetraConsultada = 96;

    await consultarJugadores([definirLetraConsultar(ultimaLetraConsultada)], null);

    loadingdata = false;
  }

  String definirLetraConsultar(final int letra) {
    return '${String.fromCharCode(letra + 1)}%';
  }

  Future<void> consultarJugadores(List<String> letraConsultar, final FiltroJugadoresDto? filtros) async {
    final List<JugadorEntity> lista = await obtenerJugadores(letraConsultar, filtros);

    if (lista.isEmpty) {
      validarYConsultar(letraConsultar.first.codeUnitAt(0), filtros);
    } else {
      agregarJugadores(lista, filtros);
    }
  }

  void agregarJugadores(List<JugadorEntity> lista, final FiltroJugadoresDto? filtros) {
    List<JugadorDto> listaJugadores = JugadorMapper.mapearListaJugadores(lista);
    listaJugadores.sort((a, b) => a.nombre!.toLowerCase().compareTo(b.nombre!.toLowerCase()));

    if (filtros != null && filtros.listaNacionalidades != null && filtros.listaNacionalidades!.isNotEmpty) {
      state = [...listaJugadores];
    } else {
      state = [...state, ...listaJugadores];
    }
  }
}
