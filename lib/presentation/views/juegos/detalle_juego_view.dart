import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/views/juegos/lista_jugadores_juego.dart';
import 'package:no_hit/presentation/views/juegos/lista_partidas_juego.dart';
import 'package:no_hit/presentation/widgets/commons/arrow.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetalleJuego extends ConsumerStatefulWidget {
  final int idJuego;
  final String heroTag;

  const DetalleJuego({super.key, required this.idJuego, required this.heroTag});

  @override
  DetalleJuegoState createState() => DetalleJuegoState();
}

class DetalleJuegoState extends ConsumerState<DetalleJuego> with SingleTickerProviderStateMixin {
  late JuegoDto? informacionJuego;
  late ResumenJuegoDto? resumenJuego;

  final double tamanioImagen = 150;
  late ColorScheme color;
  late TextTheme styleTexto;
  int pageViewIndex = 0;
  IconData iconoFlechaAtras = Icons.arrow_back;

  final Map<int, String> titulosPageView = {0: '', 1: 'Partidas', 2: 'Jugadores'};

  ValueNotifier<double> offset = ValueNotifier(0);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ref.read(informacionJuegoProvider.notifier).loadData(idJuego: widget.idJuego);
    ref.read(partidasJuegoProvider.notifier).loadData(widget.idJuego);
    _pageController.addListener(_pageListener);

    if (Platform.isIOS) {
      iconoFlechaAtras = Icons.arrow_back_ios_new;
    }
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_pageListener)
      ..dispose();
    super.dispose();
  }

  void _pageListener() {
    final tamanioPantalla = MediaQuery.of(context).size.width;
    final offsetValue = _pageController.offset / tamanioPantalla;
    offset.value = offsetValue.clamp(0, 1);
  }

  void _navegarPage(int page) {
    setState(() {
      _pageController.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    informacionJuego = ref.watch(informacionJuegoProvider)[widget.idJuego];
    resumenJuego = ref.watch(partidasJuegoProvider)[widget.idJuego];
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;

    return PopScope(
      canPop: pageViewIndex == 0,
      onPopInvoked: (didPop) {
        if (didPop) return;
        controlarBack(context);
      },
      child: ValueListenableBuilder(
        valueListenable: offset,
        builder: (BuildContext context, offsetValue, _) => SafeArea(
          child: Scaffold(
            // drawer: const CustomNavigation(),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  controlarBack(context);
                },
                icon: Icon(iconoFlechaAtras),
              ),
              forceMaterialTransparency: true,
              elevation: 0,
              title: Text(titulosPageView[pageViewIndex]!),
            ),
            extendBodyBehindAppBar: true,
            body: Stack(children: [
              cabecera(context, widget.heroTag, offsetValue),
              if (resumenJuego != null && resumenJuego!.cantidadPartidas > 0)
                PageView(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    onPageChanged: (value) => setState(() {
                          pageViewIndex = value;
                        }),
                    children: [
                      // const SizedBox.shrink(),
                      Align(
                          alignment: const FractionalOffset(0, 1),
                          child: GestureDetector(onTap: () => _navegarPage(1), child: const ShimmerArrows(icon: Icons.keyboard_arrow_right))),
                      ListaPartidas(
                          primeraPartida: resumenJuego?.primeraPartida,
                          ultimaPartida: resumenJuego?.ultimaPartida,
                          heroTag: widget.heroTag,
                          listaPartidas: resumenJuego!.partidas),
                      ListaJugadoresJuego(
                        listaJugadores: resumenJuego!.jugadores,
                        primeraPartida: resumenJuego?.primeraPartida,
                        ultimaPartida: resumenJuego?.ultimaPartida,
                      )
                    ]),
              Align(
                alignment: FractionalOffset(0.5, 0.88 + offsetValue),
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(1 - (offsetValue * 1.5)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    JuegoCommons().subtitulo(informacionJuego!, null, context),
                    const SizedBox(height: 10),
                    _resumenJuego(informacionJuego!, resumenJuego),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void controlarBack(BuildContext context) {
    if (pageViewIndex == 0) {
      Navigator.of(context).pop();
    } else {
      _navegarPage(pageViewIndex - 1);
    }
  }

  Widget cabecera(BuildContext context, final String heroTag, final double offset) {
    final size = MediaQuery.of(context).size;

    return Hero(
      tag: heroTag,
      child: FadeTransition(
        opacity: AlwaysStoppedAnimation(1 - offset),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(informacionJuego!.urlImagen!),
              fit: BoxFit.cover,
            ),
          ),
          height: size.height * 0.65,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.5, 1],
                    colors: [Colors.transparent, color.primary],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0, 0.3],
                    colors: [color.primary, Colors.transparent],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _resumenJuego(final JuegoDto informacionJuego, ResumenJuegoDto? resumenPartidasJuego) {
    if (resumenPartidasJuego == null) {
      return const SizedBox(height: 100, child: PantallaCargaBasica(texto: "Consultando las partidas del juego seleccionado"));
    }

    return IntrinsicHeight(
      child: Column(
        children: [
          ViewData().muestraInformacionSimple(items: [
            Text(informacionJuego.oficialTeamHistless == true ? 'Oficial' : 'No oficial',
                style: styleTexto.titleLarge?.copyWith(color: color.outline)),
            const Text('Team hitless')
          ]),
          Row(
            children: [
              ViewData().muestraInformacionAccion(
                accion: () => _navegarPage(1),
                items: [
                  Text(resumenPartidasJuego.cantidadPartidas.toString(), style: styleTexto.displaySmall?.copyWith(color: color.outline)),
                  Text('Partida${resumenPartidasJuego.cantidadPartidas != 1 ? 's' : ''}')
                ],
              ),
              ViewData().muestraInformacionAccion(
                accion: () => _navegarPage(2),
                items: [
                  Text(resumenPartidasJuego.cantidadJugadores.toString(), style: styleTexto.displaySmall?.copyWith(color: color.outline)),
                  Text('Jugador${resumenPartidasJuego.cantidadJugadores != 1 ? 'es' : ''}')
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
