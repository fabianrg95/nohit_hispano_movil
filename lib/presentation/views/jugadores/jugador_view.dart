import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/app_info.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
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
      onPopInvokedWithResult: (didPop, result) {
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
                            icon: Icon(iconoFlechaAtras),
                          )),
                    ),
                    forceMaterialTransparency: pageViewIndex == 0,
                    elevation: 0,
                    title: Text(titulosPageView[pageViewIndex]!),
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
                                _guardarJugadorFavorito();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: color.surfaceContainerHighest,
                                    action: SnackBarAction(
                                      backgroundColor: color.tertiary,
                                      label: 'Deshacer',
                                      onPressed: () => _guardarJugadorFavorito(),
                                      textColor: color.onTertiary,
                                    ),
                                    content: Text(
                                      'Jugador ${jugadorFavorito ? 'agregado a' : 'eliminado de'} favoritos.',
                                      style: styleTexto.bodyLarge?.copyWith(color: color.outline),
                                    )));
                              },
                              color: color.tertiary,
                              highlightColor: color.tertiary,
                              icon: Visibility(
                                  visible: jugadorFavorito,
                                  replacement: const Icon(Icons.favorite_border_outlined),
                                  child: const Icon(Icons.favorite)),
                            )),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(children: [
                          _cabecera(jugador, offsetValue),
                          Padding(padding: EdgeInsets.only(top: AppInfo().porcentajeAlto(0.29)), child: _contenido(jugador))
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(color: color.tertiary.withValues(alpha: 0.5), thickness: 1, height: 1),
                        ),
                        const SizedBox(height: 10),
                        Text('Juegos', style: styleTexto.titleLarge?.copyWith(color: color.tertiary)),
                        _Partidas(jugador: jugador)
                      ],
                    ),
                  )

                  // Stack(children: [
                  //   _cabecera(jugador, offsetValue),
                  //   PageView(
                  //     controller: _pageController,
                  //     onPageChanged: (value) => setState(() {
                  //       pageViewIndex = value;
                  //     }),
                  //     scrollDirection: Axis.horizontal,
                  //     children: [
                  //       Align(
                  //         alignment: FractionalOffset(0, (jugador.partidas.length > 1 ? 0.57 : 0.48) + offsetValue),
                  //         child: FadeTransition(
                  //             opacity: AlwaysStoppedAnimation(1 - (offsetValue * 2)),
                  //             child: Column(
                  //               children: [
                  //                 _contenido(jugador),
                  //                 const Expanded(child: SizedBox(height: 1)),
                  //                 GestureDetector(onTap: () => _navegarPage(1), child: const ShimmerArrows(icon: Icons.keyboard_arrow_right)),
                  //               ],
                  //             )),
                  //       ),
                  //       PageView(physics: const NeverScrollableScrollPhysics(), children: [_Partidas(jugador: jugador)])
                  //     ],
                  //   ),
                  // ]),
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
    late ImageProvider<Object> image;

    if (jugador.codigoBandera == null) {
      image = Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png').image;
    } else {
      image = Image.asset('icons/flags/png250px/${jugador.codigoBandera}.png', package: 'country_icons').image;
    }

    return SizedBox(
      height: AppInfo().porcentajeAlto(0.35),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: color.tertiary, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150), bottomRight: Radius.circular(150))),
            height: AppInfo().porcentajeAlto(0.24),
          ),
          Padding(
            padding: EdgeInsets.only(top: AppInfo().porcentajeAlto(0.04)),
            child: Center(
              child: Container(
                width: AppInfo().porcentajeAncho(0.57),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.primary,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              width: AppInfo().porcentajeAncho(0.45),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(image: image, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido(final JugadorDto jugador) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 2),
            color: color.surfaceContainerHighest.withValues(alpha: 0.7),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(
              child: Text(
                jugador.nombre!,
                style: styleTexto.titleLarge?.copyWith(
                  color: color.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        JugadorCommons().informacionJugadorMejorada(jugador, context, mostrarBandera: false),
        informacionPartidasJuegos(jugador),
        _resumenPartidas(jugador: jugador),
      ],
    );
  }

  Widget informacionPartidasJuegos(JugadorDto jugador) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 2),
              color: color.surfaceContainerHighest.withValues(alpha: 0.7),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _statsItem(
                valor: jugador.juegos.length.toString(),
                etiqueta: AppLocalizations.of(context)!.juegos((jugador.juegos.length != 1).toString()),
                onTap: () {
                  setState(() {
                    _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 2),
              color: color.surfaceContainerHighest.withValues(alpha: 0.7),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _statsItem(
                valor: jugador.cantidadPartidas.toString(),
                etiqueta: AppLocalizations.of(context)!.partidas((jugador.cantidadPartidas != 1).toString()),
                onTap: () {
                  setState(() {
                    _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statsItem({required String valor, required String etiqueta, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            valor,
            style: styleTexto.titleLarge?.copyWith(
              color: color.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: styleTexto.bodySmall?.copyWith(
              color: color.outline.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _resumenPartidas({required JugadorDto jugador}) {
    return Column(
      children: [
        _resumenPartidaItem(
          partida: jugador.primeraPartida!,
          etiqueta: AppLocalizations.of(context)!.primera_partida((jugador.primeraPartida!.id == jugador.ultimaPartida!.id).toString()),
          onTap: () => navegarPartida(jugador.primeraPartida!),
        ),
        if (jugador.primeraPartida!.id != jugador.ultimaPartida!.id) ...[
          _resumenPartidaItem(
            partida: jugador.ultimaPartida!,
            etiqueta: AppLocalizations.of(context)!.ultima_partida,
            onTap: () => navegarPartida(jugador.ultimaPartida!),
          ),
        ]
      ],
    );
  }

  Widget _resumenPartidaItem({required PartidaDto partida, required String etiqueta, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 2),
          color: color.surfaceContainerHighest.withValues(alpha: 0.7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${partida.tituloJuego.toString()} ${partida.subtituloJuego ?? ''}',
                style: styleTexto.titleMedium?.copyWith(
                  color: color.tertiary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                partida.nombre.toString(),
                style: styleTexto.bodySmall?.copyWith(
                  color: color.outline.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    HumanFormat.fecha(partida.fecha.toString()),
                    style: styleTexto.labelSmall?.copyWith(
                      color: color.outline.withValues(alpha: 0.5),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: color.primary.withValues(alpha: 0.1),
                    ),
                    child: Text(
                      etiqueta,
                      style: styleTexto.labelSmall?.copyWith(
                        color: color.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 260, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: widget.jugador.juegos.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
              snap: true,
              minChildSize: 0.1,
              maxChildSize: 1,
              builder: (context, scrollController) => ListView(controller: scrollController, children: [
                Center(child: Text(partidas.first.tituloJuego!, style: styleTexto.titleLarge)),
                if (partidas.first.subtituloJuego != null) Center(child: Text(partidas.first.subtituloJuego!, style: styleTexto.titleSmall)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Divider(color: color.tertiary.withAlpha(50), thickness: 2, height: 1),
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
