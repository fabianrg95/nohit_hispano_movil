import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/delegates/delegates.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetallePartidaView extends ConsumerStatefulWidget {
  final int partidaId;
  final int jugadorId;
  final int idJuego;
  final String nombreJuego;
  final String urlImagenJuego;
  final String heroTag;

  const DetallePartidaView(
      {super.key,
      required this.partidaId,
      required this.jugadorId,
      required this.heroTag,
      required this.idJuego,
      required this.nombreJuego,
      required this.urlImagenJuego});

  @override
  DetallePartidaState createState() => DetallePartidaState();
}

class DetallePartidaState extends ConsumerState<DetallePartidaView> {
  final double tamanioImagen = 150;
  late ColorScheme color;
  late TextTheme styleTexto;

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
    JuegoDto juegoDto = JuegoDto(id: widget.idJuego, nombre: widget.nombreJuego, urlImagen: widget.urlImagenJuego);
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;

    if (widget.urlImagenJuego == "") {
      const PantallaCargaBasica(
        texto: "Cargando la información de la partida",
      );
    }

    if (detallePartida != null && detalleJugador != null) {
      juegoDto = JuegoDto(
          id: detallePartida.idJuego,
          nombre: detallePartida.tituloJuego.toString(),
          subtitulo: detallePartida.subtituloJuego,
          urlImagen: detallePartida.urlImagenJuego);
    }

    return SafeArea(
      child: Scaffold(
        // drawer: const CustomNavigation(),
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
                delegate:
                    CustomSliverAppBarDelegate(juego: juegoDto, expandedHeight: MediaQuery.of(context).size.height * 0.35, heroTag: widget.heroTag),
                pinned: true),
            contenido(juegoDto, detalleJugador, detallePartida)
          ],
        ),
      ),
    );
  }

  Widget contenido(JuegoDto? juegoDto, JugadorDto? detalleJugador, PartidaDto? detallePartida) {
    if (detallePartida == null || detalleJugador == null || juegoDto == null) {
      return SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => const SingleChildScrollView(
                    child: Column(
                      children: [
                        // PantallaCargaBasica(texto: 'Consultando informacion de la partida'),
                      ],
                    ),
                  ),
              childCount: 1));
    }

    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return SingleChildScrollView(
        child: Column(
          children: [
            JuegoCommons().subtitulo(
                juegoDto,
                () => Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, __) {
                        return FadeTransition(
                            opacity: animation,
                            child: DetalleJuego(
                              juego: juegoDto,
                              heroTag: widget.heroTag,
                            ));
                      },
                    )),
                context),
            JugadorCommons().informacionJugadorGrande(detalleJugador, context),
            _informacionPartida(detallePartida),
            _recordPartida(detallePartida),
            _videos(detallePartida.listaVideosCompletos, 'Videos', "La partida no tiene videos."),
            _videos(detallePartida.listaVideosClips, 'Clips', "La partida no tiene clips."),
            const SizedBox(height: 20)
          ],
        ),
      );
    }, childCount: 1));
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
                  ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaJugador == true ? 'Si' : 'No', style: styleTexto.titleLarge?.copyWith(color: color.outline)),
                    const Text('Jugador'),
                    const SizedBox(height: 10),
                  ]),
                  VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                  ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaHispano == true ? 'Si' : 'No', style: styleTexto.titleLarge?.copyWith(color: color.outline)),
                    const Text('Hispano'),
                    const SizedBox(height: 10),
                  ]),
                  VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                  ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
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
}
