import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/delegates/juegos/cabecera_juego_delegate.dart';
import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
import 'package:no_hit/presentation/widgets/partida/partida.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetalleJuego extends ConsumerStatefulWidget {
  final JuegoDto juego;
  final String heroTag;

  const DetalleJuego({super.key, required this.juego, required this.heroTag});

  @override
  DetalleJuegoState createState() => DetalleJuegoState();
}

class DetalleJuegoState extends ConsumerState<DetalleJuego> {
  final double tamanioImagen = 150;
  late ColorScheme color;
  late TextTheme styleTexto;

  @override
  void initState() {
    super.initState();
    ref.read(partidasJuegoProvider.notifier).loadData(widget.juego.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ResumenJuegoDto? resumenPartidasJuego = ref.watch(partidasJuegoProvider)[widget.juego.id];
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        drawer: const CustomNavigation(),
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
                delegate: CustomSliverAppBarDelegate(
                    juego: widget.juego, expandedHeight: MediaQuery.of(context).size.height * 0.35, heroTag: widget.heroTag),
                pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    JuegoCommons().subtitulo(widget.juego, null, context),
                    _resumenPartidas(resumenPartidasJuego),
                    const SizedBox(height: 10)
                  ],
                ),
              );
            }, childCount: 1))
          ],
        ),
      ),
    );
  }

  Widget _resumenPartidas(ResumenJuegoDto? resumenPartidasJuego) {
    if (resumenPartidasJuego == null) {
      return const SizedBox(height: 300, child: PantallaCargaBasica(texto: "Consultando las partidas del juego seleccionado"));
    }

    return IntrinsicHeight(
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                ViewData().muestraInformacion(
                  alineacion: CrossAxisAlignment.center,
                  items: [
                    Text(resumenPartidasJuego.cantidadPartidas.toString(), style: styleTexto.displaySmall?.copyWith(color: color.outline)),
                    Text('Partida${resumenPartidasJuego.cantidadPartidas != 1 ? 's' : ''}')
                  ],
                  accion: () => showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    isDismissible: true,
                    enableDrag: true,
                    builder: (context) => DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 1,
                      builder: (context, scrollController) => ListView(
                        controller: scrollController,
                        children: [
                          Center(child: Text("Partidas", style: styleTexto.titleLarge)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Divider(color: color.tertiary.withOpacity(0.5), thickness: 2, height: 1),
                          ),
                          const SizedBox(height: 20),
                          _listaPartidas(resumenPartidasJuego.partidas.reversed.toList(), scrollController)
                        ],
                      ),
                    ),
                  ),
                ),
                VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                  Text(resumenPartidasJuego.cantidadJugadores.toString(), style: styleTexto.displaySmall?.copyWith(color: color.outline)),
                  Text('Jugador${resumenPartidasJuego.cantidadJugadores != 1 ? 'es' : ''}')
                ]),
              ],
            ),
          ),
          _primeraUltimaPartida(resumenPartidasJuego)
        ],
      ),
    );
  }

  Widget _primeraUltimaPartida(final ResumenJuegoDto resumenPartidasJuego) {
    if (resumenPartidasJuego.partidas.isNotEmpty) {
      return IntrinsicHeight(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          decoration: ViewData().decorationContainerBasic(color: color),
          child: IntrinsicHeight(
            child: Column(children: [
              ViewData().muestraInformacion(
                  alineacion: CrossAxisAlignment.start,
                  items: [
                    Text(resumenPartidasJuego.primeraPartida!.nombreJugador.toString(), style: styleTexto.titleMedium),
                    Text(resumenPartidasJuego.primeraPartida!.nombre.toString(),
                        style: styleTexto.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(resumenPartidasJuego.primeraPartida!.fecha.toString(), style: styleTexto.bodySmall),
                    Text(
                      'Primera ${resumenPartidasJuego.primeraPartida!.id == resumenPartidasJuego.ultimaPartida!.id ? 'y unica ' : ''}partida',
                      style: styleTexto.bodyLarge?.copyWith(color: color.outline),
                    )
                  ],
                  accion: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                        return FadeTransition(
                            opacity: animation,
                            child: DetallePartidaView(
                                partidaId: resumenPartidasJuego.primeraPartida!.id,
                                jugadorId: resumenPartidasJuego.primeraPartida!.idJugador,
                                heroTag: widget.heroTag,
                                idJuego: resumenPartidasJuego.primeraPartida!.idJuego,
                                nombreJuego: resumenPartidasJuego.primeraPartida!.tituloJuego.toString(),
                                urlImagenJuego: ""));
                      }))),
              Visibility(
                visible: resumenPartidasJuego.primeraPartida!.id != resumenPartidasJuego.ultimaPartida!.id,
                child: Divider(color: color.tertiary, thickness: 2, height: 1),
              ),
              Visibility(
                  visible: resumenPartidasJuego.primeraPartida!.id != resumenPartidasJuego.ultimaPartida!.id,
                  child: ViewData().muestraInformacion(
                      alineacion: CrossAxisAlignment.end,
                      items: [
                        Text(resumenPartidasJuego.ultimaPartida!.nombreJugador.toString(), style: styleTexto.titleMedium),
                        Text(resumenPartidasJuego.ultimaPartida!.nombre.toString(),
                            style: styleTexto.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(resumenPartidasJuego.ultimaPartida!.fecha.toString(), style: styleTexto.bodySmall),
                        Text('Ultima partida', style: styleTexto.bodyLarge?.copyWith(color: color.outline))
                      ],
                      accion: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                            return FadeTransition(
                                opacity: animation,
                                child: DetallePartidaView(
                                  partidaId: resumenPartidasJuego.ultimaPartida!.id,
                                  jugadorId: resumenPartidasJuego.ultimaPartida!.idJugador,
                                  heroTag: widget.heroTag,
                                  idJuego: resumenPartidasJuego.ultimaPartida!.idJuego,
                                  nombreJuego: resumenPartidasJuego.ultimaPartida!.tituloJuego.toString(),
                                  urlImagenJuego: "",
                                ));
                          }))))
            ]),
          ),
        ),
      );
    } else {
      return const SizedBox(height: 1);
    }
  }

  Widget _listaPartidas(final List<PartidaDto>? partidas, final ScrollController scrollController) {
    if (partidas == null || partidas.isEmpty) {
      return const Center(
        child: Text("El juego no posee partidas."),
      );
    }

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: partidas.length,
      itemBuilder: (BuildContext context, int index) {
        PartidaDto partida = partidas[index];
        return PartidaCommons()
            .tarjetaPartidaJuegoJugador(partida: partida, context: context, partidaUnica: partidas.length == 1, mostrarJugador: true);
      },
    );
  }
}
