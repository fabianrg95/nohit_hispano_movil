import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/config/helpers/utilidades.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

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
    return AppBar(
      title: Text(AppLocalizations.of(context)!.ultimas_partidas),
      centerTitle: true,
      forceMaterialTransparency: true,
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
            return _itemPartidaMinimalista(partida: listaUltimasPartidas[index], context: context);
          }),
    );
  }

  Widget _itemPartidaMinimalista({required PartidaDto partida, required BuildContext context}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme estiloTexto = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.secondary,
          borderRadius: BorderRadius.circular(20),
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
                              color: color.tertiary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color.tertiary,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              color: color.primary,
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
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${HumanFormat.fechaDia(partida.fecha.toString())} • ${HumanFormat.fechaMes(partida.fecha.toString())} • ${HumanFormat.fechaAnio(partida.fecha.toString())}',
                                  style: estiloTexto.bodySmall?.copyWith(
                                    color: color.onSurfaceVariant,
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
                          children: [
                            if (partida.tituloJuego != null) ...[
                              Icon(
                                Icons.sports_esports_outlined,
                                size: 16,
                                color: color.tertiary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  partida.tituloJuego!,
                                  style: estiloTexto.bodyMedium?.copyWith(
                                    color: color.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
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
}
