import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/delegates/juegos/cabecera_juego_delegate.dart';
import 'package:no_hit/presentation/views/jugadores/jugador_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetallePartidaView extends ConsumerStatefulWidget {
  final int partidaId;
  final int jugadorId;

  const DetallePartidaView({super.key, required this.partidaId, required this.jugadorId});

  @override
  DetallePartidaState createState() => DetallePartidaState();
}

class DetallePartidaState extends ConsumerState<DetallePartidaView> {
  final double tamanioImagen = 150;

  @override
  void initState() {
    super.initState();
    ref.read(detallePartidaProvider.notifier).loadData(widget.partidaId);
    ref.read(detalleJugadorProvider.notifier).loadData(widget.jugadorId);
  }

  @override
  Widget build(BuildContext context) {
    final PartidaDto? detallePartida = ref.watch(detallePartidaProvider)[widget.partidaId];
    final JugadorDto? detalleJugador = ref.watch(detalleJugadorProvider)[widget.jugadorId];
    late JuegoDto juegoDto;

    if (detallePartida == null || detalleJugador == null) {
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
                    _informacionJugador(detalleJugador),
                    _informacionPartida(detallePartida),
                    _recordPartida(detallePartida),
                    const SizedBox(height: 20)
                  ],
                ),
              );
            }, childCount: 1))
          ],
        ),
      ),
    );
  }

  Widget _informacionJugador(final JugadorDto detalleJugador) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: detalleJugador.id!));
      })),
      child: Container(
        margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
        child: IntrinsicHeight(
          child: Column(
            children: [
              const Center(child: Text('Informacion Jugador')),
              const SizedBox(height: 10),
              Divider(color: color.tertiary, thickness: 2, height: 1),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30),
                    child: BanderaJugador(codigoBandera: detalleJugador.codigoBandera, tamanio: 60, defaultNegro: true),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(detalleJugador.nombre.toString()),
                        Visibility(visible: detalleJugador.pronombre != null, child: Text(detalleJugador.pronombre.toString())),
                        Visibility(visible: detalleJugador.gentilicio != null, child: Text(detalleJugador.gentilicio.toString())),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          CustomLinks().link(detalleJugador.urlYoutube, 'assets/images/youtube.png'),
                          Visibility(
                              visible: detalleJugador.urlYoutube != null && detalleJugador.urlTwitch != null,
                              child: VerticalDivider(
                                color: color.tertiary,
                              )),
                          CustomLinks().link(detalleJugador.urlTwitch, 'assets/images/twitch.png')
                        ])
                      ],
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

  Widget _informacionPartida(final PartidaDto detallePartida) {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text('Informacion Partida')),
            const SizedBox(height: 10),
            Divider(color: color.tertiary, thickness: 2, height: 1),
            const SizedBox(height: 10),
            Text(detallePartida.nombre.toString(), textAlign: TextAlign.center),
            Text(detallePartida.fecha.toString()),
          ],
        ),
      ),
    );
  }

  Widget _recordPartida(final PartidaDto detallePartida) {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
      child: IntrinsicHeight(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Center(child: Text('¿Primera Partida?')),
            const SizedBox(height: 10),
            Divider(color: color.tertiary, thickness: 2, height: 1),
            IntrinsicHeight(
              child: Row(
                children: [
                  ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaJugador == true ? 'Si' : 'No', style: styleTexto.titleLarge),
                    const Text('Jugador'),
                    const SizedBox(height: 10),
                  ]),
                  VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                  ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaHispano == true ? 'Si' : 'No', style: styleTexto.titleLarge),
                    const Text('Hispano'),
                    const SizedBox(height: 10),
                  ]),
                  VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                  ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaMundo == true ? 'Si' : 'No', style: styleTexto.titleLarge),
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
}
