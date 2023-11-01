import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/delegates/delegates.dart';
import 'package:no_hit/presentation/views/views.dart';
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
                    _videos(detallePartida.listaVideosCompletos, 'Videos completos', "La partida no tiene videos."),
                    _videos(detallePartida.listaVideosClips, 'Clips', "La partida no tiene clips."),
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
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Center(child: Text('Informacion Jugador', style: styleTexto.titleMedium)),
              const SizedBox(height: 10),
              Divider(color: color.tertiary, thickness: 2, height: 1),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30),
                    child: BanderaJugador(codigoBandera: detalleJugador.codigoBandera, tamanio: 70, defaultNegro: true),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Center(child: Text(detalleJugador.nombre.toString(), style: styleTexto.bodyLarge, textAlign: TextAlign.center)),
                        Visibility(
                            visible: detalleJugador.pronombre != null,
                            child: Text(detalleJugador.pronombre.toString(), style: styleTexto.labelSmall)),
                        Visibility(
                            visible: detalleJugador.gentilicio != null,
                            child: Text(detalleJugador.gentilicio.toString(), style: styleTexto.labelSmall)),
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
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
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
                  padding: const EdgeInsets.only(left: 20),
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
                        child: Text(detallePartida.nombre.toString(),
                            textAlign: TextAlign.center, style: styleTexto.bodyLarge?.copyWith(color: AppTheme.textoResaltado))))
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
      decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
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
      decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
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
                    Text(detallePartida.primeraPartidaJugador == true ? 'Si' : 'No',
                        style: styleTexto.titleLarge?.copyWith(color: AppTheme.textoResaltado)),
                    const Text('Jugador'),
                    const SizedBox(height: 10),
                  ]),
                  VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                  ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaHispano == true ? 'Si' : 'No',
                        style: styleTexto.titleLarge?.copyWith(color: AppTheme.textoResaltado)),
                    const Text('Hispano'),
                    const SizedBox(height: 10),
                  ]),
                  VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                  ViewData().muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                    const SizedBox(height: 10),
                    Text(detallePartida.primeraPartidaMundo == true ? 'Si' : 'No',
                        style: styleTexto.titleLarge?.copyWith(color: AppTheme.textoResaltado)),
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

  Widget _subtitulo(final JuegoDto juegoDto) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, __) {
          return FadeTransition(opacity: animation, child: DetalleJuego(juego: juegoDto));
        },
      )),
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(left: 25, right: 25),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
        child: Column(children: [
          Text(juegoDto.nombre.toString(), style: styleTexto.titleLarge),
          Visibility(
            visible: juegoDto.subtitulo != null,
            child: Text(juegoDto.subtitulo.toString(), style: styleTexto.titleMedium),
          ),
        ]),
      ),
    );
  }
}
