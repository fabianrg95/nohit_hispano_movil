import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class JugadorCommons {
  Widget informacionJugadorLite(JugadorDto jugador, BuildContext context) {
    final ColorScheme color = AppTheme().color;
    final TextTheme styleTexto = Theme.of(context).textTheme;

    return Visibility(
        visible: jugador.mostrarInformacion,
        replacement: Center(
            child: Text(AppLocalizations.of(context)!.jugador_sin_informacion,
                style: styleTexto.bodySmall?.copyWith(color: color.outline.withValues(alpha: 0.5)))),
        child: Column(
          children: [
            if (jugador.pronombre != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: color.primary.withValues(alpha: 0.1),
                  border: Border.all(color: color.primary.withValues(alpha: 0.3), width: 1),
                ),
                child: Text(
                  jugador.pronombre.toString(),
                  style: styleTexto.bodyMedium?.copyWith(
                    color: color.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (jugador.gentilicio != null) ...[
              const SizedBox(height: 8),
              Text(
                jugador.gentilicio.toString(),
                style: styleTexto.bodySmall?.copyWith(
                  color: color.outline.withValues(alpha: 0.6),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (jugador.urlYoutube != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.primary.withValues(alpha: 0.1),
                      border: Border.all(color: color.primary.withValues(alpha: 0.3), width: 1),
                    ),
                    child: CustomLinks().link(jugador.urlYoutube, FontAwesomeIcons.youtube, tamanio: 20),
                  ),
                if (jugador.urlYoutube != null && jugador.urlTwitch != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: VerticalDivider(
                      color: color.tertiary.withValues(alpha: 0.3),
                      thickness: 1,
                    ),
                  ),
                if (jugador.urlTwitch != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.primary.withValues(alpha: 0.1),
                      border: Border.all(color: color.primary.withValues(alpha: 0.3), width: 1),
                    ),
                    child: CustomLinks().link(jugador.urlTwitch, FontAwesomeIcons.twitch, tamanio: 20),
                  ),
              ],
            )
          ],
        ));
  }

  Widget informacionJugadorGrande(final JugadorDto detalleJugador, final BuildContext context, {final bool mostrarTitulo = true}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: detalleJugador.id!));
      })),
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: ViewData().decorationContainerBasic(color: color),
        child: IntrinsicHeight(
          child: Column(
            children: [
              if (mostrarTitulo) Center(child: Text(AppLocalizations.of(context)!.informacion_jugador, style: styleTexto.titleMedium)),
              if (mostrarTitulo) const SizedBox(height: 10),
              if (mostrarTitulo) Divider(color: color.tertiary, thickness: 2, height: 1),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30),
                    child: BanderaJugador(codigoBandera: detalleJugador.codigoBandera, tamanio: 50),
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
                            child: Text(detalleJugador.pronombre.toString(),
                                style: styleTexto.labelSmall?.copyWith(color: color.inverseSurface.withAlpha(70)))),
                        Visibility(
                            visible: detalleJugador.gentilicio != null,
                            child: Text(detalleJugador.gentilicio.toString(),
                                style: styleTexto.labelSmall?.copyWith(color: color.inverseSurface.withAlpha(70)))),
                        const SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          CustomLinks().link(detalleJugador.urlYoutube, FontAwesomeIcons.youtube),
                          Visibility(
                              visible: detalleJugador.urlYoutube != null && detalleJugador.urlTwitch != null,
                              child: VerticalDivider(
                                color: color.tertiary,
                              )),
                          CustomLinks().link(detalleJugador.urlTwitch, FontAwesomeIcons.twitch)
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

  Widget informacionJugadorMejorada(final JugadorDto detalleJugador, final BuildContext context, {final bool mostrarBandera = true}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: detalleJugador.id!));
      })),
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
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
                  Visibility(
                    visible: mostrarBandera,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.primary.withValues(alpha: 0.5),
                      ),
                      child: BanderaJugador(codigoBandera: detalleJugador.codigoBandera, tamanio: 30),
                    ),
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
}
