import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import '../../../l10n/app_localizations.dart';
import 'package:no_hit/infraestructure/mapper/mappers.dart';
import 'package:no_hit/infraestructure/providers/juegos/informacion_juego_provider.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

typedef BuscarJuegosCallback = Future<List<JuegoEntity>> Function(String query);

class BuscarJuegoDelegate extends SearchDelegate {
  BuildContext context;
  WidgetRef ref;
  BuscarJuegosCallback buscarJuegosCallback;

  StreamController<List<JuegoDto>> debouncedJuegos = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  List<JuegoDto> juegosEncontrados = [];

  Timer? _debounceTimer;

  BuscarJuegoDelegate({required this.buscarJuegosCallback, required this.context, required this.ref})
      : super(searchFieldLabel: AppLocalizations.of(context)!.buscar_juego);

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
    debouncedJuegos.add([]);
    juegosEncontrados = [];

    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    if (query.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.ingrese_juego,
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
    debouncedJuegos.close();
  }

  Future<void> _cambioConsulta(String query) async {
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final juegos = JuegoMapper.mapearListaJuegos(await buscarJuegosCallback(query));
      debouncedJuegos.add(juegos);
      juegosEncontrados.addAll(juegos);
      isLoadingStream.add(false);
    });
  }

  Widget construirResultado() {
    return StreamBuilder(
      initialData: juegosEncontrados,
      stream: debouncedJuegos.stream,
      builder: (context, snapshot) {
        final juegos = snapshot.data ?? [];

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 260),
          itemCount: juegos.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final JuegoDto juego = juegos[index];
            return CardJuego(juego: juego, accion: () => navegarJuego(context, juego));
          },
        );
      },
    );
  }

  Future<dynamic> navegarJuego(final BuildContext context, final JuegoDto juego) {
    const duration = Duration(milliseconds: 500);
    ref.read(informacionJuegoProvider.notifier).saveData(juegoDto: juego);

    return Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, __, ___) => DetalleJuego(idJuego: juego.id, heroTag: 'Juego-${juego.id}'),
      transitionsBuilder: (_, animation, ___, child) => FadeTransition(opacity: animation, child: child),
    ));
  }
}
