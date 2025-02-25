import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

typedef BuscarJugadoresCallback = Future<List<JugadorEntity>> Function(String query);

class BuscarJugadoresDelegate extends SearchDelegate {
  BuildContext context;
  BuscarJugadoresCallback buscarJugadoresCallback;

  StreamController<List<JugadorDto>> debouncedJugadores = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  List<JugadorDto> jugadoresEncontrador = [];

  Timer? _debounceTimer;

  BuscarJugadoresDelegate({required this.buscarJugadoresCallback, required this.context})
      : super(searchFieldLabel: AppLocalizations.of(context)!.buscar_jugador);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData color = Theme.of(context);
    return color.copyWith(
        hintColor: color.colorScheme.tertiary,
        textTheme: TextTheme(
          titleLarge: TextStyle(color: color.colorScheme.tertiary, fontSize: 24, fontWeight: FontWeight.normal, fontFamily: 'SharpGrotesk'),
        ),
        appBarTheme: AppBarTheme(
            foregroundColor: color.colorScheme.tertiary,
            color: color.colorScheme.secondary,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)))),
        inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: color.colorScheme.tertiary)));
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
              child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.refresh_rounded)),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
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
    debouncedJugadores.add([]);
    jugadoresEncontrador = [];

    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    if (query.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.ingrese_usuario,
              style: textStyle.titleMedium?.copyWith(color: color.tertiary),
            ),
          ],
        ),
      );
    }

    if (query.isNotEmpty) {
      _cambioConsulta(query);
    }

    return construirResultado();
  }

  void clearStreams() {
    debouncedJugadores.close();
  }

  Future<void> _cambioConsulta(String query) async {
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final jugadores = JugadorMapper.mapearListaJugadores(await buscarJugadoresCallback(query));
      debouncedJugadores.add(jugadores);
      jugadoresEncontrador.addAll(jugadores);
      isLoadingStream.add(false);
    });
  }

  Widget construirResultado() {
    return StreamBuilder(
      initialData: jugadoresEncontrador,
      stream: debouncedJugadores.stream,
      builder: (context, snapshot) {
        final jugadores = snapshot.data ?? [];

        return ListView.builder(
          itemCount: jugadores.length,
          itemBuilder: (context, index) {
            final jugador = jugadores[index];
            return ItemJugador(jugador: jugador);
          },
        );
      },
    );
  }
}
