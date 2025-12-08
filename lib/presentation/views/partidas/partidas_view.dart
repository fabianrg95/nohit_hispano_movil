import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

enum PartidaViewMode { grande, compacto }

class FadeInListItem extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeInListItem({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Interval(
        (0.1 * index).clamp(0.0, 1.0),
        1.0,
        curve: curve,
      ),
      child: child,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0.0, (1 - value) * 20),
            child: child,
          ),
        );
      },
    );
  }
}

class PartidasView extends ConsumerStatefulWidget {
  static const nombre = 'partidas_view';

  const PartidasView({super.key});

  @override
  PartidasViewState createState() => PartidasViewState();
}

class PartidasViewState extends ConsumerState<PartidasView> {
  List<PartidaDto>? listaUltimasPartidas = [];
  late ColorScheme color;
  final ScrollController scrollController = ScrollController();
  PartidaViewMode _viewMode = PartidaViewMode.grande;

  @override
  void initState() {
    super.initState();
    _cargarPartidas();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 500) > scrollController.position.maxScrollExtent) {
        _cargarPartidas();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listaUltimasPartidas = ref.watch(ultimasPartidasProvider);
    color = Theme.of(context).colorScheme;

    return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, __, ___) => const InicioView()));
        },
        child: SafeArea(
          child: Scaffold(
            drawer: const CustomNavigation(),
            appBar: _titulo(context),
            body: RefreshIndicator(
              onRefresh: () => _reiniciarPartidas(),
              color: color.surfaceTint,
              backgroundColor: color.tertiary,
              child: _contenido(listaUltimasPartidas),
            ),
          ),
        ));
  }

  Future<void> _cargarPartidas() async {
    setState(() {
      ref.read(ultimasPartidasProvider.notifier).loadData();
    });
  }

  Future<void> _reiniciarPartidas() async {
    setState(() {
      ref.read(ultimasPartidasProvider.notifier).reloadData();
    });
  }

  AppBar _titulo(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(AppLocalizations.of(context)!.ultimas_partidas),
      centerTitle: true,
      forceMaterialTransparency: true,
      actions: [
        IconButton(
          icon: Icon(
            _viewMode == PartidaViewMode.grande ? Icons.view_agenda_rounded : Icons.view_stream_rounded,
            color: color.tertiary,
          ),
          onPressed: () {
            setState(() {
              _viewMode = _viewMode == PartidaViewMode.grande ? PartidaViewMode.compacto : PartidaViewMode.grande;
            });
          },
          tooltip: _viewMode == PartidaViewMode.grande ? 'Vista compacta' : 'Vista ampliada',
        ),
      ],
    );
  }

  Widget _contenido(final List<PartidaDto>? listaUltimasPartidas) {
    if (listaUltimasPartidas == null || listaUltimasPartidas.isEmpty) {
      return PantallaCargaBasica(texto: AppLocalizations.of(context)!.consultando_ultimas_partidas);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
      child: ListView.builder(
        controller: scrollController,
        itemCount: listaUltimasPartidas.length,
        itemBuilder: (context, index) {
          return FadeInListItem(
            index: index,
            child: _viewMode == PartidaViewMode.grande
                ? _itemPartidaGrande(
                    partida: listaUltimasPartidas[index],
                    context: context,
                  )
                : _itemPartidaCompacto(
                    partida: listaUltimasPartidas[index],
                    context: context,
                  ),
          );
        },
      ),
    );
  }

  Widget _itemPartidaGrande({required PartidaDto partida, required BuildContext context}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme estiloTexto = Theme.of(context).textTheme;
    final String heroTag = 'partida_${partida.id}';

    return GestureDetector(
      onTap: () {
        ref.read(informacionJuegoProvider.notifier).saveData(juegoDto: partida.getJuegoDto());
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, __) => FadeTransition(
              opacity: animation,
              child: DetallePartidaView(
                partidaId: partida.id,
                jugadorId: partida.idJugador,
                heroTag: heroTag,
                idJuego: partida.idJuego,
                nombreJuego: partida.tituloJuego.toString(),
              ),
            ),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.tertiary.withValues(alpha: 0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: null, // Handled by parent GestureDetector
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game Image with Hero Animation
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(
                      children: [
                        // Game Image
                        if (partida.urlImagenJuego != null)
                          Image.network(
                            partida.urlImagenJuego!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 160,
                                color: color.surfaceContainerHighest.withValues(alpha: 0.3),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: color.primary,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 160,
                              color: color.errorContainer,
                              child: Icon(Icons.broken_image, color: color.onErrorContainer),
                            ),
                          ),

                        // Gradient Overlay
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),

                        // Game Title Overlay
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 12,
                          child: Text(
                            partida.nombre ?? 'Sin título',
                            style: estiloTexto.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  offset: const Offset(1, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Player and Date Row
                      Row(
                        children: [
                          // Player Avatar
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color.primary,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              color: color.tertiary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Player Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  partida.nombreJugador ?? 'Jugador',
                                  style: estiloTexto.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: color.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${HumanFormat.fechaDia(partida.fecha.toString())} • ${HumanFormat.fechaMes(partida.fecha.toString())} • ${HumanFormat.fechaAnio(partida.fecha.toString())}',
                                  style: estiloTexto.bodySmall?.copyWith(
                                    color: color.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Game Info
                      if (partida.tituloJuego != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  partida.tituloJuego!,
                                  style: estiloTexto.bodyMedium?.copyWith(
                                    color: color.onSurface.withValues(alpha: 0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemPartidaCompacto({required PartidaDto partida, required BuildContext context}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme estiloTexto = Theme.of(context).textTheme;
    final String heroTag = 'partida_${partida.id}';

    return GestureDetector(
      onTap: () {
        ref.read(informacionJuegoProvider.notifier).saveData(juegoDto: partida.getJuegoDto());
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, __) => FadeTransition(
              opacity: animation,
              child: DetallePartidaView(
                partidaId: partida.id,
                jugadorId: partida.idJugador,
                heroTag: heroTag,
                idJuego: partida.idJuego,
                nombreJuego: partida.tituloJuego.toString(),
              ),
            ),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: 160,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game Image with Hero Animation
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: color.tertiary,
                      ),
                      child: partida.urlImagenJuego != null
                          ? Image.network(
                              partida.urlImagenJuego!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: color.primary,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.sports_esports_rounded,
                                  size: 40,
                                  color: color.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.sports_esports_rounded,
                                size: 40,
                                color: color.onSurface.withValues(alpha: 0.3),
                              ),
                            ),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: color.onSurface,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${HumanFormat.fechaDia(partida.fecha.toString())} • ${HumanFormat.fechaMes(partida.fecha.toString())} • ${HumanFormat.fechaAnio(partida.fecha.toString())}",
                              style: estiloTexto.labelSmall?.copyWith(
                                color: color.onSurface.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Game Title
                        Text(
                          partida.nombre ?? 'Partida sin título',
                          style: estiloTexto.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Game Subtitle
                        if (partida.tituloJuego != null)
                          Text(
                            partida.tituloJuego!,
                            style: estiloTexto.bodySmall?.copyWith(
                              color: color.onSurface.withValues(alpha: 0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        const Spacer(),

                        // Player and Date Row
                        Column(
                          children: [
                            Row(
                              children: [
                                // Player Avatar
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: color.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 16,
                                    color: color.tertiary,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Player Name
                                Expanded(
                                  child: Text(
                                    partida.nombreJugador ?? 'Jugador',
                                    style: estiloTexto.bodyMedium?.copyWith(
                                      color: color.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Additional Info
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
