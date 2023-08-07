import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/jugador.dart';
import 'package:no_hit/presentation/views/jugadores/detalle_jugador_view.dart';
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
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData color = Theme.of(context);
    return color.copyWith(
        hintColor: color.colorScheme.tertiary,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              color: color.colorScheme.tertiary,
              fontSize: 24,
              fontWeight: FontWeight.normal),
        ),
        appBarTheme: AppBarTheme(
            foregroundColor: color.colorScheme.tertiary,
            color: color.colorScheme.secondary,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)))),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: color.colorScheme.tertiary)));
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
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ingrese un nombre de usuario',
              style: textStyle.titleMedium?.copyWith(color: color.tertiary),
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
          .where((element) => element.nombre.toLowerCase().contains(query.toLowerCase()))
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
        final styleText = Theme.of(context).textTheme;
        final color = Theme.of(context).colorScheme;
        final jugadores = snapshot.data ?? [];

        return ListView.builder(
          itemCount: jugadores.length,
          itemBuilder: (context, index) {
            final jugador = jugadores[index];
            return Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: Offset(0, 0))
                    ]),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                      leading:
                          BanderaJugador(codigoBandera: jugador.codigoBandera),
                      title: Text(jugador.nombre,
                          style: styleText.bodyMedium
                              ?.copyWith(color: color.tertiary)),
                      subtitle: Visibility(
                          visible: jugador.pronombre != null,
                          child: Text(jugador.pronombre.toString(),
                              style: styleText.bodyMedium
                                  ?.copyWith(color: color.tertiary))),
                      dense: false,
                      titleTextStyle: styleText.titleMedium,
                      subtitleTextStyle: styleText.bodySmall,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetalleJugadorView(idJugador: jugador.id)))),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
