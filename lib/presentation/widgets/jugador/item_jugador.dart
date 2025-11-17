import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/presentation/views/jugadores/jugador_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:no_hit/config/helpers/app_info.dart';

class ItemJugador extends StatelessWidget {
  final JugadorDto jugador;
  final Function? accion;

  const ItemJugador({super.key, required this.jugador, this.accion});

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;

    if (accion != null) {
      return GestureDetector(
        onTap: () => accion!(),
        child: contenidoItemJugador(color, styleTexto),
      );
    } else {
      return GestureDetector(
        onTap: () => navegarJugador(context, jugador.id!),
        child: contenidoItemJugador(color, styleTexto),
      );
    }
  }

  Widget contenidoItemJugador(ColorScheme color, TextTheme styleTexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: color.secondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.tertiary.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.tertiary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: null, // Handled by parent GestureDetector
            borderRadius: BorderRadius.circular(16),
            splashColor: color.tertiary.withValues(alpha: 0.1),
            highlightColor: color.tertiary.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Player Flag
                  Hero(
                    tag: 'bandera_${jugador.id}',
                    child: BanderaJugador(
                      codigoBandera: jugador.codigoBandera,
                      tamanio: 44,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Player Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Player Name
                        Text(
                          jugador.nombre!,
                          style: styleTexto.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Runs Count
                        if (jugador.cantidadPartidasJuego > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sports_esports_outlined,
                                  size: 14,
                                  color: color.tertiary.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${jugador.cantidadPartidasJuego} ${jugador.cantidadPartidasJuego == 1 ? 'Run' : 'Runs'}',
                                  style: styleTexto.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Chevron Icon
                  Icon(
                    Icons.chevron_right_rounded,
                    color: color.tertiary.withOpacity(0.7),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> navegarJugador(final BuildContext context, final int idJugador) {
  const duration = Duration(milliseconds: 500);

  return Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    pageBuilder: (context, animation, __) => DetalleJugadorView(idJugador: idJugador),
    transitionsBuilder: (_, animation, ___, child) => FadeTransition(opacity: animation, child: child),
  ));
}
