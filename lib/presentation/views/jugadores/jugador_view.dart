import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
import 'package:no_hit/presentation/widgets/commons/arrow.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetalleJugadorView extends ConsumerStatefulWidget {
  final int idJugador;

  const DetalleJugadorView({super.key, required this.idJugador});

  @override
  DetalleJugadorState createState() => DetalleJugadorState();
}

class DetalleJugadorState extends ConsumerState<DetalleJugadorView> {
  late ColorScheme color;
  late TextTheme styleTexto;

  int pageViewIndex = 0;
  final Map<int, String> titulosPageView = {0: '', 1: 'Juegos'};

  ValueNotifier<double> offset = ValueNotifier(0);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ref.read(detalleJugadorProvider.notifier).loadData(widget.idJugador);
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

  @override
  Widget build(BuildContext context) {
    final JugadorDto? jugador = ref.watch(detalleJugadorProvider)[widget.idJugador];
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;

    if (jugador == null || jugador.id == 0 || jugador.id != widget.idJugador) {
      return const PantallaCargaBasica(texto: "Consultando la informacion del jugador");
    }

    return ValueListenableBuilder(
        valueListenable: offset,
        builder: (BuildContext context, offsetValue, _) {
          return SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar:
                  AppBar(forceMaterialTransparency: pageViewIndex == 0 ? true : false, elevation: 0, title: Text(titulosPageView[pageViewIndex]!)),
              body: Stack(children: [
                _cabecera(jugador, offsetValue),
                Align(
                  alignment: FractionalOffset(0, (jugador.partidas.length > 1 ? 0.57 : 0.48) + offsetValue),
                  child: FadeTransition(
                    opacity: AlwaysStoppedAnimation(1 - offsetValue),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [_contenido(jugador)]),
                  ),
                ),
                PageView(
                  controller: _pageController,
                  onPageChanged: (value) => setState(() {
                    pageViewIndex = value;
                  }),
                  scrollDirection: Axis.horizontal,
                  children: [
                    FadeTransition(
                        opacity: AlwaysStoppedAnimation(1 - (offsetValue * 2)),
                        child: const Align(alignment: FractionalOffset(0, 1), child: ShimmerArrows(icon: Icons.keyboard_arrow_right))),
                    _Partidas(jugador: jugador)
                  ],
                )
              ]),
            ),
          );
        });
  }

  Widget _cabecera(final JugadorDto jugador, double offsetValue) {
    final size = MediaQuery.of(context).size;
    late ImageProvider<Object> image;

    if (jugador.codigoBandera == null) {
      image = Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png').image;
    } else {
      image = Image.asset('icons/flags/png/${jugador.codigoBandera}.png', package: 'country_icons').image;
    }

    return FadeTransition(
      opacity: AlwaysStoppedAnimation(1 - (offsetValue * 2.2)),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image,
            fit: jugador.codigoBandera != null ? BoxFit.cover : BoxFit.contain,
          ),
        ),
        height: size.height * 0.25,
        child: Stack(
          children: [
            if (jugador.codigoBandera != null)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.7, 1],
                    colors: [Colors.transparent, color.primary],
                  ),
                ),
              ),
            if (jugador.codigoBandera != null)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0, 0.2],
                    colors: [color.primary, Colors.transparent],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _contenido(final JugadorDto jugador) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: ViewData().decorationContainerBasic(color: color),
            child: Center(
                child: Text(
              jugador.nombre!,
              style: styleTexto.titleLarge,
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.09),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: ViewData().decorationContainerBasic(color: color),
              child: JugadorCommons().informacionJugadorLite(jugador),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                Text(jugador.juegos.length.toString(), style: styleTexto.displaySmall?.copyWith(color: color.outline)),
                Text('Juego${jugador.juegos.length != 1 ? 's' : ''}')
              ]),
              ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                Text(jugador.cantidadPartidas.toString(), style: styleTexto.displaySmall?.copyWith(color: color.outline)),
                Text('Partida${jugador.cantidadPartidas != 1 ? 's' : ''}')
              ]),
            ],
          ),
          const SizedBox(height: 10),
          _resumenPartidas(jugador: jugador),
        ],
      ),
    );
  }

  Widget _resumenPartidas({required JugadorDto jugador}) {
    return IntrinsicHeight(
      child: Column(
        children: [
          IntrinsicHeight(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: ViewData().decorationContainerBasic(color: color),
              child: Column(
                children: [
                  ViewData().muestraInformacion(
                      alineacion: CrossAxisAlignment.start,
                      items: [
                        Text('${jugador.primeraPartida!.tituloJuego.toString()} ${jugador.primeraPartida!.subtituloJuego ?? ''}',
                            style: styleTexto.titleMedium),
                        Text(jugador.primeraPartida!.nombre.toString(),
                            style: styleTexto.labelSmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(jugador.primeraPartida!.fecha.toString(), style: styleTexto.labelSmall),
                        Text(
                          'Primera ${jugador.primeraPartida!.id == jugador.ultimaPartida!.id ? 'y unica ' : ''}partida',
                          style: styleTexto.bodyLarge?.copyWith(color: color.outline),
                        )
                      ],
                      accion: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                            return FadeTransition(
                                opacity: animation,
                                child: DetallePartidaView(
                                    partidaId: jugador.primeraPartida!.id,
                                    jugadorId: jugador.primeraPartida!.idJugador,
                                    heroTag: jugador.primeraPartida!.id.toString(),
                                    idJuego: jugador.primeraPartida!.idJuego,
                                    nombreJuego: jugador.primeraPartida!.tituloJuego.toString(),
                                    urlImagenJuego: ""));
                          }))),
                  Visibility(
                    visible: jugador.primeraPartida!.id != jugador.ultimaPartida!.id,
                    child: Divider(color: color.tertiary, thickness: 2, height: 1),
                  ),
                  Visibility(
                      visible: jugador.primeraPartida!.id != jugador.ultimaPartida!.id,
                      child: ViewData().muestraInformacion(
                          alineacion: CrossAxisAlignment.end,
                          items: [
                            Text('${jugador.ultimaPartida!.tituloJuego.toString()} ${jugador.ultimaPartida!.subtituloJuego ?? ''}',
                                style: styleTexto.titleMedium),
                            Text(jugador.ultimaPartida!.nombre.toString(),
                                style: styleTexto.labelSmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(jugador.ultimaPartida!.fecha.toString(), style: styleTexto.labelSmall),
                            Text('Ultima partida', style: styleTexto.bodyLarge?.copyWith(color: color.outline))
                          ],
                          accion: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                                return FadeTransition(
                                    opacity: animation,
                                    child: DetallePartidaView(
                                        partidaId: jugador.ultimaPartida!.id,
                                        jugadorId: jugador.ultimaPartida!.idJugador,
                                        heroTag: jugador.ultimaPartida!.id.toString(),
                                        idJuego: jugador.ultimaPartida!.idJuego,
                                        nombreJuego: jugador.ultimaPartida!.tituloJuego.toString(),
                                        urlImagenJuego: ""));
                              }))))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Partidas extends StatelessWidget {
  final JugadorDto jugador;

  const _Partidas({required this.jugador});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 260 //tamaño alto de cada item
            ),
        itemCount: jugador.juegos.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final JuegoDto juego = jugador.juegos[index];
          return GestureDetector(
              onTap: () => _informacionPartidasJugador(partidas: juego.partidas, context: context), child: CardJuego(juego: juego, accion: null));
        });
  }

  Future _informacionPartidasJugador({required List<PartidaDto> partidas, required BuildContext context}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;

    return showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 1,
              expand: false,
              builder: (context, scrollController) => ListView(controller: scrollController, children: [
                Center(child: Text(partidas.first.tituloJuego!, style: styleTexto.titleLarge)),
                if (partidas.first.subtituloJuego != null) Center(child: Text(partidas.first.subtituloJuego!, style: styleTexto.titleSmall)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Divider(color: color.tertiary.withOpacity(0.5), thickness: 2, height: 1),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: partidas.isEmpty ? 0 : partidas.length,
                  itemBuilder: (BuildContext context, int index) {
                    PartidaDto partida = partidas[index];
                    return PartidaCommons().tarjetaPartidaJuegoJugador(partida: partida, context: context);
                  },
                )
              ]),
            ));
  }
}
