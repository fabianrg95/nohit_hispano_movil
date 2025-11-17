import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/app_info.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/views/juegos/lista_jugadores_juego.dart';
import 'package:no_hit/presentation/views/juegos/lista_partidas_juego.dart';
import 'package:no_hit/presentation/widgets/commons/arrow.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

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
  bool juegoFavorito = false;

  final double tamanioImagen = 150;
  late ColorScheme color;
  late TextTheme styleTexto;
  int pageViewIndex = 1;
  IconData iconoFlechaAtras = Icons.arrow_back;

  final Map<int, String> titulosPageView = {0: 'Partidas', 1: '', 2: 'Jugadores'};

  ValueNotifier<double> offset = ValueNotifier(0);
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    ref.read(informacionJuegoProvider.notifier).loadData(idJuego: widget.idJuego);
    ref.read(partidasJuegoProvider.notifier).loadData(widget.idJuego);
    ref.read(juegosFavoritosLocalProvider.notifier).obtenerJuegosFavoritos();

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

  void _guardarJuegoFavorito() {
    if (juegoFavorito) {
      ref.read(juegosFavoritosLocalProvider.notifier).eliminarJuegoFavorito(widget.idJuego);
      juegoFavorito = false;
    } else {
      ref.read(juegosFavoritosLocalProvider.notifier).guardarJuegoFavorito(widget.idJuego);
      juegoFavorito = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    informacionJuego = ref.watch(informacionJuegoProvider)[widget.idJuego];
    resumenJuego = ref.watch(partidasJuegoProvider)[widget.idJuego];
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;

    List<int> juegosFavorito = ref.watch(juegosFavoritosLocalProvider);

    juegoFavorito = juegosFavorito.contains(widget.idJuego);

    return PopScope(
      canPop: pageViewIndex == 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controlarBack(context);
      },
      child: Scaffold(
        // drawer: const CustomNavigation(),
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.primary,
                  ),
                  child: IconButton(
                      onPressed: () {
                        _guardarJuegoFavorito();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: color.primary,
                            action: SnackBarAction(
                              label: 'Deshacer',
                              onPressed: () => _guardarJuegoFavorito(),
                              textColor: color.surfaceContainerHighest,
                            ),
                            content: Text(
                              'Juego ${juegoFavorito ? 'agregado a' : 'eliminado de'} favoritos.',
                              style: styleTexto.bodyLarge?.copyWith(color: color.primary),
                            )));
                      },
                      color: color.tertiary,
                      highlightColor: color.tertiary,
                      icon: Visibility(
                          visible: juegoFavorito, replacement: const Icon(Icons.favorite_border_outlined), child: const Icon(Icons.favorite))),
                ))
          ],
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.primary,
              ),
              child: IconButton(
                onPressed: () {
                  controlarBack(context);
                },
                color: color.tertiary,
                highlightColor: color.tertiary,
                icon: Icon(iconoFlechaAtras),
              ),
            ),
          ),
          forceMaterialTransparency: true,
          elevation: 0,
          title: Text(titulosPageView[pageViewIndex]!, style: styleTexto.titleMedium?.copyWith(color: color.tertiary)),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        body: PageView(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: (value) => setState(() {
                  pageViewIndex = value;
                }),
            children: [
              // const SizedBox.shrink(),
              if (resumenJuego != null)
                ListaPartidas(
                    primeraPartida: resumenJuego?.primeraPartida,
                    ultimaPartida: resumenJuego?.ultimaPartida,
                    heroTag: widget.heroTag,
                    listaPartidas: resumenJuego!.partidas),
              if (resumenJuego == null)
                Center(
                  child: CircularProgressIndicator(
                    color: color.primary,
                  ),
                ),
              Column(
                children: [
                  SizedBox(
                    height: AppInfo().porcentajeAlto(0.45),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: color.tertiary,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150), bottomRight: Radius.circular(150))),
                          height: AppInfo().porcentajeAlto(0.24),
                        ),
                        Center(
                          child: Container(
                            width: AppInfo().porcentajeAncho(0.57),
                            height: AppInfo().porcentajeAlto(0.57),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.primary,
                            ),
                          ),
                        ),
                        Hero(
                          tag: widget.heroTag,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: AppInfo().porcentajeAlto(0.13)),
                              child: Container(
                                width: AppInfo().porcentajeAncho(0.43),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(informacionJuego!.urlImagen!, fit: BoxFit.contain),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  JuegoCommons().subtitulo(informacionJuego!, null, context),
                  SizedBox(height: AppInfo().porcentajeAlto(0.1)),
                  Center(child: _resumenJuego(informacionJuego!, resumenJuego)),
                ],
              ),
              if (resumenJuego != null)
                ListaJugadoresJuego(
                  listaJugadores: resumenJuego!.jugadores,
                  primeraPartida: resumenJuego?.primeraPartida,
                  ultimaPartida: resumenJuego?.ultimaPartida,
                ),
              if (resumenJuego == null)
                Center(
                  child: CircularProgressIndicator(
                    color: color.primary,
                  ),
                ),
            ]),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              backgroundColor: color.tertiary,
              selectedItemColor: color.primary,
              unselectedItemColor: color.primary.withValues(alpha: 0.7),
              selectedLabelStyle: styleTexto.bodyLarge?.copyWith(color: color.primary),
              unselectedLabelStyle: styleTexto.bodySmall?.copyWith(color: color.primary.withValues(alpha: 0.7)),
              selectedIconTheme: const IconThemeData(size: 30),
              unselectedIconTheme: const IconThemeData(size: 20),
              currentIndex: pageViewIndex,
              onTap: _navegarPage,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.workspace_premium),
                  label: 'Partidas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_esports),
                  label: 'Juego',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups),
                  label: 'Jugadores',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // return PopScope(
    //   canPop: pageViewIndex == 0,
    //   onPopInvokedWithResult: (didPop, result) {
    //     if (didPop) return;
    //     controlarBack(context);
    //   },
    //   child: ValueListenableBuilder(
    //     valueListenable: offset,
    //     builder: (BuildContext context, offsetValue, _) => SafeArea(
    //       child: Scaffold(
    //         // drawer: const CustomNavigation(),
    //         appBar: AppBar(
    //           actions: [
    //             Padding(
    //               padding: const EdgeInsets.only(right: 10.0),
    //               child: GestureDetector(
    //                 onTap: () {
    //                   _guardarJuegoFavorito();
    //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                       backgroundColor: color.tertiary,
    //                       action: SnackBarAction(
    //                         label: 'Deshacer',
    //                         onPressed: () => _guardarJuegoFavorito(),
    //                         textColor: color.surfaceContainerHighest,
    //                       ),
    //                       content: Text(
    //                         'Juego ${juegoFavorito ? 'agregado a' : 'eliminado de'} favoritos.',
    //                         style: styleTexto.bodyLarge?.copyWith(color: color.primary),
    //                       )));
    //                 },
    //                 child: Visibility(
    //                     visible: juegoFavorito, replacement: const Icon(Icons.favorite_border_outlined), child: const Icon(Icons.favorite)),
    //               ),
    //             )
    //           ],
    //           leading: IconButton(
    //             onPressed: () {
    //               controlarBack(context);
    //             },
    //             icon: Icon(iconoFlechaAtras),
    //           ),
    //           forceMaterialTransparency: true,
    //           elevation: 0,
    //           title: Text(titulosPageView[pageViewIndex]!),
    //         ),
    //         extendBodyBehindAppBar: true,
    //         body: Stack(children: [
    //           cabecera(context, widget.heroTag, offsetValue),
    //           if (resumenJuego != null && resumenJuego!.cantidadPartidas > 0)
    //             PageView(
    //                 scrollDirection: Axis.horizontal,
    //                 controller: _pageController,
    //                 onPageChanged: (value) => setState(() {
    //                       pageViewIndex = value;
    //                     }),
    //                 children: [
    //                   // const SizedBox.shrink(),
    //                   Align(
    //                       alignment: const FractionalOffset(0, 1),
    //                       child: GestureDetector(onTap: () => _navegarPage(1), child: const ShimmerArrows(icon: Icons.keyboard_arrow_right))),
    //                   ListaPartidas(
    //                       primeraPartida: resumenJuego?.primeraPartida,
    //                       ultimaPartida: resumenJuego?.ultimaPartida,
    //                       heroTag: widget.heroTag,
    //                       listaPartidas: resumenJuego!.partidas),
    //                   ListaJugadoresJuego(
    //                     listaJugadores: resumenJuego!.jugadores,
    //                     primeraPartida: resumenJuego?.primeraPartida,
    //                     ultimaPartida: resumenJuego?.ultimaPartida,
    //                   )
    //                 ]),
    //           Align(
    //             alignment: FractionalOffset(0.5, 0.88 + offsetValue),
    //             child: FadeTransition(
    //               opacity: AlwaysStoppedAnimation(1 - (offsetValue * 1.5)),
    //               child: Column(mainAxisSize: MainAxisSize.min, children: [
    //                 JuegoCommons().subtitulo(informacionJuego!, null, context),
    //                 const SizedBox(height: 10),
    //                 _resumenJuego(informacionJuego!, resumenJuego),
    //               ]),
    //             ),
    //           ),
    //         ]),
    //       ),
    //     ),
    //   ),
    // );
  }

  void controlarBack(BuildContext context) {
    if (pageViewIndex == 1) {
      Navigator.of(context).pop();
    } else {
      _navegarPage(1);
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
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
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
      return SizedBox(height: 100, child: PantallaCargaBasica(texto: AppLocalizations.of(context)!.consultando_partidas));
    }

    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ViewData().muestraInformacionSimple(items: [
            Text(AppLocalizations.of(context)!.tipo_juego(informacionJuego.oficialTeamHistless.toString()),
                style: styleTexto.titleLarge?.copyWith(color: color.tertiary)),
            Text(AppLocalizations.of(context)!.team_hitless)
          ]),
          Row(
            children: [
              ViewData().muestraInformacionAccion(
                accion: () => _navegarPage(0),
                items: [
                  Text(resumenPartidasJuego.cantidadPartidas.toString(), style: styleTexto.displaySmall?.copyWith(color: color.tertiary)),
                  Text(AppLocalizations.of(context)!.partidas((resumenPartidasJuego.cantidadPartidas != 1).toString()))
                ],
              ),
              ViewData().muestraInformacionAccion(
                accion: () => _navegarPage(2),
                items: [
                  Text(resumenPartidasJuego.cantidadJugadores.toString(), style: styleTexto.displaySmall?.copyWith(color: color.tertiary)),
                  Text(AppLocalizations.of(context)!.jugadores((resumenPartidasJuego.cantidadJugadores != 1).toString()))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
