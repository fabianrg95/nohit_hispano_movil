import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/delegates/buscar_jugadores_delegate.dart';
import 'package:no_hit/presentation/providers/jugador/jugador_provider.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class JugadoresView extends ConsumerStatefulWidget {
  static const nombre = 'juegadores-screen';
  const JugadoresView({super.key});

  @override
  JugadoresViewState createState() => JugadoresViewState();
}

class JugadoresViewState extends ConsumerState<JugadoresView> {
  List<Jugador> listaJugadores = [];

  @override
  void initState() {
    super.initState();
    ref.read(jugadorProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    listaJugadores = ref.watch(jugadorProvider);

    if (listaJugadores.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
              Text('Contando hits')
            ],
          ),
        ),
      );
    }


    return SafeArea(
      child: Scaffold(
        drawer: const CustomDraw(),
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: BuscarJugadoresDelegate(
                      listaInicial: ref.watch(jugadorProvider),
                    ));
              },
              icon: const Icon(Icons.search))
        ], title: const Text('Jugadores'), centerTitle: true),
        body: ListView.builder(
            itemCount: listaJugadores.length,
            itemBuilder: (context, index) {
              final jugador = listaJugadores[index];
              return ItemJugador(jugador: jugador);
            }),
      ),
    );
  }
}
