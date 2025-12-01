import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_hit/config/helpers/app_info.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

import 'package:no_hit/presentation/views/juegos/detalle_juego_view.dart';
import 'package:no_hit/presentation/views/jugadores/jugador_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class DetallePartidaView extends ConsumerStatefulWidget {
  final int partidaId;
  final int jugadorId;
  final int idJuego;
  final String nombreJuego;
  final String heroTag;

  const DetallePartidaView(
      {super.key, required this.partidaId, required this.jugadorId, required this.heroTag, required this.idJuego, required this.nombreJuego});

  @override
  DetallePartidaState createState() => DetallePartidaState();
}

class DetallePartidaState extends ConsumerState<DetallePartidaView> {
  final double tamanioImagen = 150;
  late ColorScheme color;
  late TextTheme styleTexto;
  late Size size;
  late JuegoDto? juegoDto;
  IconData iconoFlechaAtras = Icons.arrow_back;

  int pageViewIndex = 0;

  final Map<int, String> titulosPageView = {0: '', 1: 'Detalle partida'};

  ValueNotifier<double> offset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    ref.read(detallePartidaProvider.notifier).loadData(widget.partidaId);
    ref.read(detalleJugadorProvider.notifier).loadData(widget.jugadorId);

    if (Platform.isIOS) {
      iconoFlechaAtras = Icons.arrow_back_ios_new;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    juegoDto = ref.watch(informacionJuegoProvider)[widget.idJuego];
    final PartidaDto? detallePartida = ref.watch(detallePartidaProvider)[widget.partidaId];
    final JugadorDto? detalleJugador = ref.watch(detalleJugadorProvider)[widget.jugadorId];
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    return PopScope(
      canPop: pageViewIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controlarBack(context);
      },
      child: ValueListenableBuilder(
          valueListenable: offset,
          builder: (BuildContext context, offsetValue, _) => SafeArea(
                child: Scaffold(
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
                            color: color.tertiary,
                            highlightColor: color.tertiary,
                            icon: Icon(iconoFlechaAtras),
                          ),
                        ),
                      ),
                      forceMaterialTransparency: true,
                      elevation: 0,
                      title: Text(titulosPageView[pageViewIndex]!),
                    ),
                    extendBodyBehindAppBar: true,
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          cabecera(context, widget.heroTag, offsetValue),
                          JuegoCommons().subtitulo(
                              juegoDto!,
                              () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                                    return FadeTransition(
                                        opacity: animation,
                                        child: DetalleJuego(
                                          idJuego: juegoDto!.id,
                                          heroTag: widget.heroTag,
                                        ));
                                  })),
                              context),
                          _resumenPartida(juegoDto!, detallePartida, detalleJugador),
                          if (detalleJugador != null && detallePartida != null) ...{
                            _recordPartida(detallePartida),
                            _informacionJugadorMejorada(detalleJugador),
                            _videos(detallePartida.listaVideosCompletos, 'Videos', "La partida no tiene videos."),
                            _videos(detallePartida.listaVideosClips, 'Clips', "La partida no tiene clips."),
                            SizedBox(height: 20),
                          }
                        ],
                      ),
                    )),
              )),
    );
  }

  void controlarBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget cabecera(BuildContext context, final String heroTag, final double offset) {
    return SizedBox(
      height: AppInfo().porcentajeAlto(0.45),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: color.tertiary, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150), bottomRight: Radius.circular(150))),
            height: AppInfo().porcentajeAlto(0.24),
          ),
          Center(
            child: Container(
              width: AppInfo().porcentajeAncho(0.57),
              height: AppInfo().porcentajeAlto(0.57),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.primary,
              ),
            ),
          ),
          Hero(
            tag: widget.heroTag,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: AppInfo().porcentajeAlto(0.13)),
                child: Container(
                  width: AppInfo().porcentajeAncho(0.43),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(juegoDto!.urlImagen!, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contenido(JuegoDto? juegoDto, JugadorDto detalleJugador, PartidaDto detallePartida) {
    return SafeArea(
      child: ListView(
        children: [const SizedBox(height: 20)],
      ),
    );
  }

  Widget _videos(final List<String> videos, final String titulo, final String mensajeVacio) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 2),
        color: color.surfaceContainerHighest.withValues(alpha: 0.7),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(titulo,
                      style: styleTexto.titleMedium?.copyWith(
                        color: color.tertiary,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                const SizedBox(height: 12),
                if (videos.isNotEmpty)
                  Center(
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          return link(videos[index]);
                        },
                      ),
                    ),
                  )
                else
                  Center(
                    child: Text(mensajeVacio,
                        textAlign: TextAlign.center,
                        style: styleTexto.bodySmall?.copyWith(
                          color: color.outline.withValues(alpha: 0.5),
                        )),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget link(final String linkVideo) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: CustomLinks().link(linkVideo, linkVideo.contains("youtu") ? FontAwesomeIcons.youtube : FontAwesomeIcons.twitch, tamanio: 40),
    );
  }

  Widget _recordPartida(final PartidaDto detallePartida) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 2),
        color: color.surfaceContainerHighest.withValues(alpha: 0.7),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Center(
                            child: Text(AppLocalizations.of(context)!.es_primera_partida,
                                style: styleTexto.titleMedium?.copyWith(
                                  color: color.tertiary,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _mostrarInfoRecordPartida(),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.primary.withValues(alpha: 0.3),
                                ),
                                child: Icon(
                                  Icons.help_outline,
                                  size: 18,
                                  color: color.tertiary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _recordItem(
                        valor: detallePartida.primeraPartidaJugador == true ? 'Si' : 'No',
                        etiqueta: AppLocalizations.of(context)!.jugadores(false.toString()),
                      ),
                    ),
                    Expanded(
                      child: _recordItem(
                        valor: detallePartida.primeraPartidaHispano == true ? 'Si' : 'No',
                        etiqueta: AppLocalizations.of(context)!.hispano,
                      ),
                    ),
                    Expanded(
                      child: _recordItem(
                        valor: detallePartida.primeraPartidaMundo == true ? 'Si' : 'No',
                        etiqueta: AppLocalizations.of(context)!.mundial,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumenPartida(JuegoDto juegoDto, PartidaDto? detallePartida, JugadorDto? detalleJugador) {
    if (detallePartida == null || detalleJugador == null) {
      return SizedBox(height: 100, child: PantallaCargaBasica(texto: AppLocalizations.of(context)!.consultando_partidas));
    }

    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 2),
        color: color.surfaceContainerHighest.withValues(alpha: 0.7),
      ),
      child: Column(
        children: [
          _resumenPartidaItem(
            icon: Icons.person_outline,
            titulo: detalleJugador.nombre.toString(),
            subtitulo: AppLocalizations.of(context)!.jugadores(false.toString()),
            mostrarDivisor: true,
          ),
          _resumenPartidaItem(
            icon: Icons.calendar_today_outlined,
            titulo: HumanFormat.fecha(detallePartida.fecha),
            subtitulo: AppLocalizations.of(context)!.fecha_partida,
            mostrarDivisor: true,
            alineacionInversa: true,
          ),
          _resumenPartidaItem(
            icon: Icons.videogame_asset_outlined,
            titulo: detallePartida.nombre.toString(),
            subtitulo: AppLocalizations.of(context)!.nombre_partida,
            mostrarDivisor: false,
          ),
        ],
      ),
    );
  }

  Widget _resumenPartidaItem(
      {required IconData icon, required String titulo, required String subtitulo, required bool mostrarDivisor, bool alineacionInversa = false}) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: !alineacionInversa ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  if (!alineacionInversa) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.primary.withValues(alpha: 0.5),
                      ),
                      child: Icon(
                        icon,
                        color: color.tertiary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: color.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitulo,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: color.outline.withValues(alpha: 0.5),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (alineacionInversa) ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            titulo,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: color.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitulo,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: color.outline.withValues(alpha: 0.5),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.primary.withValues(alpha: 0.5),
                      ),
                      child: Icon(
                        icon,
                        color: color.tertiary,
                        size: 24,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (mostrarDivisor)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: color.tertiary.withValues(alpha: 0.15),
              height: 1,
            ),
          ),
      ],
    );
  }

  Widget _informacionJugadorMejorada(final JugadorDto detalleJugador) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: detalleJugador.id!));
      })),
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 2),
          color: color.surfaceContainerHighest.withValues(alpha: 0.7),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.primary.withValues(alpha: 0.5),
                    ),
                    child: BanderaJugador(codigoBandera: detalleJugador.codigoBandera, tamanio: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detalleJugador.nombre.toString(),
                          style: styleTexto.titleMedium?.copyWith(
                            color: color.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (detalleJugador.pronombre != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            detalleJugador.pronombre.toString(),
                            style: styleTexto.bodySmall?.copyWith(
                              color: color.outline.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                        if (detalleJugador.gentilicio != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            detalleJugador.gentilicio.toString(),
                            style: styleTexto.labelSmall?.copyWith(
                              color: color.outline.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (detalleJugador.urlYoutube != null) CustomLinks().link(detalleJugador.urlYoutube, FontAwesomeIcons.youtube, tamanio: 30),
                      if (detalleJugador.urlTwitch != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: CustomLinks().link(detalleJugador.urlTwitch, FontAwesomeIcons.twitch, tamanio: 30),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordItem({required String valor, required String etiqueta}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: valor.contains("Si") ? color.surfaceBright.withValues(alpha: 0.3) : color.error.withValues(alpha: 0.3),
          ),
          child: Text(
            valor,
            style: styleTexto.titleMedium?.copyWith(
              color: color.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
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
    );
  }

  void _mostrarInfoRecordPartida() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.es_primera_partida,
                    style: styleTexto.titleLarge?.copyWith(
                      color: color.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: color.tertiary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: color.tertiary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              _infoRecordItem(
                titulo: AppLocalizations.of(context)!.jugadores(false.toString()),
                descripcion: 'Indica si esta fue la primera run del jugador.',
              ),
              const SizedBox(height: 16),
              _infoRecordItem(
                titulo: AppLocalizations.of(context)!.hispano,
                descripcion: 'Indica si esta fue la primera vez que un jugador logra este reto dentro de la comunidad Hispana.',
              ),
              const SizedBox(height: 16),
              _infoRecordItem(
                titulo: AppLocalizations.of(context)!.mundial,
                descripcion: 'Indica si esta fue la primera vez que un jugador logra este reto dentro de la comunidad mundial.',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRecordItem({required String titulo, required String descripcion}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: styleTexto.titleSmall?.copyWith(
            color: color.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          descripcion,
          style: styleTexto.bodySmall?.copyWith(
            color: color.outline.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
