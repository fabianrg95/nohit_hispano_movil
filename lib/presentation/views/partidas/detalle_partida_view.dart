import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/views/juegos/detalle_juego_view.dart';
import 'package:no_hit/presentation/widgets/commons/arrow.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetallePartidaView extends ConsumerStatefulWidget {
  final int partidaId;
  final int jugadorId;
  final int idJuego;
  final String nombreJuego;
  final String heroTag;

  const DetallePartidaView(
      {super.key, required this.partidaId, required this.jugadorId, required this.heroTag, required this.idJuego, required this.nombreJuego});

  @override
  DetallePartidaState createState() => DetallePartidaState();
}

class DetallePartidaState extends ConsumerState<DetallePartidaView> {
  final double tamanioImagen = 150;
  late ColorScheme color;
  late TextTheme styleTexto;
  late JuegoDto? juegoDto;
  IconData iconoFlechaAtras = Icons.arrow_back;

  int pageViewIndex = 0;

  final Map<int, String> titulosPageView = {0: '', 1: 'Detalle partida'};

  ValueNotifier<double> offset = ValueNotifier(0);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ref.read(detallePartidaProvider.notifier).loadData(widget.partidaId);
    ref.read(detalleJugadorProvider.notifier).loadData(widget.jugadorId);
    _pageController.addListener(_pageListener);
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
    juegoDto = ref.watch(informacionJuegoProvider)[widget.idJuego];
    final PartidaDto? detallePartida = ref.watch(detallePartidaProvider)[widget.partidaId];
    final JugadorDto? detalleJugador = ref.watch(detalleJugadorProvider)[widget.jugadorId];
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
                    appBar: AppBar(
                      forceMaterialTransparency: true,
                      elevation: 0,
                      title: Text(titulosPageView[pageViewIndex]!),
                    ),
                    extendBodyBehindAppBar: true,
                    body: Stack(
                      children: [
                        cabecera(context, widget.heroTag, offsetValue),
                        if (detalleJugador != null && detallePartida != null)
                          PageView(
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              onPageChanged: (value) => setState(() {
                                    pageViewIndex = value;
                                  }),
                              children: [const SizedBox.shrink(), contenido(juegoDto, detalleJugador, detallePartida)]),
                        Align(
                          alignment: FractionalOffset(0.5, 0.98 + offsetValue),
                          child: FadeTransition(
                            opacity: AlwaysStoppedAnimation(1 - (offsetValue * 1.5)),
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              JuegoCommons().subtitulo(
                                  juegoDto!,
                                  () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                                        return FadeTransition(
                                            opacity: animation,
                                            child: DetalleJuego(
                                              idJuego: juegoDto!.id,
                                              heroTag: widget.heroTag,
                                            ));
                                      })),
                                  context),
                              const SizedBox(height: 10),
                              _resumenPartida(juegoDto!, detallePartida, detalleJugador),
                              GestureDetector(
                                  onTap: () => _navegarPage(1),
                                  child: const Align(alignment: FractionalOffset(0, 1), child: ShimmerArrows(icon: Icons.keyboard_arrow_right))),
                            ]),
                          ),
                        ),
                      ],
                    )),
              )),
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
              image: NetworkImage(juegoDto!.urlImagen!),
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

  Widget contenido(JuegoDto? juegoDto, JugadorDto detalleJugador, PartidaDto detallePartida) {
    return SafeArea(
      child: ListView(
        children: [
          JugadorCommons().informacionJugadorGrande(detalleJugador, context),
          _informacionPartida(detallePartida),
          _recordPartida(detallePartida),
          _videos(detallePartida.listaVideosCompletos, 'Videos', "La partida no tiene videos."),
          _videos(detallePartida.listaVideosClips, 'Clips', "La partida no tiene clips."),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _informacionPartida(final PartidaDto detallePartida) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: ViewData().decorationContainerBasic(color: color),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Informacion Partida', style: styleTexto.titleMedium)),
            const SizedBox(height: 10),
            Divider(color: color.tertiary, thickness: 2, height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(HumanFormat.fechaMes(detallePartida.fecha.toString())),
                      Text(HumanFormat.fechaDia(detallePartida.fecha.toString())),
                      Text(HumanFormat.fechaAnio(detallePartida.fecha.toString()))
                    ],
                  ),
                ),
                Expanded(
                    child: Center(
                        child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(detallePartida.nombre.toString(), textAlign: TextAlign.center, style: styleTexto.bodyLarge),
                )))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _videos(final List<String> videos, final String titulo, final String mensajeVacio) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: ViewData().decorationContainerBasic(color: color),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text(titulo, style: styleTexto.titleMedium)),
            const SizedBox(height: 10),
            Divider(color: color.tertiary, thickness: 2, height: 1),
            const SizedBox(height: 10),
            if (videos.isNotEmpty)
              SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        return link(videos[index]);
                      },
                    )
                  ],
                ),
              )
            else
              Text(mensajeVacio, textAlign: TextAlign.center, style: styleTexto.labelSmall),
          ],
        ),
      ),
    );
  }

  Widget link(final String linkVideo) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: CustomLinks().link(linkVideo, 'assets/images/${linkVideo.contains("youtu") ? "youtube.png" : "twitch.png"}', tamanio: 50),
    );
  }

  Widget _recordPartida(final PartidaDto detallePartida) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: ViewData().decorationContainerBasic(color: color),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('¿Primera Partida?', style: styleTexto.titleMedium)),
            const SizedBox(height: 10),
            Divider(color: color.tertiary, thickness: 2, height: 1),
            IntrinsicHeight(
              child: Row(
                children: [
                  ViewData().muestraInformacionAccion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaJugador == true ? 'Si' : 'No', style: styleTexto.titleLarge?.copyWith(color: color.outline)),
                    const Text('Jugador'),
                    const SizedBox(height: 10),
                  ]),
                  VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                  ViewData().muestraInformacionAccion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaHispano == true ? 'Si' : 'No', style: styleTexto.titleLarge?.copyWith(color: color.outline)),
                    const Text('Hispano'),
                    const SizedBox(height: 10),
                  ]),
                  VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                  ViewData().muestraInformacionAccion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaMundo == true ? 'Si' : 'No', style: styleTexto.titleLarge?.copyWith(color: color.outline)),
                    const Text('Mundial'),
                    const SizedBox(height: 10),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumenPartida(JuegoDto juegoDto, PartidaDto? detallePartida, JugadorDto? detalleJugador) {
    if (detallePartida == null || detalleJugador == null) {
      return const SizedBox(height: 100, child: PantallaCargaBasica(texto: "Consultando las partidas del juego seleccionado"));
    }

    return IntrinsicHeight(
      child: Column(
        children: [
          ViewData().muestraInformacionAccion(
              accion: () => _navegarPage(1),
              items: [Text(detalleJugador.nombre.toString(), style: styleTexto.titleLarge?.copyWith(color: color.outline)), const Text('Jugador')]),
          ViewData().muestraInformacionAccion(
            accion: () => _navegarPage(1),
            items: [
              Text(HumanFormat.fechaSmall(detallePartida.fecha), style: styleTexto.bodyLarge?.copyWith(color: color.outline)),
              const Text('Fecha partida')
            ],
          ),
          ViewData().muestraInformacionAccion(
            accion: () => _navegarPage(1),
            items: [
              Text(detallePartida.nombre.toString(), textAlign: TextAlign.center, style: styleTexto.bodyLarge?.copyWith(color: color.outline)),
              const Text('Nombre partida')
            ],
          ),
        ],
      ),
    );
  }
}
