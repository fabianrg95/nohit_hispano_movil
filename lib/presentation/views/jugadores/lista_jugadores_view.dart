import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/presentation/delegates/jugadores/buscar_jugadores_delegate.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ListaJugadoresView extends ConsumerStatefulWidget {
  static const nombre = 'lista-jugadores-screen';
  const ListaJugadoresView({super.key});

  @override
  JugadoresViewState createState() => JugadoresViewState();
}

class JugadoresViewState extends ConsumerState<ListaJugadoresView> {
  List<JugadorDto> listaJugadores = [];

  @override
  void initState() {
    super.initState();
    ref.read(jugadorProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    listaJugadores = ref.watch(jugadorProvider);

    if (listaJugadores.isEmpty) {
      return const PantallaCargaBasica(texto: 'Consultando Jugadores');
    }

    return SafeArea(
      child: Scaffold(
        //drawer: const CustomDraw(),
        appBar: AppBar(actions: [_accionBuscar(context)], title: const Text('Jugadores')),
        body: _contenidoPagina(),
      ),
    );
  }

  Widget _accionBuscar(BuildContext context) {
    return IconButton(
        onPressed: () {
          showSearch(
              context: context,
              delegate: BuscarJugadoresDelegate(
                listaInicial: ref.watch(jugadorProvider),
              ));
        },
        icon: const Icon(Icons.search));
  }

  Widget _contenidoPagina() {
    return ListView.builder(
        itemCount: listaJugadores.length,
        itemBuilder: (context, index) {
          return ItemJugador(jugador: listaJugadores[index]);
        });
  }
}
