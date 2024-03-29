import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/presentation/views/jugadores/jugador_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

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

  Padding contenidoItemJugador(ColorScheme color, TextTheme styleTexto) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Container(
          decoration: ViewData().decorationContainerBasic(color: color),
          child: ListTile(
            trailing: BanderaJugador(codigoBandera: jugador.codigoBandera, tamanio: 38),
            title: Text(jugador.nombre!, style: styleTexto.titleMedium, maxLines: 2),
            subtitle: jugador.cantidadPartidasJuego == 0 ? null : Text("${jugador.cantidadPartidasJuego} partidas en este juego"),
          ),
        ));
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
