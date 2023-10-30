import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/delegates/juegos/cabecera_juego_delegate.dart';
import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetalleJuego extends ConsumerStatefulWidget {
  final JuegoDto juego;

  const DetalleJuego({super.key, required this.juego});

  @override
  DetalleJuegoState createState() => DetalleJuegoState();
}

class DetalleJuegoState extends ConsumerState<DetalleJuego> {
  final double tamanioImagen = 150;

  @override
  void initState() {
    super.initState();
    ref.read(partidasJuegoProvider.notifier).loadData(widget.juego.id);
  }

  @override
  Widget build(BuildContext context) {
    final ResumenJuegoDto? resumenPartidasJuego = ref.watch(partidasJuegoProvider)[widget.juego.id];

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(delegate: CustomSliverAppBarDelegate(juego: widget.juego, expandedHeight: size.height * 0.35), pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _subtitulo(),
                    _resumenPartidas(resumenPartidasJuego),
                    const SizedBox(height: 10),
                    _listaPartidas(resumenPartidasJuego?.partidas.reversed.toList())
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
                _muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                  const SizedBox(height: 5),
                  Text(resumenPartidasJuego.cantidadPartidas.toString(), style: styleTexto.titleLarge),
                  Text('Partida${resumenPartidasJuego.cantidadPartidas != 1 ? 's' : ''}')
                ]),
                VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                _muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                  const SizedBox(height: 5),
                  Text(resumenPartidasJuego.cantidadJugadores.toString(), style: styleTexto.titleLarge),
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
          decoration: AppTheme.decorationContainerBasic(bottomLeft: true, bottomRight: true, topLeft: true, topRight: true),
          child: IntrinsicHeight(
            child: Column(children: [
              _muestraInformacion(alineacion: CrossAxisAlignment.start, items: [
                Text(resumenPartidasJuego.primeraPartida!.nombreJugador.toString(), style: styleTexto.bodyMedium),
                Text(resumenPartidasJuego.primeraPartida!.nombre.toString(),
                    style: styleTexto.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(resumenPartidasJuego.primeraPartida!.fecha.toString(), style: styleTexto.bodySmall),
                Text(
                  'Primera ${resumenPartidasJuego.primeraPartida!.id == resumenPartidasJuego.ultimaPartida!.id ? 'y unica' : ''} partida',
                  style: styleTexto.bodyLarge?.copyWith(color: AppTheme.textoResaltado),
                )
              ]),
              Visibility(
                visible: resumenPartidasJuego.primeraPartida!.id != resumenPartidasJuego.ultimaPartida!.id,
                child: Divider(color: color.tertiary, thickness: 2, height: 1),
              ),
              Visibility(
                  visible: resumenPartidasJuego.primeraPartida!.id != resumenPartidasJuego.ultimaPartida!.id,
                  child: _muestraInformacion(alineacion: CrossAxisAlignment.end, items: [
                    Text(resumenPartidasJuego.partidas.last.nombreJugador.toString(), style: styleTexto.bodyMedium),
                    Text(resumenPartidasJuego.partidas.last.nombre.toString(),
                        style: styleTexto.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(resumenPartidasJuego.partidas.last.fecha.toString(), style: styleTexto.bodySmall),
                    Text(
                      'Ultima partida',
                      style: styleTexto.bodyLarge?.copyWith(color: AppTheme.textoResaltado),
                    )
                  ]))
            ]),
          ),
        ),
      );
    } else {
      return const SizedBox(height: 1);
    }
  }

  Widget _subtitulo() {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(left: 25, right: 25),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
      child: Column(children: [
        Text(widget.juego.nombre.toString(), style: styleTexto.titleLarge),
        Visibility(
          visible: widget.juego.subtitulo != null,
          child: Text(widget.juego.subtitulo.toString(), style: styleTexto.titleMedium),
        ),
      ]),
    );
  }

  Widget _muestraInformacion({required List<Widget> items, required CrossAxisAlignment alineacion}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
        child: Row(children: [Expanded(child: Column(crossAxisAlignment: alineacion, children: items))]),
      ),
    );
  }

  Widget _listaPartidas(List<PartidaDto>? partidas) {
    if (partidas == null || partidas.isEmpty) {
      return const SizedBox(height: 1);
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: partidas.isEmpty ? 0 : partidas.length,
      itemBuilder: (BuildContext context, int index) {
        PartidaDto partida = partidas[index];
        final bool par = index.isOdd;
        return _tarjetaPartidaJuegoJugador(partida: partida, par: par, context: context);
      },
    );
  }

  Widget _tarjetaPartidaJuegoJugador({required PartidaDto partida, required bool par, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: Transform.rotate(
        angle: -0.02 + Random().nextDouble() * (0.02 - -0.02),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
            return FadeTransition(
                opacity: animation,
                child: DetallePartidaView(
                  partidaId: partida.id,
                  jugadorId: partida.idJugador,
                ));
          })),
          child: Container(
            decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
            child: Column(
              children: [
                Text(partida.nombreJugador.toString(), style: styleTexto.bodyMedium),
                Text(partida.nombre.toString(),
                    style: styleTexto.bodySmall, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(partida.fecha.toString(), style: styleTexto.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
