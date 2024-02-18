import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class JugadorCommons {
  Widget informacionJugadorLite(JugadorDto jugador) {
    final ColorScheme color = AppTheme().color;
    return Visibility(
        visible: jugador.mostrarInformacion,
        replacement: const Center(child: Text('Jugador sin informacion')),
        child: Column(
          children: [
            Visibility(visible: jugador.pronombre != null, child: Text(jugador.pronombre.toString())),
            Visibility(visible: jugador.gentilicio != null, child: Text(jugador.gentilicio.toString())),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomLinks().link(jugador.urlYoutube, FontAwesomeIcons.youtube),
              Visibility(
                  visible: jugador.urlYoutube != null && jugador.urlTwitch != null,
                  child: VerticalDivider(
                    color: color.tertiary,
                  )),
              CustomLinks().link(jugador.urlTwitch, FontAwesomeIcons.twitch)
            ])
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
              if (mostrarTitulo) Center(child: Text('Información Jugador', style: styleTexto.titleMedium)),
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
                                style: styleTexto.labelSmall?.copyWith(color: color.inverseSurface.withOpacity(0.7)))),
                        Visibility(
                            visible: detalleJugador.gentilicio != null,
                            child: Text(detalleJugador.gentilicio.toString(),
                                style: styleTexto.labelSmall?.copyWith(color: color.inverseSurface.withOpacity(0.7)))),
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
}
