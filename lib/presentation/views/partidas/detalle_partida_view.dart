import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/partidas/detalle_partida_provider.dart';
import 'package:no_hit/infraestructure/providers/partidas/partidas_juego_provider.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/delegates/juegos/cabecera_juego_delegate.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetallePartidaView extends ConsumerStatefulWidget {
  final int partidaId;

  const DetallePartidaView({super.key, required this.partidaId});

  @override
  DetallePartidaState createState() => DetallePartidaState();
}

class DetallePartidaState extends ConsumerState<DetallePartidaView> {
  final double tamanioImagen = 150;

  @override
  void initState() {
    super.initState();
    ref.read(detallePartidaProvider.notifier).loadData(widget.partidaId);
  }

  @override
  Widget build(BuildContext context) {
    final PartidaDto? detallePartida = ref.watch(detallePartidaProvider)[widget.partidaId];
    late JuegoDto juegoDto;

    if (detallePartida == null) {
      return const PantallaCargaBasica(texto: 'Consultando informacion de la partida');
    }

    juegoDto = JuegoDto(
        id: detallePartida.idJuego,
        nombre: detallePartida.tituloJuego.toString(),
        subtitulo: detallePartida.subtituloJuego,
        urlImagen: detallePartida.urlImagenJuego);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(delegate: CustomSliverAppBarDelegate(juego: juegoDto, expandedHeight: size.height * 0.35), pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _subtitulo(juegoDto),
                  ],
                ),
              );
            }, childCount: 1))
          ],
        ),
      ),
    );
  }

  Visibility _subtitulo(final JuegoDto juegoDto) {
    return Visibility(
        visible: juegoDto.subtitulo != null,
        child: Container(
          width: size.width,
          margin: const EdgeInsets.only(left: 25, right: 25),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
          child: Center(child: Text(juegoDto.subtitulo.toString(), style: styleTexto.titleMedium)),
        ));
  }

  Widget _muestraInformacion({required List<Widget> items, required CrossAxisAlignment alineacion}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
        child: Row(children: [Expanded(child: Column(crossAxisAlignment: alineacion, children: items))]),
      ),
    );
  }

}
