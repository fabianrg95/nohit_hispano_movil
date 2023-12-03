import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
import 'package:no_hit/presentation/widgets/partida/partida.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetalleJugadorView extends ConsumerStatefulWidget {
  final int idJugador;

  const DetalleJugadorView({super.key, required this.idJugador});

  @override
  DetalleJugadorState createState() => DetalleJugadorState();
}

class DetalleJugadorState extends ConsumerState<DetalleJugadorView> {
  @override
  void initState() {
    super.initState();
    ref.read(detalleJugadorProvider.notifier).loadData(widget.idJugador);
  }

  @override
  Widget build(BuildContext context) {
    final JugadorDto? jugador = ref.watch(detalleJugadorProvider)[widget.idJugador];

    if (jugador == null || jugador.id == 0 || jugador.id != widget.idJugador) {
      return const PantallaCargaBasica(texto: "Consultando la informacion del jugador");
    }

    return SafeArea(
      child: Scaffold(
        appBar: _cabecera(jugador),
        body: _contenido(jugador),
      ),
    );
  }

  AppBar _cabecera(final JugadorDto jugador) {
    return AppBar(
        title: Text(jugador.nombre!),
        actions: [Padding(padding: const EdgeInsets.only(right: 5), child: BanderaJugador(codigoBandera: jugador.codigoBandera))]);
  }

  Widget _contenido(final JugadorDto jugador) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: ViewData().decorationContainerBasic(),
            child: JugadorCommons().informacionJugadorLite(jugador),
          ),
        ),
        _resumenPartidas(jugador: jugador),
        _Partidas(jugador: jugador)
      ],
    );
  }

  Widget _resumenPartidas({required JugadorDto jugador}) {
    return IntrinsicHeight(
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                  Text(jugador.cantidadPartidas.toString(), style: styleTexto.displaySmall?.copyWith(color: color.outline)),
                  Text('Partida${jugador.cantidadPartidas != 1 ? 's' : ''}')
                ]),
                VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                  Text(jugador.juegos.length.toString(), style: styleTexto.displaySmall?.copyWith(color: color.outline)),
                  Text('Juego${jugador.juegos.length != 1 ? 's' : ''}')
                ]),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: ViewData().decorationContainerBasic(),
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
                                  urlImagenJuego: ""
                                ));
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
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: jugador.juegos.length,
        itemBuilder: (context, index) {
          final JuegoDto juego = jugador.juegos[index];
          return GestureDetector(
              onTap: () => _informacionPartidasJugador(partidas: juego.partidas, context: context),
              child: CardJuego(juego: juego, accion: null, posicionInversa: index.isOdd));
        });
  }

  Future _informacionPartidasJugador({required List<PartidaDto> partidas, required BuildContext context}) {
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
                    return PartidaCommons().tarjetaPartidaJuegoJugador(partida: partida, context: context, partidaUnica: partidas.length == 1);
                  },
                )
              ]),
            ));
  }
}
