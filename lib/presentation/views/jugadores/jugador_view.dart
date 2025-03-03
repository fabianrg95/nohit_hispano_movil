import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
import 'package:no_hit/presentation/widgets/commons/arrow.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class DetalleJugadorView extends ConsumerStatefulWidget {
  final int idJugador;

  const DetalleJugadorView({super.key, required this.idJugador});

  @override
  DetalleJugadorState createState() => DetalleJugadorState();
}

class DetalleJugadorState extends ConsumerState<DetalleJugadorView> {
  late ColorScheme color;
  late TextTheme styleTexto;
  late Size size;
  IconData iconoFlechaAtras = Icons.arrow_back;
  bool jugadorFavorito = false;

  int pageViewIndex = 0;
  final Map<int, String> titulosPageView = {0: '', 1: 'Juegos'};

  ValueNotifier<double> offset = ValueNotifier(0);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ref.read(detalleJugadorProvider.notifier).loadData(widget.idJugador);
    ref.read(jugadoresFavoritosLocalProvider.notifier).obtenerJugadoresFavoritos();

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

  void _guardarJugadorFavorito() {
    if (jugadorFavorito) {
      ref.read(jugadoresFavoritosLocalProvider.notifier).eliminarJugadorFavorito(widget.idJugador);
      jugadorFavorito = false;
    } else {
      ref.read(jugadoresFavoritosLocalProvider.notifier).guardarJugadorFavorito(widget.idJugador);
      jugadorFavorito = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final JugadorDto? jugador = ref.watch(detalleJugadorProvider)[widget.idJugador];
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;
    List<int> jugadoresFavorito = ref.watch(jugadoresFavoritosLocalProvider);

    jugadorFavorito = jugadoresFavorito.contains(widget.idJugador);

    if (jugador == null || jugador.id == 0 || jugador.id != widget.idJugador) {
      return const PantallaCargaBasica(texto: "Consultando la información del jugador");
    }

    return PopScope(
      canPop: pageViewIndex == 0,
      onPopInvoked: (didPop) {
        if (didPop) return;
        controlarBack(context);
      },
      child: ValueListenableBuilder(
          valueListenable: offset,
          builder: (BuildContext context, offsetValue, _) {
            return SafeArea(
              child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      controlarBack(context);
                    },
                    icon: Icon(iconoFlechaAtras),
                  ),
                  forceMaterialTransparency: pageViewIndex == 0,
                  elevation: 0,
                  title: Text(titulosPageView[pageViewIndex]!),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          _guardarJugadorFavorito();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: color.tertiary,
                              action: SnackBarAction(
                                label: 'Deshacer',
                                onPressed: () => _guardarJugadorFavorito(),
                                textColor: color.surfaceContainerHighest,
                              ),
                              content: Text(
                                'Jugador ${jugadorFavorito ? 'agregado a' : 'eliminado de'} favoritos.',
                                style: styleTexto.bodyLarge?.copyWith(color: color.primary),
                              )));
                        },
                        child: Visibility(
                            visible: jugadorFavorito, replacement: const Icon(Icons.favorite_border_outlined), child: const Icon(Icons.favorite)),
                      ),
                    )
                  ],
                ),
                body: Stack(children: [
                  _cabecera(jugador, offsetValue),
                  PageView(
                    controller: _pageController,
                    onPageChanged: (value) => setState(() {
                      pageViewIndex = value;
                    }),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Align(
                        alignment: FractionalOffset(0, (jugador.partidas.length > 1 ? 0.57 : 0.48) + offsetValue),
                        child: FadeTransition(
                            opacity: AlwaysStoppedAnimation(1 - (offsetValue * 2)),
                            child: Column(
                              children: [
                                _contenido(jugador),
                                const Expanded(child: SizedBox(height: 1)),
                                GestureDetector(onTap: () => _navegarPage(1), child: const ShimmerArrows(icon: Icons.keyboard_arrow_right)),
                              ],
                            )),
                      ),
                      PageView(physics: const NeverScrollableScrollPhysics(), children: [_Partidas(jugador: jugador)])
                    ],
                  ),
                ]),
              ),
            );
          }),
    );
  }

  void controlarBack(BuildContext context) {
    if (pageViewIndex == 0) {
      Navigator.of(context).pop();
    } else {
      _navegarPage(pageViewIndex - 1);
    }
  }

  void _navegarPage(int page) => _pageController.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

  Widget _cabecera(final JugadorDto jugador, double offsetValue) {
    final size = MediaQuery.of(context).size;
    late ImageProvider<Object> image;

    if (jugador.codigoBandera == null) {
      image = Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png').image;
    } else {
      image = Image.asset('icons/flags/png250px/${jugador.codigoBandera}.png', package: 'country_icons').image;
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
              ),
            if (jugador.codigoBandera != null)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
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
    return SizedBox(
      height: size.height * 0.85,
      child: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.13),
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
                child: JugadorCommons().informacionJugadorLite(jugador, context),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ViewData().muestraInformacionAccion(
                    alineacion: CrossAxisAlignment.center,
                    accion: () {
                      setState(() {
                        _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      });
                    },
                    items: [
                      Text(jugador.juegos.length.toString(), style: TextStyle(color: color.outline, fontSize: size.width * 0.08)),
                      Text(AppLocalizations.of(context)!.juegos((jugador.juegos.length != 1).toString()))
                    ]),
                ViewData().muestraInformacionAccion(
                    alineacion: CrossAxisAlignment.center,
                    accion: () {
                      setState(() {
                        _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      });
                    },
                    items: [
                      Text(jugador.cantidadPartidas.toString(), style: TextStyle(color: color.outline, fontSize: size.width * 0.08)),
                      Text(AppLocalizations.of(context)!.partidas((jugador.cantidadPartidas != 1).toString()))
                    ]),
              ],
            ),
            const SizedBox(height: 10),
            _resumenPartidas(jugador: jugador),
          ],
        ),
      ]),
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
                  ViewData().muestraInformacionAccion(
                      alineacion: CrossAxisAlignment.start,
                      items: [
                        Text('${jugador.primeraPartida!.tituloJuego.toString()} ${jugador.primeraPartida!.subtituloJuego ?? ''}',
                            style: styleTexto.titleMedium),
                        Text(jugador.primeraPartida!.nombre.toString(),
                            style: styleTexto.labelSmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(jugador.primeraPartida!.fecha.toString(), style: styleTexto.labelSmall),
                        Text(
                          AppLocalizations.of(context)!.primera_partida((jugador.primeraPartida!.id == jugador.ultimaPartida!.id).toString()),
                          style: styleTexto.bodyLarge?.copyWith(color: color.outline),
                        )
                      ],
                      accion: () => navegarPartida(jugador.primeraPartida!)),
                  Visibility(
                    visible: jugador.primeraPartida!.id != jugador.ultimaPartida!.id,
                    child: Divider(color: color.tertiary, thickness: 2, height: 1),
                  ),
                  Visibility(
                    visible: jugador.primeraPartida!.id != jugador.ultimaPartida!.id,
                    child: ViewData().muestraInformacionAccion(
                        alineacion: CrossAxisAlignment.end,
                        items: [
                          Text('${jugador.ultimaPartida!.tituloJuego.toString()} ${jugador.ultimaPartida!.subtituloJuego ?? ''}',
                              style: styleTexto.titleMedium),
                          Text(jugador.ultimaPartida!.nombre.toString(),
                              style: styleTexto.labelSmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(jugador.ultimaPartida!.fecha.toString(), style: styleTexto.labelSmall),
                          Text(AppLocalizations.of(context)!.ultima_partida, style: styleTexto.bodyLarge?.copyWith(color: color.outline))
                        ],
                        accion: () => navegarPartida(jugador.ultimaPartida!)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navegarPartida(PartidaDto partida) {
    ref.read(informacionJuegoProvider.notifier).saveData(juegoDto: partida.getJuegoDto());

    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, __) => FadeTransition(
            opacity: animation,
            child: DetallePartidaView(
                partidaId: partida.id,
                jugadorId: partida.idJugador,
                heroTag: partida.id.toString(),
                idJuego: partida.idJuego,
                nombreJuego: partida.tituloJuego.toString()))));
  }
}

class _Partidas extends ConsumerStatefulWidget {
  final JugadorDto jugador;

  const _Partidas({required this.jugador});

  @override
  _PartidasState createState() => _PartidasState();
}

class _PartidasState extends ConsumerState<_Partidas> {
  late List<PartidaDto> partidas = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 260),
        itemCount: widget.jugador.juegos.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final JuegoDto juego = widget.jugador.juegos[index];
          return GestureDetector(
              onTap: () => _informacionPartidasJugador(partidas: juego.partidas, context: context, ref: ref),
              child: CardJuego(juego: juego, accion: null));
        });
  }

  Future _informacionPartidasJugador({required List<PartidaDto> partidas, required BuildContext context, required WidgetRef ref}) {
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
                    return PartidaCommons().tarjetaPartidaJuegoJugador(partida: partida, context: context, ref: ref);
                  },
                )
              ]),
            ));
  }
}
