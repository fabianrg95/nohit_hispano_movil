import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/jugador.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class BuscarJugadoresDelegate extends SearchDelegate {
  List<Jugador> listaInicial;
  List<Jugador>? listaFiltrada = [];

  StreamController<List<Jugador>> debouncedJugadores =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  BuscarJugadoresDelegate({required this.listaInicial})
      : super(searchFieldLabel: 'Buscar jugador') {
    listaFiltrada = listaInicial;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                  onPressed: () => query = '',
                  icon: const Icon(Icons.refresh_rounded)),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
                onPressed: () => query = '', icon: const Icon(Icons.clear)),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return construirResultado();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    if (query.isEmpty) {
      return  Center(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ingrese un nombre de usuario',
              style: textStyle.titleMedium?.copyWith(color: color.primary.withAlpha(150)),
            ),
          ],
        ),
      );
    }
    _cambioConsulta(query);
    return construirResultado();
  }

  void clearStreams() {
    debouncedJugadores.close();
  }

  void _cambioConsulta(String query) {
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final jugadores = listaInicial
          .where((element) => element.nombre.contains(query))
          .toList();
      listaFiltrada = jugadores;
      debouncedJugadores.add(jugadores);
      isLoadingStream.add(false);
    });
  }

  Widget construirResultado() {
    return StreamBuilder(
      initialData: listaFiltrada,
      stream: debouncedJugadores.stream,
      builder: (context, snapshot) {
        final jugadores = snapshot.data ?? [];

        return ListView.builder(
          itemCount: jugadores.length,
          itemBuilder: (context, index) {
            return ItemJugador(jugador: jugadores[index]);
          },
        );
      },
    );
  }
}
